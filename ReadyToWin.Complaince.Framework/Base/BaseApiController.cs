using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Threading.Tasks;
using System.Web.Http;
using System.Collections;
using System.Data;
using ReadyToWin.Complaince.Entities.ValidationErrorModel;
using ReadyToWin.Complaince.Entities.ResponseModel;
using ReadyToWin.Complaince.Entities.Constant;

namespace ReadyToWin.Complaince.Framework.Base
{
    public class BaseApiController: ApiController
    {
        public string Message { get; set; }
        public int Code { get; set; }
        public HttpStatusCode HttpStatusCode { get; set; }

        [NonAction]
        public async Task<HttpResponseMessage> CreateResponse<T>(T data, string type = null, int Code = 0, string Message = null ) where T : class
        {
            Response<dynamic> response = new Response<dynamic>();
            HttpStatusCode = HttpStatusCode.OK;
            var errors = new List<ValidationError>();

            if (data == null)
            {
                response.Code = Status.NOT_FOUND;
                response.Message = Messages.DATA_NOT_FOUND;
                response.Data = null;
            }
            else if (data is string)
            {
                response.Code = Code;
                response.Message = Message;
                response.Data = data;
            }
            else if (data is DbOutput)
            {
                var res = data as DbOutput;
                response.Code = res.Code;
                response.Message = res.Message;
                response.Data = null;
            }
            else if (data is List<ValidationError>)
            {
                response.Code = Code.Equals(0) ? Status.FOUND : Code;
                response.Message = Message == null ? Messages.DATA_FOUND : Message;
                response.Data = data;
            }
            else if (data.GetType().Name.Equals(type))
            {
                response.Code = Code.Equals(0) ? Status.FOUND : Code;
                response.Message = Message == null ? Messages.DATA_FOUND : Message;
                response.Data = data;
            }
            else if (data is IEnumerable)
            {
                var list = (data as IEnumerable).Cast<object>().ToList();
                if (list.Count > 0)
                {
                    response.Code = Status.FOUND;
                    response.Message = Messages.DATA_FOUND;
                    response.Data = data;
                }
                else
                {
                    response.Code = Status.NOT_FOUND;
                    response.Message = Messages.DATA_NOT_FOUND;
                    response.Data = null;
                }
            }

            return await Task.Run(() => Request.CreateResponse(HttpStatusCode, response));
        }
    }
}
