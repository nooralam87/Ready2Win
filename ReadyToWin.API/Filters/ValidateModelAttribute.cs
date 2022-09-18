using ReadyToWin.Complaince.Framework;
using System.Collections.Generic;
using System.Net;
using System.Net.Http;
using System.Web.Http.Controllers;
using System.Web.Http.Filters;
using System.Web.Http.ModelBinding;
using ReadyToWin.Complaince.Entities.ValidationErrorModel;
using ReadyToWin.Complaince.Entities.ResponseModel;
using ReadyToWin.Complaince.Entities.Constant;
using System.Text;

namespace ReadyToWin.API.Filters
{
    /// <summary>
    /// validate model
    /// </summary>
    public class ValidateModelAttribute : ActionFilterAttribute
    {
        /// <summary>
        /// Validate parameters before executing controller
        /// </summary>
        /// <param name="actionContext"></param>
        public override void OnActionExecuting(HttpActionContext actionContext)
        {
            if (actionContext.ModelState.IsValid == false)
            {                
                var errors = new List<ValidationError>();
                if (actionContext.ActionDescriptor.SupportedHttpMethods[0].Method.Equals("GET"))
                {
                    var obj = actionContext.ActionArguments;
                    
                    foreach (var item in obj)
                    {
                        var key = item.Key;
                        var value = item.Value;

                        if (value == null)
                        {
                            errors.Add(new ValidationError
                            {
                                Title = key,
                                Description = "Enter valid value for {key}"
                            });
                        }
                    }
                }
                else
                {
                    var valErrors = (actionContext.ModelState as ModelStateDictionary);
                    foreach (KeyValuePair<string, ModelState> item in valErrors)
                    {
                        errors.Add(new ValidationError
                        {
                            Title = item.Key,
                            Description = GetErrorMessage(item.Value.Errors)
                        });
                    }
                }                

                var response = new Response<dynamic>()
                {
                    Code = Status.VALIDATION_ERROR,
                    Message = Messages.VALIDATION_ERROR,
                    Data = errors
                };

                actionContext.Response = actionContext.Request.CreateResponse(HttpStatusCode.BadRequest, response);
            }
        }

        private string GetErrorMessage(ModelErrorCollection errors)
        {
            var sb = new StringBuilder();
            foreach (var item in errors)
                sb.AppendLine(item.ErrorMessage);

            return sb.ToString();
        }  
    }
}