using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Security.Principal;
using System.Web;
using System.Web.Mvc;
using System.Web.Routing;
using ReadyToWin.Complaince.Bussiness.Provider.UserRepositry;
using ReadyToWin.Complaince.Entities.UserModel;

namespace ReadyToWin.API.Filters
{
    public class ReadyAuthorizeAttribute : AuthorizeAttribute
    {
        /*Entities context = new Entities();*/ // my entity
        //IUserRepository _iUserProvider;
        //private readonly string[] allowedroles;
        //public ReadyAuthorizeAttribute(IUserRepository _iUserProvider, params string[] roles)
        //{
        //    this._iUserProvider = _iUserProvider;
        //    this.allowedroles = roles;
        //}
        public string UsersConfigKey { get; set; }
        public string RolesConfigKey { get; set; }

        protected virtual CustomPrincipal CurrentUser
        {
            get { return HttpContext.Current.User as CustomPrincipal; }
        }
        public override void OnAuthorization(AuthorizationContext filterContext)
        {
            if (filterContext.HttpContext.Request.IsAuthenticated)
            {
                var authorizedUsers = ConfigurationManager.AppSettings[UsersConfigKey];
                var authorizedRoles = ConfigurationManager.AppSettings[RolesConfigKey];

                Users = String.IsNullOrEmpty(Users) ? authorizedUsers : Users;
                Roles = String.IsNullOrEmpty(Roles) ? authorizedRoles : Roles;

                if (!String.IsNullOrEmpty(Roles))
                {
                    if (!CurrentUser.IsInRole(Roles))
                    {
                        filterContext.Result = new RedirectToRouteResult(new
                        RouteValueDictionary(new { controller = "Error", action = "AccessDenied" }));

                        // base.OnAuthorization(filterContext); //returns to login url
                    }
                }

                if (!String.IsNullOrEmpty(Users))
                {
                    if (!Users.Contains(CurrentUser.UserId.ToString()))
                    {
                        filterContext.Result = new RedirectToRouteResult(new
                        RouteValueDictionary(new { controller = "Error", action = "AccessDenied" }));

                        // base.OnAuthorization(filterContext); //returns to login url
                    }
                }
            }
            else
            {
                filterContext.Result = new RedirectToRouteResult(new
                RouteValueDictionary(new { controller = "Account", action = "Index" }));
            }

        }
        
        protected override void HandleUnauthorizedRequest(AuthorizationContext filterContext)
        {
            filterContext.Result = new HttpUnauthorizedResult();
        }
    }

    public class CustomPrincipalSerializeModel
    {
        public int UserId { get; set; }
        public string FirstName { get; set; }
        public string LastName { get; set; }
        public string roles { get; set; }
    }
    public class CustomPrincipal : IPrincipal
    {
        public IIdentity Identity { get; private set; }
        public bool IsInRole(string role)
        {
            if (roles.Any(r => role.Contains(r)))
            {
                return true;
            }
            else
            {
                return false;
            }
        }

        public CustomPrincipal(string Username)
        {
            this.Identity = new GenericIdentity(Username);
        }

        public int UserId { get; set; }
        public string FirstName { get; set; }
        public string LastName { get; set; }
        public string roles { get; set; }
    }

}