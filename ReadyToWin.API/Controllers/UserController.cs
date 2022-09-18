using ReadyToWin.Complaince.Framework.Base;
using System.Net;
using System.Net.Http;
using System.Web.Http;
using System.Threading.Tasks;
using ReadyToWin.Complaince.Entities.UserModel;
using ReadyToWin.Complaince.Bussiness.Provider.UserRepositry;
using ReadyToWin.API.Filters;
using System.Web.Http.Description;
using System.Collections.Generic;
using ReadyToWin.Complaince.Entities.RequestModels;
using ReadyToWin.Complaince.Framework.Utility;
using ReadyToWin.Complaince.Entities.ResponseModel;
using ReadyToWin.Complaince.Entities.Constant;
using System.Data;
using System;
using System.Security.Claims;
using ReadyToWin.API.Models;

namespace ReadyToWin.API.Controllers
{
    /// <summary>
    ///     
    /// </summary>
    [RoutePrefix("api/User")]
    public class UserController : BaseApiController
    {
        IUserRepository _iUserProvider;

        /// <summary>
        /// Initilize UserController.
        /// </summary>
        /// <param name="_iUserProvider"></param>
        public UserController(IUserRepository _iUserProvider)
        {
            this._iUserProvider = _iUserProvider;
        }

        /// <summary>
        /// Authenticate userid and password.
        /// </summary>
        /// <param name="model"></param>
        /// <returns></returns>
        [AllowAnonymous]
        [HttpPost]
        [Route("Authenticate")]
        [ResponseType(typeof(Response<User>))]
        public async Task<HttpResponseMessage> Post([FromBody]AuthModel model)
        {
            // check user to db
            var user = _iUserProvider.ValidateByUserId(model.UserId, model.Password);

            if (user == null)
                return await Task.Run(() => Request.CreateResponse(HttpStatusCode.NotFound, Response<User>.CreateResponse(Status.NOT_FOUND, Messages.INVALID_USER, null)));

            // create token 
            string token = _iUserProvider.CreateToken(user.UserId);
            if (string.IsNullOrEmpty(token))
            {
                user.Token = string.Empty;
                return await Task.Run(() => Request.CreateResponse(HttpStatusCode.NotFound, Response<User>.CreateResponse(Status.NOT_FOUND, Messages.TOKEN_NOT_FOUND, null)));
            }

            user.Token = token;
            return await CreateResponse(user, Convert.ToString(typeof(User).Name));
        }

        /// <summary>
        /// Add new user.
        /// </summary>
        /// <param name="user"></param>
        /// <returns></returns>
        //[CustomAuthorize(Roles = "Admin")]
        [AllowAnonymous]
        [HttpPost]
        [Route("Add")]
        [ResponseType(typeof(Response<User>))]
        public async Task<HttpResponseMessage> Add(User user)
        {
            //encrypt password.
            user.Password = EncryptionLibrary.EncryptText(user.Password);
            user.IPAdress = System.Web.HttpContext.Current.Request.ServerVariables["HTTP_X_FORWARDED_FOR"];
            if (string.IsNullOrEmpty(user.IPAdress))
            {
                user.IPAdress = System.Web.HttpContext.Current.Request.ServerVariables["REMOTE_ADDR"];
            }
            //save user
            var output = _iUserProvider.Add(user);                
            return await CreateResponse(output); 
        }

        /// <summary>
        /// Assign role to user.
        /// </summary>
        /// <returns></returns>
        [HttpPost]
        [CustomAuthorize(Roles = "Admin")]
        [Route("AssignRole")]
        [ResponseType(typeof(DbOutput))]
        public async Task<HttpResponseMessage> AssignRole([FromBody]AssignRoleModel model)
        {
            var output = _iUserProvider.AssignRole(model);
            return await CreateResponse(output);
        }

        /// <summary>
        /// Update user.
        /// </summary>
        /// <returns></returns>
        [HttpPut]
        [CustomAuthorize(Roles = "Admin,Player")]
        [Route("Edit")]
        [ResponseType(typeof(DbOutput))]
        public async Task<HttpResponseMessage> Edit(UserEdit user)
        {
            var output = _iUserProvider.Edit(user);
            return await CreateResponse(output);
        }

        /// <summary>
        /// Get User By userId.
        /// </summary>
        /// <returns></returns>
        [HttpGet]
        [CustomAuthorize(Roles = "Admin,Player")]
        [Route("GetUserById")]
        [ResponseType(typeof(Response<List<User>>))]
        public async Task<HttpResponseMessage> GetUserById(int Id)
        {
            var output = _iUserProvider.GetUserById(Id);
            return await CreateResponse(output);
        }

        /// <summary>
        /// Get All Users
        /// </summary>
        /// <returns></returns>
        [HttpGet]
        [CustomAuthorize(Roles = "Admin,Player")]
        [Route("GetAllUsers")]
        [ResponseType(typeof(Response<List<User>>))]
        public async Task<HttpResponseMessage> GetAllUsers()
        {
            var output = _iUserProvider.GetAllUser();
            return await CreateResponse(output);
        }

        /// <summary>
        /// Delete user by userid.
        /// </summary>
        /// <returns></returns>
        [HttpDelete]
        [CustomAuthorize(Roles = "Admin")]
        [Route("Delete")]
        [ResponseType(typeof(DbOutput))]
        public async Task<HttpResponseMessage> Delete(DeleteRoleModel model)
        {
            var output = _iUserProvider.Delete(model);
            return await CreateResponse(output);
        }
        
        /// <summary>
        /// Get all users. 
        /// </summary>
        /// <returns></returns>        
        [HttpGet]
        [CustomAuthorize(Roles = "Admin,Player")]
        [Route("GetAllUser")]
        [ResponseType(typeof(UserSearchRequest))]
        public async Task<HttpResponseMessage> GetAllUser([FromUri] UserSearchRequest search)
        {
           // var output = _iUserProvider.GetUsers(search);
            var output = _iUserProvider.GetUsers();
            return await CreateResponse(output,Convert.ToString(typeof(UserSearchResponse)));
        }

        /// <summary>
        /// Get all users by department.
        /// </summary>
        /// <returns></returns>
        [HttpGet]
        [CustomAuthorize(Roles = "Admin")]
        [Route("GetUsersByDepartmentId")]
        [ResponseType(typeof(Response<List<User>>))]
        public async Task<HttpResponseMessage> GetUsersByDepartmentId(long DepartmentId)
        {
            return await CreateResponse(_iUserProvider.GetUsersByDepartmentId(DepartmentId));
        }

        /// <summary>
        ///  Get logged in users.
        /// </summary>
        /// <returns></returns>
        [HttpGet]
        [CustomAuthorize(Roles = "Admin")]
        [Route("GetOnlineUsers")]
        [ResponseType(typeof(string))]
        public async Task<HttpResponseMessage> GetOnlineUsers()
        {
            int count = _iUserProvider.GetOnlineUsers();
            return await CreateResponse(count.ToString(), null, Status.FOUND, Messages.DATA_FOUND);
        }

        /// <summary>
        ///  Change password.
        /// </summary>
        /// <returns></returns>
        [HttpPost]
        [CustomAuthorize(Roles = "Admin,Player")]
        [Route("ChangePassword")]
        [ResponseType(typeof(DbOutput))]
        public async Task<HttpResponseMessage> ChangePassword([FromBody]ChangePasswordModel model)
        {
            var output = _iUserProvider.ChangePassword(model);
            return await CreateResponse(output);
        }

        /// <summary>
        ///  Reset password.
        /// </summary>
        /// <returns></returns>
        [HttpPost]
        [CustomAuthorize(Roles = "Admin,Player")]
        [Route("ResetPassword")]
        [ResponseType(typeof(DbOutput))]
        public async Task<HttpResponseMessage> ResetPassword([FromBody]ResetPasswordModel model)
        {
            var output = _iUserProvider.ResetPassword(model);
            return await CreateResponse(output);
        }

        /// <summary>
        ///  Logout.
        /// </summary>
        /// <returns></returns>
        [HttpGet]
        [CustomAuthorize(Roles = "Admin,Player")]
        [Route("Logout")]
        [ResponseType(typeof(DbOutput))]
        public async Task<HttpResponseMessage> Logout(string UserId)
        {
            var output = _iUserProvider.Logout(UserId);
            return await CreateResponse(output);
        }

        /// <summary>
        ///  GetReportByUserPermission.
        /// </summary>
        /// <returns></returns>
        [HttpGet]
        [CustomAuthorize(Roles = "Admin,Player")]
        [Route("GetReportsByUserPermission")]
        [ResponseType(typeof(DbOutput))]
        public async Task<HttpResponseMessage> GetReportByUserPermission(string UserId)
        {
            var output = _iUserProvider.GetReportsByUserPermission(UserId);
            return await CreateResponse(output);
        }


        /// <summary>
        ///  GenerateCSV.
        /// </summary>
        /// <returns></returns>
        [HttpGet]
        [CustomAuthorize(Roles = "Admin")]
        [Route("GenerateCSV")]
        [ResponseType(typeof(DbOutput))]
        public async Task<HttpResponseMessage> GenerateCSV()
        {
            var output = _iUserProvider.GenerateCSV();
            return await CreateResponse(output, Convert.ToString(typeof(DataTable)));
        }


        /// <summary>
        ///  GetReportByUserPermission.
        /// </summary>
        /// <returns></returns>
        [HttpGet]
        [CustomAuthorize(Roles = "Admin")]
        [Route("SendPasswordChangeEmail")]
        [ResponseType(typeof(DbOutput))]
        public async Task<HttpResponseMessage> SendPasswordChangeEmail(string userId)
        {
            var output = _iUserProvider.SendPasswordChangeEmail(userId);
            return await CreateResponse(output);
        }

        //[Route("Validate")]
        //[HttpGet]
        //public Task<HttpResponseMessage> Validate(string token, string username)
        //{
        //    int UserId =  new UserRepository().GetUser(username);
        //    if (UserId == 0) return new ResponseVM
        //    {
        //        Status = "Invalid",
        //        Message = "Invalid User."
        //    };
        //    string tokenUsername = TokenManager.ValidateToken(token);
        //    if (username.Equals(tokenUsername))
        //    {
        //        return new ResponseVM
        //        {
        //            Status = "Success",
        //            Message = "OK",
        //        };
        //    }
        //    return new ResponseVM
        //    {
        //        Status = "Invalid",
        //        Message = "Invalid Token."
        //    };
        //}
        
    }
}