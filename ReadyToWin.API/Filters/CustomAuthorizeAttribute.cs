using ReadyToWin.Complaince.DataAccess.UserRepositry;
using ReadyToWin.Complaince.Entities.Constant;
using ReadyToWin.Complaince.Entities.ResponseModel;
using ReadyToWin.Complaince.Framework;
using ReadyToWin.Complaince.Framework.Exception;
using ReadyToWin.Complaince.Framework.Utility;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;
using System.Web.Http.Controllers;

namespace ReadyToWin.API.Filters
{
    public class CustomAuthorizeAttribute : AuthorizeAttribute
    {
        UserRepository _iUserProvider = new UserRepository();

        public override void OnAuthorization(HttpActionContext actionContext)
        {
            if (Enumerable.Any(actionContext.ActionDescriptor.GetCustomAttributes<AllowAnonymousAttribute>()))
            {
                return;
            }

            try
            {
                string reqToken = "";

                IEnumerable<string> header;
                // get token from header
                if (actionContext.Request.Headers.TryGetValues("Token", out header))
                {
                    reqToken = header.First();
                }
                else
                {
                    var response = Response<string>.CreateResponse(401, Messages.TOKEN_NOT_FOUND, null);
                    actionContext.Response = actionContext.Request.CreateResponse(HttpStatusCode.Unauthorized, response);
                    return;
                }

                //get user id
                var key = EncryptionLibrary.DecryptText(reqToken);
                string[] parts = key.Split(new char[] { ':' });
                var UserId = Convert.ToString(parts[0]);

                // Validating if token already exists.
                //compare token with user id 
                string token = _iUserProvider.CheckToken(UserId);

                if (!reqToken.Equals(token))
                {
                    var response = Response<string>.CreateResponse(401, Messages.INVALID_TOKEN, null);
                    actionContext.Response = actionContext.Request.CreateResponse(HttpStatusCode.Unauthorized, response);
                    return;
                }

                // get user roles
                var _roles = _iUserProvider.GetRoles(UserId);

                if (_roles == null || !FindActionInRoles(_roles, Roles))
                {
                    var response = Response<string>.CreateResponse(401, Messages.INVALID_TOKEN, null);
                    actionContext.Response = actionContext.Request.CreateResponse(HttpStatusCode.Unauthorized, response);
                    return;
                }
            }
            catch (Exception ex)
            {
                //ApiLogger.Instance.ErrorLog(ex.ToString());
                actionContext.Response = actionContext.Request.CreateResponse(HttpStatusCode.InternalServerError, Messages.EEROR_API);
                return;
            }
        }

        private bool FindActionInRoles(string[] roles, string attrRoles)
        {
            if (roles.Any(r => attrRoles.Split(',').Contains(r)))
            {
                return true;
            }
            else
            {
                return false;
            }
        }
    }   
}