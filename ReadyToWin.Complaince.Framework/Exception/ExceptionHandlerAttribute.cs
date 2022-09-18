using System.Net.Http;
using System.Text;
using System.Web.Http.Filters;
using System.Security;
using System.Net;
using ReadyToWin.Complaince.Framework.Base;
using ReadyToWin.Complaince.Entities.ResponseModel;

namespace ReadyToWin.Complaince.Framework.Exception
{
    public class ExceptionHandlerAttribute : ExceptionFilterAttribute
    {
        public override void OnException(HttpActionExecutedContext actionExecutedContext)
        {
            string exceptionMessage = string.Empty;

            if (actionExecutedContext == null 
                || actionExecutedContext.Exception.InnerException == null)
            {
                exceptionMessage = actionExecutedContext.Exception.Message;
            }
            else if (actionExecutedContext.Exception is SecurityException)
            {
                actionExecutedContext.Response = new HttpResponseMessage(HttpStatusCode.Unauthorized);
            }
            else
            {
                exceptionMessage = actionExecutedContext.Exception.InnerException.Message;
            }

            var errorMesaage = Response<string>.CreateResponse(500, "Internal Server Error", actionExecutedContext.Exception.ToString());

            var response = new HttpResponseMessage(HttpStatusCode.InternalServerError)
            {
                Content = new StringContent(errorMesaage.ToJson(), Encoding.UTF8, "application/json")
            };

            actionExecutedContext.Response = response;

            //log exception message to file
            //GlobalExceptionLogger.Instance.Log(actionExecutedContext);

            base.OnException(actionExecutedContext);    
        }
    }
}
