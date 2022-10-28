using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace ReadyToWin.API.Controllers
{
    [RoutePrefix("Download")]
    public class DownloadController : Controller
    {
        // GET: Download

        [AllowAnonymous]
        [HttpGet]
        [Route("Index")]
        public ActionResult Index()
        {
            return View();
        }
        public FileResult apk(string filename)
        {
            var FileVirtualPath = "~/App_Data/"+ filename;
            return File(FileVirtualPath, "application/force-download", Path.GetFileName(FileVirtualPath));
        }
        
    }
}