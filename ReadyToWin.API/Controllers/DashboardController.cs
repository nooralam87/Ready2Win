using ReadyToWin.API.Filters;
using ReadyToWin.API.Providers;
using ReadyToWin.API.ViewModel;
using ReadyToWin.Complaince.BussinessProvider.IProviders;
using ReadyToWin.Complaince.Bussiness.Provider.UserRepositry;
using ReadyToWin.Complaince.Entities.AdminModel;
using ReadyToWin.Complaince.Entities.GameType;
using ReadyToWin.Complaince.Entities.UserTransaction;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web.Mvc;
using ReadyToWin.Complaince.Framework.Utility;

namespace ReadyToWin.API.Controllers
{
    //[ReadyAuthorize(Roles = "Admin")]
    [ReadyAuthorize(RolesConfigKey = "RolesConfigKey")]
    public class DashboardController : BaseController
    {
        IGameType _iGameType;
        IUserTransaction _iUserTransaction;
        IUserRepository _iUserProvider;
        IAdminRepository _iAdminRepository;
        public DashboardController(IUserRepository _iUserProvider,IUserTransaction _iUserTransaction, IAdminRepository _iAdminRepository, IGameType _iGameType)
        {
            this._iGameType = _iGameType;
            this._iUserTransaction = _iUserTransaction;
            this._iUserProvider = _iUserProvider;
            this._iAdminRepository = _iAdminRepository;
        }

        public ActionResult Users()
        {
            ViewBag.Title = "Home Page";

            return View();
        }
        [ActionName("AmountDeposit")]
        [AcceptVerbs(HttpVerbs.Get)]
        //[HttpGet]
        public ActionResult ListOfUserAmountDeposit()
        {
            List<UserAmountDeposit> output = _iUserTransaction.ListOfUserAmountDeposit();
            TempData["UserAmountDeposit"] = output;
            return View(output);
        }

        [ActionName("Preview")]
        [AcceptVerbs(HttpVerbs.Get)]
        //[HttpGet]
        public ActionResult Preview(long Id)
        {
            List<UserAmountDeposit> output = TempData["UserAmountDeposit"] as List<UserAmountDeposit>; TempData.Keep("UserAmountDeposit");
            UserAmountDeposit data = output.SingleOrDefault(x => x.Id == Id);
            return View(data);
        }

        [ActionName("WithdrawRequest")]
        [AcceptVerbs(HttpVerbs.Get)]
        //[HttpGet]
        public ActionResult WithdrawRequest()
        {
            List<UserAmountWithdraw> output = _iUserTransaction.ListOfUserWithdrawRequest();
            return View(output);
        }

        [ActionName("GetAllAmountOnGameByGameType")]
        [AcceptVerbs(HttpVerbs.Get)]
        public ActionResult AmountOnGameByGameType(long _gametypeId=1)
        {
            GameResultFilter _charts = new GameResultFilter();
            _charts.GameNames = _iGameType.GetGameType();
            TempData["GameNames"] = _charts.GameNames;
            List<AmountOnGameByGameType> output = _iAdminRepository.ListOfAmountOnGameByGameType(_gametypeId);
            _charts.AmountOnGameByGameType = output;
            return View(_charts);
        }

        [ActionName("GetAllAmountOnGameByGameType")]
        [AcceptVerbs(HttpVerbs.Post)]
        public ActionResult AmountOnGameByGameType(GameResultFilter _filter)
        {
            GameResultFilter _charts = new GameResultFilter();
            _charts.GameNames = TempData["GameNames"] as List<GameType>;
            List<AmountOnGameByGameType> output = _iAdminRepository.ListOfAmountOnGameByGameType(_filter.gametypeId);
            _charts.AmountOnGameByGameType = output;
            TempData.Keep("GameNames");
            return View(_charts);
        }

        [ActionName("Charts")]
        [AcceptVerbs(HttpVerbs.Get)]
        public ActionResult Charts(long _gametypeId = 1)
        {
            GameResultFilter _charts = new GameResultFilter();
            _charts.GameNames = _iGameType.GetGameType();// model binding
            TempData["GameNames"] = _charts.GameNames;
            List<AmountOnGameByGameType> output = _iAdminRepository.ListOfAmountOnGameByGameType(_gametypeId);
            if(output != null)
            {
                _charts.AmountOnGameByGameType = output;
                _charts.Users = new List<UserSelect>();
                //var distinctUser = output.GroupBy(x => x.UserId, (key, group) => group.First());
                _charts.Users = output.Select(x => new UserSelect() { userId = x.UserId, MyUserName = x.UserName }).GroupBy(x => x.userId, (key, group) => group.First()).ToList();
                _charts.Users.Add(new UserSelect() { userId = 0, MyUserName = "All User" }); 
                _charts.gametypeId = _gametypeId;
                TempData["_gametypeId"] = _gametypeId;
                //_charts.GameDate = output.Select(x => new GameDate() { Id=x.GameBettingId,gamedate=x.createdDate }).GroupBy(x => x.gamedate, (key, group) => group.First()).ToList();
            }
            return View(_charts);
        }
        [ActionName("Charts")]
        [AcceptVerbs(HttpVerbs.Post)]
        public ActionResult Charts(GameResultFilter _filter)
        {
            if (_filter.userId == 0)
            {
                _filter.AmountOnGameByGameType = _iAdminRepository.ListOfAmountOnGameByGameType(_filter.gametypeId);
            }
            else
            {
                _filter.AmountOnGameByGameType = _iAdminRepository.ListOfAmountOnGameByGameType(_filter.gametypeId).Where(
                        x => x.UserId == _filter.userId).ToList();
            }
            if (_filter.AmountOnGameByGameType != null)
            {
                _filter.Users = new List<UserSelect>();
                _filter.Users = _filter.AmountOnGameByGameType.Select(x => new UserSelect() { userId = x.UserId, MyUserName = x.UserName }).GroupBy(x => x.userId, (key, group) => group.First()).ToList();
                _filter.Users.Add(new UserSelect() { userId = 0, MyUserName = "All User" });
                _filter.GameNames = TempData["GameNames"] as List<GameType>;
            }
            TempData.Keep("GameNames");
            return View(_filter);
        }

        [ActionName("GetAmountOnGameByUser")]
        [AcceptVerbs(HttpVerbs.Get)]
        public ActionResult GetAmountOnGameByUser(long _number,long _gametypeid,string game_type)
        {
            List<AmountOnGameByGameType> output = _iAdminRepository.ListOfAmountOnGameByGameType(_number);
            return View(output);
        }

        public JsonResult ApproveReject(long _id, long _usrId, string type)
        {
            Admin userAmountApproved = new Admin()
            {
                AdminUserId = User.UserId, UserId = _usrId, Id = _id,
                Status = type.ToUpper() == "A" ? "Approved" : "Rejected",
                Remarks="Approved By The "+User.roles
            };

            var output = _iAdminRepository.UserDepositAmountApproved(userAmountApproved);
            // do here some operation  
            return Json(output, JsonRequestBehavior.AllowGet);
        }
        public JsonResult ApproveRejectWithdraw(long _id, long _usrId, string type)
        {
            Admin userAmountApproved = new Admin()
            {
                AdminUserId = User.UserId,
                UserId = _usrId,
                Id = _id,
                Status = type.ToUpper() == "A" ? "Approved" : "Rejected",
                Remarks = "Approved By The " + User.roles
            };

            var output = _iAdminRepository.UserWithdrawAmountApproved(userAmountApproved);
            // do here some operation  
            return Json(output, JsonRequestBehavior.AllowGet);
        }
        [ActionName("GetUsers")]
        [AcceptVerbs(HttpVerbs.Get)]
        public JsonResult GetUsers()
        {
            // do here some operation  
            //var output = _iUserProvider.GetAllUser();
            var output = _iAdminRepository.GetUserListWalletBalance();
            return Json(output, JsonRequestBehavior.AllowGet);
        }

        [ActionName("GetPassword")]
        [AcceptVerbs(HttpVerbs.Get)]
        public JsonResult GetPassword(int _id)
        {
            // do here some operation  
            var output = _iUserProvider.GetUser_ById(_id);
            return Json(output, JsonRequestBehavior.AllowGet);
        }
    }
   
}
