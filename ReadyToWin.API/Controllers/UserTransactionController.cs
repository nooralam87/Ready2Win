using ReadyToWin.Complaince.Framework.Base;
using System.Net;
using System.Net.Http;
using System.Web.Http;
using System.Threading.Tasks;
using ReadyToWin.Complaince.Entities.UserTransaction;
using ReadyToWin.Complaince.BussinessProvider.IProviders;
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
    [RoutePrefix("api/UserTransaction")]
    public class UserTransactionController : BaseApiController
    {
        IUserTransaction _iUserTransaction;
        //
        // GET: /UserTransaction/
       public UserTransactionController(IUserTransaction _iUserTransaction)
       {
           this._iUserTransaction = _iUserTransaction;
       }
       /// <summary>
       /// Select All user amount deposited by User Id
       /// </summary>
       /// <param name="user"></param>
       /// <returns></returns>
       //[CustomAuthorize(Roles = "Admin")]
       [AllowAnonymous]
       [HttpGet]
       [Route("ListOfUserAmountDepositByUserId")]
       [ResponseType(typeof(Response<UserAmountDeposit>))]
       public async Task<HttpResponseMessage> ListOfUserAmountDepositByUserId(long UserId)
       {
           UserAmountDeposit userAmountdeposit = new UserAmountDeposit() { UserId= UserId };
           var output = _iUserTransaction.ListOfUserAmountDepositByUserId(userAmountdeposit);
           return await CreateResponse(output);
       }
       
        /// <summary>
        /// Select All user amount deposited by User Id
        /// </summary>
        /// <param name="user"></param>
        /// <returns></returns>
        //[CustomAuthorize(Roles = "Admin")]
        [AllowAnonymous]
        [HttpGet]
        [Route("RecentTransaction")]
        [ResponseType(typeof(Response<UserAmountDeposit>))]
        public async Task<HttpResponseMessage> RecentTransaction(long UserId)
        {
            UserAmountDeposit userAmountdeposit = new UserAmountDeposit() { UserId = UserId };
            return await CreateResponse(_iUserTransaction.RecentTransaction(userAmountdeposit));

        }
        /// <summary>
        /// Add new Deosit Amount
        /// </summary>
        /// <param name="user"></param>
        /// <returns></returns>
        //[CustomAuthorize(Roles = "Admin")]
       [AllowAnonymous]
       [HttpPost]
       [Route("AddUserAmountDeposit")]
       [ResponseType(typeof(Response<UserAmountDeposit>))]
       public async Task<HttpResponseMessage> AddUserAmountDeposit(UserAmountDeposit userAmountdeposit)
       {
           var output = _iUserTransaction.AddUserAmountDeposit(userAmountdeposit);
           return await CreateResponse(output);
       }

        /// <summary>
        /// Add UserWithdraw Request.
        /// </summary>
        /// <param name="user"></param>
        /// <returns></returns>
        //[CustomAuthorize(Roles = "Admin")]
        [AllowAnonymous]
        [HttpPost]
        [Route("UserWithdrawRequest")]
        [ResponseType(typeof(Response<UserAmountWithdraw>))]
        public async Task<HttpResponseMessage> UserWithdrawRequest(UserAmountWithdraw userAmountwithdraw)
        {
            var output = _iUserTransaction.UserWithdrawRequest(userAmountwithdraw);
            return await CreateResponse(output);
        }

        /// <summary>
        /// List of User withdraw request by User Id
        /// </summary>
        /// <param name="user"></param>
        /// <returns></returns>
        //[CustomAuthorize(Roles = "Admin")]
       [AllowAnonymous]
       [HttpGet]
       [Route("ListOfUserWithdrawRequestByUserId")]
       [ResponseType(typeof(Response<UserAmountWithdraw>))]
       public async Task<HttpResponseMessage> ListOfUserWithdrawRequestByUserId(long UserId)
       {
            UserAmountWithdraw userAmountwithdraw = new UserAmountWithdraw() { UserId = UserId };
            var output = _iUserTransaction.ListOfUserWithdrawRequestByUserId(userAmountwithdraw);
           return await CreateResponse(output);
       }
        /// <summary>
        /// Select All user amount deposited by User Id
        /// </summary>
        /// <param name="user"></param>
        /// <returns></returns>
        //[CustomAuthorize(Roles = "Admin")]
        [AllowAnonymous]
        [HttpGet]
        [Route("RecentTransactionWithdrawAmount")]
        [ResponseType(typeof(Response<UserAmountWithdraw>))]
        public async Task<HttpResponseMessage> RecentTransactionWithdrawAmount(long UserId)
        {
            UserAmountWithdraw userAmountwithdraw = new UserAmountWithdraw() { UserId = UserId };
            return await CreateResponse(_iUserTransaction.RecentTransactionWithdrawAmount(userAmountwithdraw));

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
       //[ResponseType(typeof(Response<UserAmountWithdraw>))]
       //public async Task<HttpResponseMessage> DeleteWithdrawRequest(UserAmountWithdraw userAmountwithdraw)
       //{
       //    var output = _iUserTransaction.DeleteWithdrawRequest(userAmountwithdraw);
       //    return await CreateResponse(output);
       //}

       /// <summary>
       /// Add new user Game Selection.
       /// </summary>
       /// <param name="user"></param>
       /// <returns></returns>
       //[CustomAuthorize(Roles = "Admin")]
       [AllowAnonymous]
       [HttpPost]
       [Route("UserGameSelectionSubmit")]
       [ResponseType(typeof(Response<UserGameSelection>))]
       public async Task<HttpResponseMessage> UserGameSelectionSubmit(UserGameSelection userGameSelection)
       {
           int count  = _iUserTransaction.UserGameSelectionSubmit(userGameSelection);
           return await CreateResponse(count.ToString());
       }

        [AllowAnonymous]
        [HttpGet]
        [Route("GetUserTotalAmount")]
        [ResponseType(typeof(string))]
        public async Task<HttpResponseMessage> GetUserTotalAmount(long Id)
        {
            decimal count = _iUserTransaction.GetUserTotalAmount(Id);
            return await CreateResponse(count.ToString());
        }

    }
}