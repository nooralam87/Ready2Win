﻿using ReadyToWin.API.Filters;
using ReadyToWin.Complaince.BussinessProvider.IProviders;
using ReadyToWin.Complaince.Entities.ResponseModel;
using ReadyToWin.Complaince.Entities.UserTransaction;
using ReadyToWin.Complaince.Framework.Base;
using System.Net.Http;
using System.Threading.Tasks;
using System.Web.Http;
using System.Web.Http.Description;

namespace ReadyToWin.API.Controllers
{
    [CustomAuthorize(Roles = "Admin,Player")]
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
       
       [HttpPost]
       [Route("UserGameSelectionSubmit")]
       [ResponseType(typeof(Response<UserGameSelection>))]
       public async Task<HttpResponseMessage> UserGameSelectionSubmit(UserGameSelection userGameSelection)
       {
           int count  = _iUserTransaction.UserGameSelectionSubmit(userGameSelection);
            string message = string.Empty;
            switch (count)
            {
                case 1:
                    message = "Success";break;
                case 0:
                    message = "Game Time End"; break;
                case 3:
                    message = "Amount Limit is Exceeded Due to Duration Time Based on EndTime"; break;
                case 2:
                    message = "Amount Limit is Exceeded Due Bid Amount is Graeter Then Wallet Amount"; break;
                default:
                    count = 0;
                    message = "Error";
                    break;
            }
            DbOutput dbOutput = new DbOutput()
            {
                Code = count,
                Message = message
            };
            return await CreateResponse(dbOutput);
       }

        
        [HttpGet]
        [Route("GetUserTotalAmount")]
        [ResponseType(typeof(string))]
        public async Task<HttpResponseMessage> GetUserTotalAmount(long Id)
        {
            decimal count = _iUserTransaction.GetUserTotalAmount(Id);
            return await CreateResponse(count.ToString());
        }

       
        [HttpGet]
        [Route("GetUserGameListbyUserIdandGameTypeId")]
        [ResponseType(typeof(Response<UserBettingDetails>))]
        public async Task<HttpResponseMessage> GetUserGameListbyUserIdandGameTypeId(long UserId, long GameTypeId)
        {
            //UserAmountWithdraw userAmountwithdraw = new UserAmountWithdraw() { UserId = UserId };
            //decimal count = _iUserTransaction.GetUserGameListbyUserId(UserId);
            return await CreateResponse(_iUserTransaction.GetUserGameListbyUserIdandGameTypeId(UserId, GameTypeId));
        }

       
        [HttpGet]
        [Route("GetUserGameListbyGameTypeId")]
        [ResponseType(typeof(Response<UserBettingDetails>))]
        public async Task<HttpResponseMessage> GetUserGameListbyGameTypeId(long UserId, long GameTypeId)
        {
            //UserAmountWithdraw userAmountwithdraw = new UserAmountWithdraw() { UserId = UserId };
            //decimal count = _iUserTransaction.GetUserGameListbyUserId(UserId);
            return await CreateResponse(_iUserTransaction.GetUserGameListbyGameTypeId(GameTypeId));
        }

       
        [HttpGet]
        [Route("GetUserGameListbyGameSelectionId")]
        [ResponseType(typeof(Response<UserBettingDetails>))]
        public async Task<HttpResponseMessage> GetUserGameListbyGameSelectionId(long GameSelectionId)
        {
            //UserAmountWithdraw userAmountwithdraw = new UserAmountWithdraw() { UserId = UserId };
            //decimal count = _iUserTransaction.GetUserGameListbyUserId(UserId);
            return await CreateResponse(_iUserTransaction.GetUserGameListbyGameSelectionId(GameSelectionId));
        }
        
        [HttpGet]
        [Route("GetWinningDeclareNumberHistory")]
        [ResponseType(typeof(Response<WinNumberDeclare>))]
        public async Task<HttpResponseMessage> GetWinningDeclareNumberHistory(long GameTypeId)
        {
            //UserAmountWithdraw userAmountwithdraw = new UserAmountWithdraw() { UserId = UserId };
            //decimal count = _iUserTransaction.GetUserGameListbyUserId(UserId);
            return await CreateResponse(_iUserTransaction.GetWinningDeclareNumberHistory(GameTypeId));
        }

        
        [HttpGet]
        [Route("GetUserWinDetails")]
        [ResponseType(typeof(Response<UserWinDetails>))]
        public async Task<HttpResponseMessage> GetUserWinDetails(long UserId, long GameTypeId)
        {
            UserWinDetails userAmountwithdraw = new UserWinDetails() { UserId = UserId, GameTypeId= GameTypeId };
            //decimal count = _iUserTransaction.GetUserGameListbyUserId(UserId);
            return await CreateResponse(_iUserTransaction.GetUserWinDetails(userAmountwithdraw));
        }

        
        [HttpGet]
        [Route("GetLatestWinNumberDeclare")]
        [ResponseType(typeof(Response<WinNumberDeclare>))]
        public async Task<HttpResponseMessage> GetLatestWinNumberDeclare()
        {
            //UserWinDetails userAmountwithdraw = new UserWinDetails() { UserId = UserId, GameTypeId = GameTypeId };
            //decimal count = _iUserTransaction.GetUserGameListbyUserId(UserId);
            return await CreateResponse(_iUserTransaction.GetLatestWinNumberDeclare());
        }

        [HttpGet]
        [Route("GetAllGameWinningNumber")]
        [ResponseType(typeof(DbOutput))]
        public async Task<HttpResponseMessage> GetAllGameWinningNumber()
        {
            var output = _iUserTransaction.GetAllGameWinningNumber();
            return await CreateResponse(output);
        }

        
        [HttpGet]
        [Route("GetUserBiddingOnCategoryName")]
        [ResponseType(typeof(Response<UserWinDetails>))]
        public async Task<HttpResponseMessage> GetUserBiddingOnCategoryName(long UserId, long GameTypeId, string CategoryName)
        {
            UserWinDetails userAmountwithdraw = new UserWinDetails() { UserId = UserId, GameTypeId = GameTypeId, CategoryName = CategoryName };
            //decimal count = _iUserTransaction.GetUserGameListbyUserId(UserId);
            return await CreateResponse(_iUserTransaction.GetUserBiddingOnCategoryName(userAmountwithdraw));
        }

    }
}