using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ReadyToWin.Complaince.Entities.ResponseModel
{
    public class Response<T> where T : class
    {
        public int Code { get; set; }
        public string Message { get; set; }
        public T Data { get; set; } 

        public static Response<T> CreateResponse(int success, string message, T data)
        {
            var response = new Response<T>()
            {
                Code = success,
                Message = message,
                Data = data
            };          

            return response;
        }
    }

    public class DbOutput
    {
        public int Code { get; set; }
        public string Message { get; set; }
        public dynamic Data { get; set; }
    }
}
