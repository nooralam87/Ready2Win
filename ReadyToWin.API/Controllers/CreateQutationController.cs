using System.Net.Http;
using System.Web.Http;
using System.Web.Http.Description;
using System.Threading.Tasks;
using ReadyToWin.Complaince.Entities.ResponseModel;
using ReadyToWin.Complaince.Entities.QutationRepositry;
using ReadyToWin.Complaince.Framework.Base;
using ReadyToWin.Complaince.BussinessProvider.IProviders;
using ReadyToWin.API.Filters;
using EmailServer;
using System;
using Newtonsoft.Json;

namespace ReadyToWin.API.Controllers
{
    [RoutePrefix("api/CreateQutation")]
    public class CreateQutationController : BaseApiController
    {
        ICreateQutation _qutation; ISmtpClient _smtpClient;

        public CreateQutationController(ICreateQutation ICreateQutation, ISmtpClient smtpClient)
        {
            this._qutation = ICreateQutation;
            this._smtpClient = smtpClient;
        }

        
        [AllowAnonymous]
        [HttpPost]
        [Route("AddQutation")]
        [ResponseType(typeof(Response<Qutation>))]
        public async Task<HttpResponseMessage> RequestQutation(Qutation qutation)
        {
            //encrypt password.
            qutation.IPAdress = System.Web.HttpContext.Current.Request.ServerVariables["HTTP_X_FORWARDED_FOR"];
            if (string.IsNullOrEmpty(qutation.IPAdress))
            {
                qutation.IPAdress = System.Web.HttpContext.Current.Request.ServerVariables["REMOTE_ADDR"];
            }
            //save user
            var output = _qutation.RequestQutation(qutation); 
            string concat_email = string.Join(",", _qutation.GetAllVendors());
            if (output.Message == "User created")
            {
                await _smtpClient.SendEmailAsync(concat_email, "Hello", "Hello, This is Email sending test using gmail.");
            }
            return await CreateResponse(output);
        }


       
        [AllowAnonymous]
        [HttpGet]
        [Route("GetCustomerDetails/{id}")]
        [ResponseType(typeof(Response<Customer>))]
        public async Task<HttpResponseMessage> GetCustomerDetails(int id)
        {
            
            try
            {
                var client = new HttpClient();
                var request = new HttpRequestMessage
                {
                    Method = HttpMethod.Get,
                    RequestUri = new Uri(@"https://api.bigcommerce.com/stores/v1jfzk44hb/v2/customers/"+id),
                    Headers =
                    {
                        { "Accept", "application/json" },
                        { "X-Auth-Token", "5piuvue6hajkrztj17s04yusux8xffm" },
                    },
                };
                
                using (var response = await client.SendAsync(request))
                {
                   var d =  response.EnsureSuccessStatusCode();
                    if (d.IsSuccessStatusCode)
                    {
                        var str = await response.Content.ReadAsStringAsync();
                        Customer _customer = JsonConvert.DeserializeObject<Customer>(str);
                        return await CreateResponse(_customer, Convert.ToString(typeof(Customer).Name));
                    }
                    else
                    {
                        DbOutput dbOutput = new DbOutput();
                        dbOutput.Code = 201;
                        dbOutput.Message = "Data Not Found";
                        dbOutput.Data = null;
                        return await CreateResponse(dbOutput);
                    }
                     
                }
            }
            catch (Exception ex)
            {
                DbOutput dbOutput = new DbOutput();
                dbOutput.Code = 201;
                dbOutput.Message = ex.Message;
                dbOutput.Data = null;
                return await CreateResponse(dbOutput);
            }
            
        }

        [AllowAnonymous]
        [HttpGet]
        [Route("GetProductsDetails/{id}")]
        [ResponseType(typeof(Response<Products>))]
        public async Task<HttpResponseMessage> GetProductsDetails(int id)
        {
            try
            {
                var client = new HttpClient();
                var request = new HttpRequestMessage
                {
                    Method = HttpMethod.Get,
                    RequestUri = new Uri("https://api.bigcommerce.com/stores/v1jfzk44hb/v2/customers/" + id),
                    Headers =
                    {
                        { "Accept", "application/json" },
                        { "X-Auth-Token", "5piuvue6hajkrztj17s04yusux8xffm" },
                    },
                };

                using (var response = await client.SendAsync(request))
                {
                    var d = response.EnsureSuccessStatusCode();
                    if (d.IsSuccessStatusCode)
                    {
                        var str = await response.Content.ReadAsStringAsync();
                        Products _products = JsonConvert.DeserializeObject<Products>(str);
                        return await CreateResponse(_products, Convert.ToString(typeof(Products).Name));
                    }
                    else
                    {
                        DbOutput dbOutput = new DbOutput();
                        dbOutput.Code = 201;
                        dbOutput.Message = "Data Not Found";
                        dbOutput.Data = null;
                        return await CreateResponse(dbOutput);
                    }

                }
            }
            catch (Exception ex)
            {
                DbOutput dbOutput = new DbOutput();
                dbOutput.Code = 201;
                dbOutput.Message = ex.Message;
                dbOutput.Data = null;
                return await CreateResponse(dbOutput);
            }

        }


       
    }
}
