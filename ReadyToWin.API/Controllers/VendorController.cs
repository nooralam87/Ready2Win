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

namespace ReadyToWin.API.Controllers
{
    [RoutePrefix("api/CreateQutation")]
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
            //save user
            var output = _vendor_service.RequestVendor(vendor);
            string concat_email = string.Join(",", _vendor_service.GetAllVendors());
            //if (output.Message == "User created")
            //{
                await _smtpClient.SendEmailAsync(concat_email, "Hello", "Hello, This is Email sending test using gmail.");
            //}
            return await CreateResponse(output);
        }
    }
}
