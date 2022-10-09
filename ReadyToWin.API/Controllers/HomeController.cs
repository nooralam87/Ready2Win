using ReadyToWin.API.Filters;
using ReadyToWin.API.Providers;
using ReadyToWin.Complaince.BussinessProvider.IProviders;
using ReadyToWin.Complaince.Entities.AdminModel;
using ReadyToWin.Complaince.Entities.UserTransaction;
using System.Collections.Generic;
using System.Linq;
using System.Web.Mvc;

namespace ReadyToWin.API.Controllers
{
    //[ReadyAuthorize(Roles = "Admin")]
    [ReadyAuthorize(RolesConfigKey = "RolesConfigKey")]
    public class HomeController : BaseController
    {

        IUserTransaction _iUserTransaction;
        IAdminRepository _iAdminRepository;
        public HomeController(IUserTransaction _iUserTransaction, IAdminRepository _iAdminRepository)
        {
            this._iUserTransaction = _iUserTransaction;
            this._iAdminRepository = _iAdminRepository;
        }

        public ActionResult Index()
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
    }
   
}
