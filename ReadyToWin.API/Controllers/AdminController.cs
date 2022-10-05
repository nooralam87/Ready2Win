using System.Net.Http;
using System.Threading.Tasks;
using System.Web.Http;
using System.Web.Http.Description;
using ReadyToWin.API.Filters;
using ReadyToWin.Complaince.BussinessProvider.IProviders;
using ReadyToWin.Complaince.Entities.AdminModel;
using ReadyToWin.Complaince.Entities.ResponseModel;
using ReadyToWin.Complaince.Entities.UserTransaction;
using ReadyToWin.Complaince.Framework.Base;

namespace ReadyToWin.API.Controllers
{
    [RoutePrefix("api/Admin")]
    public class AdminController : BaseApiController
    {
       IUserTransaction _iUserTransaction;
       IAdminRepository _iAdminRepository;
       public AdminController(IUserTransaction _iUserTransaction, IAdminRepository _iAdminRepository)
       {
           this._iUserTransaction = _iUserTransaction;
           this._iAdminRepository = _iAdminRepository;
       }
        /// <summary>
        /// Delete Winner User Details 
        /// </summary>
        /// <param name="user"></param>
        /// <returns></returns>
        [CustomAuthorize(Roles = "Admin")]
        [AllowAnonymous]
        [HttpPost]
        [Route("UserDepositAmountApproved")]
        [ResponseType(typeof(Response<Admin>))]
        public async Task<HttpResponseMessage> UserDepositAmountApproved(Admin userAmountApproved)
        {
            var output = _iAdminRepository.UserDepositAmountApproved(userAmountApproved);
            return await CreateResponse(output);
        }

        /// <summary>
        /// Delete Winner User Details 
        /// </summary>
        /// <param name="user"></param>
        /// <returns></returns>
        [CustomAuthorize(Roles = "Admin")]
        [AllowAnonymous]
        [HttpPost]
        [Route("UserWithdrawAmountApproved")]
        [ResponseType(typeof(Response<Admin>))]
        public async Task<HttpResponseMessage> UserWithdrawAmountApproved(Admin userAmountWithdraw)
        {
            var output = _iAdminRepository.UserWithdrawAmountApproved(userAmountWithdraw);
            return await CreateResponse(output);
        }
        /// <summary>
        /// Select All user amount deposited
        /// </summary>
        /// <param name="user"></param>
        /// <returns></returns>
        [CustomAuthorize(Roles = "Admin")]
       [AllowAnonymous]
       [HttpGet]
       [Route("ListOfUserAmountDeposit")]
       [ResponseType(typeof(Response<Admin>))]
       public async Task<HttpResponseMessage> ListOfUserAmountDeposit()
       {
           var output = _iUserTransaction.ListOfUserAmountDeposit();
           return await CreateResponse(output);
       }

        /// <summary>
        /// Select perticular user amount deposited by User by record id For Admin
        /// </summary>
        /// <param name="user"></param>
        /// <returns></returns>
        [CustomAuthorize(Roles = "Admin")]
        [AllowAnonymous]
        [HttpGet]
        [Route("ListOfUserAmountDepositbyId")]
        [ResponseType(typeof(Response<UserAmountDeposit>))]
        public async Task<HttpResponseMessage> ListOfUserAmountDepositbyId(long Id)
        {
            UserAmountDeposit userAmountdeposit = new UserAmountDeposit() { Id = Id };
            var output = _iUserTransaction.ListOfUserAmountDepositbyId(userAmountdeposit);
            return await CreateResponse(output);
        }

       [CustomAuthorize(Roles = "Admin")]
       [AllowAnonymous]
       [HttpPost]
       [Route("UpdateAmountDeposit")]
       [ResponseType(typeof(Response<Admin>))]
       public async Task<HttpResponseMessage> UpdateAmountDeposit(UserAmountDeposit userAmountdeposit)
       {
           var output = _iUserTransaction.UpdateAmountDeposit(userAmountdeposit);
           return await CreateResponse(output);
       }


       /// <summary>
       /// List of User withdraw request 
       /// </summary>
       /// <param name="user"></param>
       /// <returns></returns>
       [CustomAuthorize(Roles = "Admin")]
       [AllowAnonymous]
       [HttpGet]
       [Route("ListOfUserWithdrawRequest")]
       [ResponseType(typeof(Response<Admin>))]
       public async Task<HttpResponseMessage> ListOfUserWithdrawRequest()
       {
           var output = _iUserTransaction.ListOfUserWithdrawRequest();
           return await CreateResponse(output);
       }

        /// <summary>
        /// List of User withdraw request 
        /// </summary>
        /// <param name="user"></param>
        /// <returns></returns>
        [CustomAuthorize(Roles = "Admin")]
        [AllowAnonymous]
        [HttpGet]
        [Route("ListOfUserWithdrawRequestbyId")]
        [ResponseType(typeof(Response<Admin>))]
        public async Task<HttpResponseMessage> ListOfUserWithdrawRequestbyId(long Id)
        {
            UserAmountWithdraw userAmountwithdraw = new UserAmountWithdraw() { Id = Id };
            var output = _iUserTransaction.ListOfUserWithdrawRequestbyId(userAmountwithdraw);
            return await CreateResponse(output);
        }
        /// <summary>
        /// Update UserWithdraw Request.
        /// </summary>
        /// <param name="user"></param>
        /// <returns></returns>
       [CustomAuthorize(Roles = "Admin, User")]
       [AllowAnonymous]
       [HttpPost]
       [Route("UpdateWithdrawRequest")]
       [ResponseType(typeof(Response<Admin>))]
       public async Task<HttpResponseMessage> UpdateWithdrawRequest(UserAmountWithdraw userAmountwithdraw)
       {
           var output = _iUserTransaction.UpdateWithdrawRequest(userAmountwithdraw);
           return await CreateResponse(output);
       }
        [CustomAuthorize(Roles = "Admin")]
        [AllowAnonymous]
        [HttpPost]
        [Route("DeclaredWinningNumber")]
        [ResponseType(typeof(Response<Admin>))]
        public async Task<HttpResponseMessage> DeclaredWinningNumber(Admin adminModel)
        {
            var output = _iAdminRepository.DeclaredWinningNumber(adminModel);
            return await CreateResponse(output);
        }

        ///// <summary>
        ///// Update UserWithdraw Request.
        ///// </summary>
        ///// <param name="user"></param>
        ///// <returns></returns>
        ////[CustomAuthorize(Roles = "Admin")]
        //[AllowAnonymous]
        //[HttpPost]
        //[Route("DeleteWithdrawRequest")]
        //[ResponseType(typeof(Response<Admin>))]
        //public async Task<HttpResponseMessage> DeleteWithdrawRequest(UserAmountWithdraw userAmountwithdraw)
        //{
        //    var output = _iUserTransaction.DeleteWithdrawRequest(userAmountwithdraw);
        //    return await CreateResponse(output);
        //}

        ///// <summary>
        ///// Insert Winning Amount For User
        ///// </summary>
        ///// <param name="user"></param>
        ///// <returns></returns>
        //[CustomAuthorize(Roles = "Admin")]
        //[AllowAnonymous]
        //[HttpPost]
        //[Route("InsertWinningAmountForUser")]
        //[ResponseType(typeof(Response<Admin>))]
        //public async Task<HttpResponseMessage> InsertWinningAmountForUser(Admin insertWinningAmount)
        //{
        //    var output = _iAdminRepository.InsertWinningAmountForUser(insertWinningAmount);
        //    return await CreateResponse(output);
        //}

        /// <summary>
        /// List of winner user
        /// </summary>
        /// <param name="user"></param>
        /// <returns></returns>
        //[CustomAuthorize(Roles = "Admin")]
        //[AllowAnonymous]
        //[HttpGet]
        //[Route("ListOfWinningUsers")]
        //[ResponseType(typeof(Response<Admin>))]
        //public async Task<HttpResponseMessage> ListOfWinningUsers()
        //{
        //    var output = _iAdminRepository.ListOfWinningUsers();
        //    return await CreateResponse(output);
        //}

        /// <summary>
        /// List of winner user by Id
        /// </summary>
        /// <param name="user"></param>
        /// <returns></returns>
        //[CustomAuthorize(Roles = "Admin")]
        //[AllowAnonymous]
        //[HttpGet]
        //[Route("ListOfWinningUsersById")]
        //[ResponseType(typeof(Response<Admin>))]
        //public async Task<HttpResponseMessage> ListOfWinningUsersById(long Id)
        //{
        //     Admin adminlist = new Admin() { Id = Id };
        //     var output = _iAdminRepository.ListOfWinningUsersById(Id);
        //    return await CreateResponse(output);
        //}

        /// <summary>
        /// Update Winner User Details 
        /// </summary>
        /// <param name="user"></param>
        /// <returns></returns>
        //[CustomAuthorize(Roles = "Admin")]
        //[AllowAnonymous]
        //[HttpPost]
        //[Route("UpdateWinningUser")]
        //[ResponseType(typeof(Response<Admin>))]
        //public async Task<HttpResponseMessage> UpdateWinningUser(Admin updateWinningUser)
        //{
        //    var output = _iAdminRepository.UpdateWinningUser(updateWinningUser);
        //    return await CreateResponse(output);
        //}

        // [CustomAuthorize(Roles = "Admin")]
        // [AllowAnonymous]
        // [HttpGet]
        // [Route("ListOfWinningUsersById")]
        // [ResponseType(typeof(Response<Admin>))]
        // public async Task<HttpResponseMessage> ListOfWinningUsersById(long Id)
        // {
        //     Admin adminlist = new Admin() { Id = Id };
        //     var output = _iAdminRepository.ListOfWinningUsersById(adminlist);
        //     return await CreateResponse(output);
        // }

        /// <summary>
        /// Update Winner User Details 
        /// </summary>
        /// <param name="user"></param>
        /// <returns></returns>
        //[CustomAuthorize(Roles = "Admin")]
        //[AllowAnonymous]
        //[HttpGet]
        //[Route("ListOfUserWinningByUserId")]
        //[ResponseType(typeof(Response<Admin>))]
        //public async Task<HttpResponseMessage> ListOfUserWinningByUserId(long userId)
        //{
        //    Admin adminlist = new Admin() { UserId = userId };
        //    var output = _iAdminRepository.ListOfUserWinningByUserId(adminlist);
        //    return await CreateResponse(output);
        //}

        /// <summary>
        /// Delete Winner User Details 
        /// </summary>
        /// <param name="user"></param>
        /// <returns></returns>
        //[CustomAuthorize(Roles = "Admin")]
        //[AllowAnonymous]
        //[HttpPost]
        //[Route("DeleteWinningUser")]
        //[ResponseType(typeof(Response<Admin>))]
        //public async Task<HttpResponseMessage> DeleteWinningUser(Admin deleteWinningUser)
        //{
        //    var output = _iAdminRepository.DeleteWinningUser(deleteWinningUser);
        //    return await CreateResponse(output);
        //}

    }
}
