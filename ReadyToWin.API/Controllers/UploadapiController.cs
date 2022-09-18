using OfficeOpenXml;
using ReadyToWin.API.Models;
using System;
using System.Collections.Generic;
using System.Globalization;
using System.IO;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Text;
using System.Threading;
using System.Threading.Tasks;
using System.Web;
using System.Web.Http;

namespace ReadyToWin.API.Controllers
{
    [RoutePrefix("api/Upload")]
    public class UploadapiController : ApiController
    {
        [Route("Product")]
        [HttpPost]
        public Task ProductList()
        {

            List<string> savedFilePath = new List<string>();
            if (!Request.Content.IsMimeMultipartContent())
            {
                throw new HttpResponseException(HttpStatusCode.UnsupportedMediaType);
            }
            string rootPath = HttpContext.Current.Server.MapPath("~/UploadedFiles");
            var provider = new MultipartFileStreamProvider(rootPath);
            var task = Request.Content.ReadAsMultipartAsync(provider).
            ContinueWith(t => {
                if (t.IsCanceled || t.IsFaulted)
                {
                    Request.CreateErrorResponse(HttpStatusCode.InternalServerError, t.Exception);
                }
                foreach (MultipartFileData item in provider.FileData)
                {
                    try
                    {
                        FileInfo file = new FileInfo(Path.Combine(item.LocalFileName));
                        ExcelSingle _obj_singl = new ExcelSingle();
                        string name = item.Headers.ContentDisposition.FileName.Replace("\"", "");
                        string newFileName = Guid.NewGuid() + Path.GetExtension(name);
                        File.Move(item.LocalFileName, Path.Combine(rootPath, newFileName));
                        List<ProductAttribute> _list = _obj_singl.GetCsvData(Path.Combine(rootPath, newFileName));
                        List<ProductAttribute> _list_error = new List<ProductAttribute>();
                        foreach (ProductAttribute _item in _list)
                        {
                            using (BigCommerce big=new BigCommerce())
                            {
                                if (string.IsNullOrEmpty(_item.ProductID) || !big.SaveProductInfo(_item))
                                {
                                    _list_error.Add(_item);
                                }
                            }
                        }
                    }
                    catch (Exception ex)
                    {
                        string message = ex.Message;
                    }
                }
                return Request.CreateResponse(HttpStatusCode.Created, savedFilePath);
            });
            return task;
        }

        [Route ("Vendor")]
        [HttpPost]
        public Task VendorList()
        {

            List<string> savedFilePath = new List<string>();
            if (!Request.Content.IsMimeMultipartContent())
            {
                throw new HttpResponseException(HttpStatusCode.UnsupportedMediaType);
            }
            string rootPath = HttpContext.Current.Server.MapPath("~/UploadedFiles");
            var provider = new MultipartFileStreamProvider(rootPath);
            var task = Request.Content.ReadAsMultipartAsync(provider).
            ContinueWith(t => {
                if (t.IsCanceled || t.IsFaulted)
                {
                    Request.CreateErrorResponse(HttpStatusCode.InternalServerError, t.Exception);
                }
                foreach (MultipartFileData item in provider.FileData)
                {
                    try
                    {
                        FileInfo file = new FileInfo(Path.Combine(item.LocalFileName));
                        ExcelSingle _obj_singl = new ExcelSingle();
                        string name = item.Headers.ContentDisposition.FileName.Replace("\"", "");
                        string newFileName = Guid.NewGuid() + Path.GetExtension(name);
                        File.Move(item.LocalFileName, Path.Combine(rootPath, newFileName));
                        List<VendorAttribute> _list = _obj_singl.GetVendorCsvData(Path.Combine(rootPath, newFileName));
                        List<VendorAttribute> _list_error = new List<VendorAttribute>();
                        foreach (VendorAttribute _item in _list)
                        {
                            using (BigCommerce big = new BigCommerce())
                            {
                                if (string.IsNullOrEmpty(_item.VendorName) || !big.SaveVendorInfo(_item))
                                {
                                    _list_error.Add(_item);
                                }
                            }
                        }
                    }
                    catch (Exception ex)
                    {
                        string message = ex.Message;
                    }
                }
                return Request.CreateResponse(HttpStatusCode.Created, savedFilePath);
            });
            return task;
        }

        #region
        //public Task BackupCopy()
        //{

        //    List<string> savedFilePath = new List<string>();
        //    if (!Request.Content.IsMimeMultipartContent())
        //    {
        //        throw new HttpResponseException(HttpStatusCode.UnsupportedMediaType);
        //    }
        //    string rootPath = HttpContext.Current.Server.MapPath("~/UploadedFiles");
        //    var provider = new MultipartFileStreamProvider(rootPath);
        //    var task = Request.Content.ReadAsMultipartAsync(provider).
        //    ContinueWith(t => {
        //        if (t.IsCanceled || t.IsFaulted)
        //        {
        //            Request.CreateErrorResponse(HttpStatusCode.InternalServerError, t.Exception);
        //        }
        //        foreach (MultipartFileData item in provider.FileData)
        //        {
        //            try
        //            {
        //                FileInfo file = new FileInfo(Path.Combine(item.LocalFileName));
        //                ExcelSingle _obj_singl = new ExcelSingle();
        //                string name = item.Headers.ContentDisposition.FileName.Replace("\"", "");
        //                string newFileName = Guid.NewGuid() + Path.GetExtension(name);
        //                File.Move(item.LocalFileName, Path.Combine(rootPath, newFileName));
        //                //_obj_singl.ProcessWorkbook("Sheet1", Path.Combine(rootPath, newFileName));
        //                //_obj_singl.ProcessCSV(Path.Combine(rootPath, newFileName));
        //                _obj_singl.GetCsvData(Path.Combine(rootPath, newFileName));
        //                Uri baseuri = new Uri(Request.RequestUri.AbsoluteUri.Replace(Request.RequestUri.PathAndQuery, string.Empty));
        //                string fileRelativePath = "~/UploadedFiles/" + newFileName;
        //                Uri fileFullPath = new Uri(baseuri, VirtualPathUtility.ToAbsolute(fileRelativePath));
        //                savedFilePath.Add(fileFullPath.ToString());

        //                _obj_singl.ProcessWorkbook("Sheet1", fileFullPath.ToString());
        //                UploadFile(file);
        //            }
        //            catch (Exception ex)
        //            {
        //                string message = ex.Message;
        //            }
        //        }
        //        return Request.CreateResponse(HttpStatusCode.Created, savedFilePath);
        //    });
        //    return task;
        //}
        #endregion
        private void UploadFile(FileInfo file)
        {
            
            //set the formatting options
            ExcelTextFormat format = new ExcelTextFormat();
            format.Delimiter = ';';
            format.Culture = new CultureInfo(Thread.CurrentThread.CurrentCulture.ToString());
            format.Culture.DateTimeFormat.ShortDatePattern = "dd-mm-yyyy";
            format.Encoding = new UTF8Encoding();

            //read the CSV file from disk
            //FileInfo file = new FileInfo(Path.Combine(_file));
            //or if you use asp.net, get the relative path
            //FileInfo file = new FileInfo(Server.MapPath("CSVDemo.csv"));

            //create a new Excel package
            using (ExcelPackage excelPackage = new ExcelPackage())
            {
                //create a WorkSheet
                ExcelWorksheet worksheet = excelPackage.Workbook.Worksheets.Add("Sheet 1");

                //load the CSV data into cell A1
                worksheet.Cells["A1"].LoadFromText(file, format);
            }
        }
    }
}
