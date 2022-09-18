using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Net.Http;
using System.Web.Http.Controllers;
using System.Web.Http.Filters;
using System.Web.Routing;
using ReadyToWin.API.Models;

namespace ReadyToWin.API.Filters
{
    /// <summary>
    /// send email
    /// </summary>
    public class SendEmailActionFilter : ActionFilterAttribute
    {
        public override async void OnActionExecuted(HttpActionExecutedContext actionExecutedContext)
        {
            
            UploadMiddleware obj = new UploadMiddleware();
            await obj.SendEmailAsync("", "", "");
        }

     
        private void Log(string methodName, dynamic controllerName,dynamic actionName)
        {
            var message = String.Format(
               "{0} controller:{1} action:{2}", methodName, controllerName, actionName);
        }
    }
}