using ReadyToWin.Complaince.Framework.Base;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;
using ReadyToWin.Complaince.BussinessProvider.IProviders;
using ReadyToWin.Complaince.Entities.ResponseModel;
using EmailServer;
using System.Threading.Tasks;
using System.Web.Http.Description;
using ReadyToWin.Complaince.Entities.QutationRepositry;
using ReadyToWin.Complaince.Framework.Utility;
using System.Configuration;

namespace ReadyToWin.API.Controllers
{
    [RoutePrefix("api/Vendor")]
    public class VendorController : BaseApiController
    {
        IVendorService _vendor_service; ISmtpClient _smtpClient;

        
        public VendorController(IVendorService IVendorService, ISmtpClient smtpClient)
        {
            this._vendor_service = IVendorService;
            this._smtpClient = smtpClient;
        }

        [AllowAnonymous]
        [HttpPost]
        [Route("VendorReply")]
        [ResponseType(typeof(Response<Vendor>))]
        public async Task<HttpResponseMessage> RequestQutation(Vendor vendor)
        {
            //encrypt password.
            vendor.IPAdress = System.Web.HttpContext.Current.Request.ServerVariables["HTTP_X_FORWARDED_FOR"];
            if (string.IsNullOrEmpty(vendor.IPAdress))
            {
                vendor.IPAdress = System.Web.HttpContext.Current.Request.ServerVariables["REMOTE_ADDR"];
            }
            Customer _customer = _vendor_service.GetCustomerTransaction(vendor.CustomerID);
            vendor.CustomerEmailID = _customer.email;vendor.CustomerID = _customer.id;
            //save user
            var output = _vendor_service.RequestVendor(ref vendor);
            string concat_email = string.Join(",", _vendor_service.GetAllVendors());
            //if (output.Message == "User created")
            //{
            string _link_info = ConfigurationManager.AppSettings["LINK"].ToString() + EncryptionLibrary.EncryptText(vendor.CustomerID + "|" + vendor.ProductID + "|" + vendor.Price + "|" + vendor.Stock);
                await _smtpClient.SendEmailAsync(concat_email, "Hello", string.Format("<p>Hello,</p><br><br><br><br>To complete your order right now, just click on the link below:<br><a href='{0}' target='_blank'>Your Order</a><br><br><br><p>We look forward to receiving your order!</p>", _link_info));
            //}
            return await CreateResponse(output);
        }

    }
}
