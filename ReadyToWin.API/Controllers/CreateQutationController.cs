using System.Net.Http;
using System.Web.Http;
using System.Web.Http.Description;
using System.Threading.Tasks;
using ReadyToWin.Complaince.Entities.ResponseModel;
using ReadyToWin.Complaince.Entities.CartsModel;
using ReadyToWin.Complaince.Entities.QutationRepositry;
using ReadyToWin.Complaince.Framework.Base;
using ReadyToWin.Complaince.BussinessProvider.IProviders;
using ReadyToWin.API.Filters;
using EmailServer;
using System;
using Newtonsoft.Json;
using System.Net.Http.Headers;
using System.Collections.Generic;
//using System.Web.Script.Serialization;

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
                await _smtpClient.SendEmailAsync(concat_email, "Hello", string.Format(@"<!DOCTYPE html><html lang='en'><head><title>Document</title></head><body style='background-color:#cfe3e4'><div style='padding-right:15px;padding-left:15px;margin-right:5%;margin-left:5%'><div style='text-align:center;padding:4px;margin-bottom:0;background-color:#343a40;border-bottom:1px solid rgba(0,0,0,.125);word-wrap:break-word;border-radius:calc(.25rem - 1px) calc(.25rem - 1px) 0 0;color:#fff!important'><h2 style='text-align:center'><b>Customer Request Detail</b></h2></div><div style='padding:15px;margin-bottom:0;background-color:#f8f9fa!important'><table style='width:100%'><tr><td><div style='margin-bottom:15px'><label>Password:</label><div style='height:34px;color:#555;border:1px solid #ccc;border-radius:4px;box-shadow:inset 0 1px 1px rgb(0 0 0 / 8%);padding-left:10px;padding-top:11px'>Test Data</div></div></td><td><div style='margin-bottom:15px'><label>Password:</label><div style='height:34px;color:#555;border:1px solid #ccc;border-radius:4px;box-shadow:inset 0 1px 1px rgb(0 0 0 / 8%);padding-left:10px;padding-top:11px'>Test Data</div></div></td></tr><tr><td><div style='margin-bottom:15px'><label>Password:</label><div style='height:34px;color:#555;border:1px solid #ccc;border-radius:4px;box-shadow:inset 0 1px 1px rgb(0 0 0 / 8%);padding-left:10px;padding-top:11px'>Test Data</div></div></td><td><div style='margin-bottom:15px'><label>Password:</label><div style='height:34px;color:#555;border:1px solid #ccc;border-radius:4px;box-shadow:inset 0 1px 1px rgb(0 0 0 / 8%);padding-left:10px;padding-top:11px'>Test Data</div></div></td></tr></table><div style='margin-bottom:15px'><a href='https://durableblastparts.com/SendQuotation/?v={0}&{1}' target='_blank' style='outline-style:double;color:#fff;background-color:var(--bs-btn-bg);--bs-btn-padding-x:0.75rem;display:inline-block;margin-bottom:0;font-weight:400;text-align:center;white-space:nowrap;vertical-align:middle;-ms-touch-action:manipulation;touch-action:manipulation;cursor:pointer;background-image:none;border:1px solid transparent;padding:6px 12px;line-height:1.42857143;border-radius:4px;text-decoration:none;background-color:#0d6efd'>Click to Reply to Vendor</a><a href='https://durableblastparts.com/SendQuotation/?v={0}&{1}' target='_blank' style='outline-style:double;color:#fff;background-color:var(--bs-btn-bg);--bs-btn-padding-x:0.75rem;display:inline-block;margin-bottom:0;font-weight:400;text-align:center;white-space:nowrap;vertical-align:middle;-ms-touch-action:manipulation;touch-action:manipulation;cursor:pointer;background-image:none;border:1px solid transparent;padding:6px 12px;line-height:1.42857143;border-radius:4px;text-decoration:none;background-color:#0d6efd'>Click to Reply to Vendor</a></div></div><div style='text-align:center;padding:4px;margin-bottom:0;background-color:#343a40;border-bottom:1px solid rgba(0,0,0,.125);word-wrap:break-word;border-radius:calc(.25rem - 1px) calc(.25rem - 1px) 0 0;color:#fff!important'><p>© Copyright 2000 - 2022 Quackit.com &nbsp;</p></div></div></body></html>",
                    qutation.ProductID,qutation.CustomerID));
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
                    RequestUri = new Uri(@"https://api.bigcommerce.com/stores/v1jfzk44hb/v2/customers/" + id),
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
                    RequestUri = new Uri("https://api.bigcommerce.com/stores/v1jfzk44hb/v3/catalog/products/" + id),
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

        [AllowAnonymous]
        [HttpGet]
        [Route("AddtoCartItem/{id}/{productid}/{listprice}/{quantity}")]
        [ResponseType(typeof(Response<Products>))]
        public async Task<HttpResponseMessage> AddtoCartItem(int id,int productid,int listprice,int quantity)
        {
            try
            {
                List<LineItem> lineItems = new List<LineItem>();
                LineItem lineitem = new LineItem()
                {
                    Quantity = quantity,
                    ProductId = productid,
                    ListPrice = listprice,
                    Name = "",
                };
                lineItems.Add(lineitem);
                Root rootobj = new Root()
                {
                    ChannelId = 1,
                    Currency = new Currency() { Code = "USD" },
                    CustomerId = id,
                    LineItems = lineItems,
                    Locale = "en-US"
                };
                //JavaScriptSerializer javaScriptSerializer = new JavaScriptSerializer();
                //string data = javaScriptSerializer.Serialize(rootobj);
                var data = JsonConvert.SerializeObject(rootobj);
                var client = new HttpClient();
                var request = new HttpRequestMessage
                {
                    Method = HttpMethod.Post,
                    RequestUri = new Uri("https://api.bigcommerce.com/stores/v1jfzk44hb/v3/carts?include=redirect_urls"),
                    Headers =
                    {
                        { "Accept", "application/json" },
                        { "X-Auth-Token", "5piuvue6hajkrztj17s04yusux8xffm" },
                    },
                    Content = new StringContent(data)
                    {
                        Headers =
                        {
                            ContentType = new MediaTypeHeaderValue("application/json")
                        }
                    }
                };
                using (var response = await client.SendAsync(request))
                {
                    var d = response.EnsureSuccessStatusCode();
                    if (d.IsSuccessStatusCode)
                    {
                        var str = await response.Content.ReadAsStringAsync();
                        RootResponse _products = JsonConvert.DeserializeObject<RootResponse>(str);
                        return await CreateResponse(_products, Convert.ToString(typeof(RootResponse).Name));
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
