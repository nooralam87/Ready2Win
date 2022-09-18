using System;
using System.Linq;
using System.Web;
using System.Web.Http.Controllers;
using System.Net;
using System.Net.Http;
using System.Text;
using System.Threading;
using System.Security.Principal;
using System.Web.Mvc;

namespace ReadyToWin.API.Providers
{
    public class CustomAuthorizeAttribute : System.Web.Http.AuthorizeAttribute
    {
        private readonly string[] allowedroles;
        public CustomAuthorizeAttribute(params string[] roles)
        {
            this.allowedroles = roles;
        }
        public void OnAuthorization_Test(HttpActionContext actionContext)
        {
            base.OnAuthorization(actionContext);
            //if (actionContext.Request.Headers.Authorization == null)
            //{
            //    actionContext.Response = actionContext.Request
            //        .CreateResponse(HttpStatusCode.Unauthorized);
            //}
            //else
            //{
            //    string authenticationToken = actionContext.Request.Headers
            //                                .Authorization.Parameter;
            //    string decodedAuthenticationToken = Encoding.UTF8.GetString(
            //        Convert.FromBase64String(authenticationToken));
            //    string[] usernamePasswordArray = decodedAuthenticationToken.Split(':');
            //    string username = usernamePasswordArray[0];
            //    string password = usernamePasswordArray[1];

            //    //if (EmployeeSecurity.Login(username, password))
            //    //{
            //        Thread.CurrentPrincipal = new GenericPrincipal(
            //            new GenericIdentity(username), null);
            //    //}
            //    //else
            //    //{
            //    //    actionContext.Response = actionContext.Request
            //    //        .CreateResponse(HttpStatusCode.Unauthorized);
            //    //}
            //}


            if (actionContext.Request.Headers.Authorization == null)
            {
                actionContext.Response = actionContext.Request
                    .CreateResponse(HttpStatusCode.Unauthorized);
            }
            else if (actionContext.Request.Headers.GetValues("Authorization") != null)
            {

                // get value from header
                string authenticationToken = Convert.ToString(
                 actionContext.Request.Headers.GetValues("Authorization").FirstOrDefault());
                //authenticationTokenPersistant
                // it is saved in some data store
                // i will compare the authenticationToken sent by client with
                // authenticationToken persist in database against specific user, and act accordingly
                //if (authenticationTokenPersistant != authenticationToken)
                //{
                //    HttpContext.Current.Response.AddHeader("authenticationToken", authenticationToken);
                //    HttpContext.Current.Response.AddHeader("AuthenticationStatus", "NotAuthorized");
                //    actionContext.Response = actionContext.Request.CreateResponse(HttpStatusCode.Forbidden);
                //    return;
                //}

                HttpContext.Current.Response.AddHeader("authenticationToken", authenticationToken);
                HttpContext.Current.Response.AddHeader("AuthenticationStatus", "Authorized");
                return;
            }
                //actionContext.Response =
                //  actionContext.Request.CreateResponse(HttpStatusCode.ExpectationFailed);
                //actionContext.Response.ReasonPhrase = "Please provide valid inputs";
            }

       
        protected virtual void HandleUnauthorizedRequest(AuthorizationContext filterContext)
        {
            filterContext.Result = new HttpUnauthorizedResult();
        }
        /// <summary>
        /// Authorized
        /// </summary>
        /// <param name="actionContext"></param>
        /// <returns>Boolean</returns>
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
    }
    public class SkipImportantTaskAttribute : Attribute { }
}