using Newtonsoft.Json;
using ReadyToWin.Complaince.Entities.CartsModel;
using ReadyToWin.Complaince.Framework.Utility;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net.Http;
using System.Net.Http.Headers;
using System.Threading.Tasks;
using System.Web;
using System.Web.Mvc;

namespace ReadyToWin.API.Controllers
{
    public class BigCommerceIntigrationController : Controller
    {
        // GET: BigCommerceIntigration
        public ActionResult Index()
        {
            return View();
        }
        public ActionResult ProductCheckout(string data)
        {
            string[] _data = EncryptionLibrary.DecryptText(data.Replace(' ','+')).Split('|');
            RootResponse _products=AddToCart(_data);
            if (_products != null)
            {
                return RedirectPermanent(_products.Data.RedirectUrls.CartUrl);
                //Redirect(_products.Data.RedirectUrls.CartUrl);
            }
            else
            {
                return RedirectToAction("ProductCheckout");
            }
            //return Redirect("https://durableblastparts.com/cart.php?action=load&id=2ceb9801-0250-4c46-8f6c-51d21e1402ae&token=eb43075b262d106db5281aa2871ee065b7332b8a3cea164938c4176172e64e42");
        }

        private RootResponse AddToCart(string[] _data)
        {
            RootResponse _products=new RootResponse();
            try
            {
                List<LineItem> lineItems = new List<LineItem>();
                LineItem lineitem = new LineItem()
                {
                    Quantity = Int32.Parse(_data[3]),
                    ProductId = Int32.Parse(_data[1]),
                    ListPrice = Int32.Parse(_data[2]),
                    Name = "",
                };
                lineItems.Add(lineitem);
                Root rootobj = new Root()
                {
                    ChannelId = 1,
                    Currency = new Currency() { Code = "USD" },
                    CustomerId = Int32.Parse(_data[0]),
                    LineItems = lineItems,
                    Locale = "en-US"
                };
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
                using (var response = client.SendAsync(request).Result)
                {
                    var d = response.EnsureSuccessStatusCode();
                    if (d.IsSuccessStatusCode)
                    {
                        var str = response.Content.ReadAsStringAsync().Result;
                       _products = JsonConvert.DeserializeObject<RootResponse>(str);
                        return _products;
                    }
                    else
                    {
                        _products = null;
                        Response.Write("Some thing is Wrong Contact the Customer care code:1001");
                        return _products;
                    }

                }
            }
            catch (Exception ex)
            {
                _products = null;
                Response.Write("Some thing is Wrong Contact the Customer care code:1001 and Message:"+ex.Message);
                return _products;
            }
        }
    }
}