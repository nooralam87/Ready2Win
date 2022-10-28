using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Web.Security;
using Newtonsoft.Json;
using ReadyToWin.API.Filters;
using ReadyToWin.API.Models;
using ReadyToWin.Complaince.Bussiness.Provider.UserRepositry;
using ReadyToWin.Complaince.Entities.UserModel;

namespace ReadyToWin.API.Controllers
{
    public class AccountController : Controller
    {

        IUserRepository _iUserProvider;

        public AccountController(IUserRepository _iUserProvider)
        {
            this._iUserProvider = _iUserProvider;
        }
        //
        // GET: /Account/
        public ActionResult Index()
        {
            
            return View();
        }

        [HttpPost]
        public ActionResult Index(LoginViewModel model, string returnUrl = "")
        {
            if (ModelState.IsValid)
            {
                User user = _iUserProvider.ValidateByUserId(model.Username,model.Password);
                if (user != null)
                {
                    var roles = user.Roles=="1"?"Admin":""; //_iUserProvider.GetRoles(user.UserId);

                    CustomPrincipalSerializeModel serializeModel = new CustomPrincipalSerializeModel();
                    serializeModel.UserId = Int32.Parse(user.Id.ToString());
                    serializeModel.FirstName = user.UserName;
                    serializeModel.LastName = user.UserName;
                    serializeModel.roles = roles;

                    string userData = JsonConvert.SerializeObject(serializeModel);
                    FormsAuthenticationTicket authTicket = new FormsAuthenticationTicket(
                    1,
                    user.Email,
                    DateTime.Now,
                    DateTime.Now.AddMinutes(15),
                    false, //pass here true, if you want to implement remember me functionality
                    userData);

                    string encTicket = FormsAuthentication.Encrypt(authTicket);
                    HttpCookie faCookie = new HttpCookie(FormsAuthentication.FormsCookieName, encTicket);
                    Response.Cookies.Add(faCookie);

                    if (roles.Contains("Admin"))
                    {
                        return RedirectToAction("Users", "Dashboard");
                    }
                    else if (roles.Contains("User"))
                    {
                        return RedirectToAction("Index", "User");
                    }
                    else
                    {
                        return RedirectToAction("Users", "Dashboard");
                    }
                }

                ModelState.AddModelError("", "Incorrect username and/or password");
            }

            return View(model);
        }

        [AllowAnonymous]
        public ActionResult LogOut()
        {
            FormsAuthentication.SignOut();
            return RedirectToAction("Index", "Account", null);
        }
    }
}