using ReadyToWin.API.Filters;
using ReadyToWin.API.Providers;
using ReadyToWin.Complaince.Entities.AdminModel;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using ReadyToWin.Complaince.Entities.GameType;
using ReadyToWin.Complaince.BussinessProvider.IProviders;
using ReadyToWin.API.ViewModel;

namespace ReadyToWin.API.Controllers
{
    [ReadyAuthorize(RolesConfigKey = "RolesConfigKey")]
    public class WinningController : BaseController
    {
        IGameType _iGameType;
        IAdminRepository _iAdminRepository;

        /// <summary>
        /// Initilize WinningController.
        /// </summary>
        /// <param name="_iGameTypeProvider"></param>
        public WinningController(IGameType _iGameType, IAdminRepository _iAdminRepository)
        {
            this._iGameType = _iGameType;
            this._iAdminRepository = _iAdminRepository;
        }

        // GET: Winning
        public ActionResult Index()
        {
            return View(_iAdminRepository.GetUserListBasedOnGameWithBetNumberAndWinAmount());
        }

        // GET: Winning/Details/5
        public ActionResult Details(int id)
        {

            return View();
        }

        // GET: Winning/Create
        public ActionResult Create()
        {
            ViewBag.GameNames = new SelectList(_iGameType.GetGameType(), "GameTypeId", "GameName"); // model binding
            return View();
        }

        // POST: Winning/Create
        [HttpPost]
        public ActionResult Create(GameWinning gameWinning)
        {
            try
            {
                Admin adminModel = new Admin() { 
                    GameTypeId = gameWinning.GameTypeId,
                    GameTypeName= _iGameType.GetGameType().SingleOrDefault(x=> x.GameTypeId==gameWinning.GameTypeId).GameName,
                    winningNumber=gameWinning.winningNumber,
                    AdminUserId=User.UserId
                };

                // TODO: Add insert logic here
                var output = _iAdminRepository.DeclaredWinningNumber(adminModel);
                return RedirectToAction("Index");
                //return RedirectToAction("Index", "Home");
            }
            catch
            {
                return View();
            }
        }

        // GET: Winning/Edit/5
        public ActionResult Edit(int id)
        {
            return View();
        }

        // POST: Winning/Edit/5
        [HttpPost]
        public ActionResult Edit(int id, Admin admin)
        {
            try
            {
                // TODO: Add update logic here

                return RedirectToAction("Index");
            }
            catch
            {
                return View();
            }
        }

        // GET: Winning/Delete/5
        public ActionResult Delete(int id)
        {
            return View();
        }

        // POST: Winning/Delete/5
        [HttpPost]
        public ActionResult Delete(int id, Admin admin)
        {
            try
            {
                // TODO: Add delete logic here

                return RedirectToAction("Index");
            }
            catch
            {
                return View();
            }
        }
    }
}
