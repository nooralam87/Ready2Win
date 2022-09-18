using System;
using System.IO;
using System.Reflection;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data.OleDb;
using System.Data;
using Microsoft.VisualBasic.FileIO;

namespace ReadyToWin.API.Models
{

    public class ExcelSingle
    {
       
        public DataTable ProcessWorkbook(string sheetName, string path)
        {
            
            using (OleDbConnection conn = new OleDbConnection())
            {
                DataTable dt = new DataTable();
                try
                {
                    
                    string Import_FileName = path;
                    string fileExtension = Path.GetExtension(Import_FileName);
                    if (fileExtension == ".xls")
                        conn.ConnectionString = "Provider=Microsoft.Jet.OLEDB.4.0;Data Source=" + Import_FileName + ";" + "Extended Properties='Excel 8.0;HDR=YES;'";
                    if (fileExtension == ".xlsx")
                        conn.ConnectionString = "Provider=Microsoft.ACE.OLEDB.12.0;Data Source=" + Import_FileName + ";" + "Extended Properties='Excel 12.0 Xml;HDR=YES;'";

                    //conn.ConnectionString = "Provider=Microsoft.ACE.OLEDB.12.0;Data Source=" + path
                    //+ ";Extended Properties='Excel 12.0 Xml;HDR=YES;IMEX=1;MAXSCANROWS=0'";
                    using (OleDbCommand comm = new OleDbCommand())
                    {
                        comm.CommandText = "Select * from [" + sheetName + "$]";
                        comm.Connection = conn;
                        using (OleDbDataAdapter da = new OleDbDataAdapter())
                        {
                            da.SelectCommand = comm;
                            da.Fill(dt);
                            return dt;
                        }
                    }
                }
                catch
                {
                    return dt;
                }
            }
        }
        public DataTable ProcessCSV(string path)
        {

            using (OleDbConnection conn = new OleDbConnection())
            {
                DataTable dt = new DataTable();
                try
                {

                    string Import_FileName = path;
                    string fileExtension = Path.GetExtension(Import_FileName);
                    conn.ConnectionString = string.Format(@"Provider=Microsoft.Jet.OleDb.4.0; Data Source={0};Extended Properties=""Text;HDR=YES;FMT=Delimited""",Path.GetDirectoryName(path));

                    using (OleDbCommand comm = new OleDbCommand())
                    {
                        comm.CommandText = "Select * from [" + Path.GetFileName(path) + "$]";
                        comm.Connection = conn;
                        using (OleDbDataAdapter da = new OleDbDataAdapter())
                        {
                            da.SelectCommand = comm;
                            da.Fill(dt);
                            return dt;
                        }
                    }
                }
                catch
                {
                    return dt;
                }
            }
        }
        public void GetCsvData1(string path)
        {
            var reader = new StreamReader(File.OpenRead(path));
            List<string> listRows = new List<string>();
            while (!reader.EndOfStream)
            {
                // Read current line fields, pointer moves to the next line.
                listRows.Add(reader.ReadLine());
            }

            StreamReader sr = new StreamReader(path);
            // for set encoding
            // StreamReader sr = new StreamReader(@"file.csv", Encoding.GetEncoding(1250));

            string strline = "";
            string[] _values = null;
            int x = 0;
            while (!sr.EndOfStream)
            {
                x++;
                strline = sr.ReadLine();
                _values = strline.Split(',');
                if (_values.Length >= 6 && _values[0].Trim().Length > 0)
                {
                    Console.Write(_values[1]);
                }
            }
            sr.Close();
        }
        public List<ProductAttribute> GetCsvData(string path)
        {
            List<ProductAttribute> _list_prod = new List<ProductAttribute>();
            using (TextFieldParser csvReader = new TextFieldParser(path))
            {
                csvReader.CommentTokens = new string[] { "#" };
                csvReader.SetDelimiters(new string[] { "," });
                csvReader.HasFieldsEnclosedInQuotes = true;

                // Skip the row with the column names
                csvReader.ReadLine();

                while (!csvReader.EndOfData)
                {
                    ProductAttribute _prod = new ProductAttribute();
                    // Read current line fields, pointer moves to the next line.
                    string[] fields = csvReader.ReadFields();
                    #region
                    _prod.ProductID = fields[0];
                    _prod.ProductType = fields[1];
                    _prod.Code = fields[2];
                    _prod.Name = fields[3];
                    _prod.Brand = fields[4];
                    _prod.Description = fields[5];
                    _prod.CostPrice = fields[6];
                    _prod.RetailPrice = fields[7];
                    _prod.SalePrice = fields[8];
                    _prod.CalculatedPrice = fields[9];
                    _prod.FixedShippingPrice = fields[10];
                    _prod.FreeShipping = fields[11];
                    _prod.Warranty = fields[12];
                    _prod.Weight = fields[13];
                    _prod.Width = fields[14];
                    _prod.Height = fields[15];
                    _prod.Depth = fields[16];
                    _prod.AllowPurchases = fields[17];
                    _prod.ProductVisible = fields[18];
                    _prod.ProductAvailability = fields[19];
                    _prod.ProductInventoried = fields[20];
                    _prod.StockLevel = fields[21];
                    _prod.LowStockLevel = fields[22];
                    _prod.DateAdded = fields[23];
                    _prod.DateModified = fields[24];
                    _prod.CategoryDetails = fields[25];
                    _prod.Images = fields[26];
                    _prod.PageTitle = fields[27];
                    _prod.METAKeywords = fields[28];
                    _prod.METADescription = fields[29];
                    _prod.ProductCondition = fields[30];
                    _prod.ProductURL = fields[31];
                    _prod.RedirectOldURL = fields[32];
                    _prod.ProductTaxCode = fields[33];
                    _prod.ProductCustomFields = fields[34];
                    #endregion
                    _list_prod.Add(_prod);
                }

            }
            return _list_prod;
        }
        public List<VendorAttribute> GetVendorCsvData(string path)
        {
            List<VendorAttribute> _list_vendor = new List<VendorAttribute>();
            using (TextFieldParser csvReader = new TextFieldParser(path))
            {
                csvReader.CommentTokens = new string[] { "#" };
                csvReader.SetDelimiters(new string[] { "," });
                csvReader.HasFieldsEnclosedInQuotes = true;

                // Skip the row with the column names
                csvReader.ReadLine();

                while (!csvReader.EndOfData)
                {
                    VendorAttribute _vendor = new VendorAttribute();
                    // Read current line fields, pointer moves to the next line.
                    string[] fields = csvReader.ReadFields();
                    #region
                    _vendor.VendorName = fields[0];
                    _vendor.Address = fields[1];
                    _vendor.City = fields[2];
                    _vendor.State = fields[3];
                    _vendor.Zip = fields[4];
                    _vendor.ContactName = fields[5];
                    _vendor.ContactNumber = fields[6];
                    _vendor.ContactEmail = fields[7];
                    _vendor.PartTypeCategory = fields[8];
                    _vendor.PaymentTermsOffered = fields[9];
                    _vendor.ShippingNotes = fields[10];
                    #endregion
                    _list_vendor.Add(_vendor);
                }

            }
            return _list_vendor;
        }
    }
}