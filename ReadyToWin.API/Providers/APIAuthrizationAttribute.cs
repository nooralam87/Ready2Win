using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading;
using System.Web;
using System.Web.Http.Controllers;
using System.Web.Http.Filters;
using System.Web.Mvc;

namespace ReadyToWin.API.Providers
{
    public class APIAuthrizationAttribute : AuthorizationFilterAttribute
    {
        protected virtual void HandleUnauthorizedRequest(AuthorizationContext filterContext)
        {
            filterContext.Result = new HttpUnauthorizedResult();
        }

        protected virtual bool IsAuthorized(HttpActionContext actionContext)
        {
            var identity = Thread.CurrentPrincipal.Identity;
            if (identity == null && HttpContext.Current != null)
                identity = HttpContext.Current.User.Identity;

            if (identity != null && identity.IsAuthenticated)
            {
                var basicAuth = identity as BasicAuthenticationIdentity;

                // do your business validation as needed
                //var user = new BusUser();
                // if (user.Authenticate(basicAuth.Name, basicAuth.Password))
                return true;
            }

            return false;
        }

        private readonly string[] allowedroles;
        public APIAuthrizationAttribute(params string[] roles)
        {
            this.allowedroles = roles;
        }

        public override void OnAuthorization(HttpActionContext actionContext)
        {

        }

    }
}