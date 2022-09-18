using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;

namespace ReadyToWin.API.Models
{
    public class BigCommerce:IDisposable
    {
        readonly SqlConnection cnn;
        public BigCommerce()
        {
            cnn = new SqlConnection();
            cnn.ConnectionString = ConfigurationManager.ConnectionStrings["BigCommerce_Connection"].ConnectionString;
        }
        public bool SaveProductInfo(ProductAttribute product)
        {
            try
            {
                SqlCommand cmd = new SqlCommand();
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.CommandText = "InsertProductInfo";
                cmd.Connection = cnn;
                #region Adding Parameter
                cmd.Parameters.AddWithValue("@ProductID", product.ProductID);
                cmd.Parameters.AddWithValue("@ProductType", product.ProductType);
                cmd.Parameters.AddWithValue("@Code", product.Code);
                cmd.Parameters.AddWithValue("@Name", product.Name);
                cmd.Parameters.AddWithValue("@Brand", product.Brand);
                cmd.Parameters.AddWithValue("@Description", product.Description);
                cmd.Parameters.AddWithValue("@CostPrice", product.CostPrice);
                cmd.Parameters.AddWithValue("@RetailPrice", product.RetailPrice);
                cmd.Parameters.AddWithValue("@SalePrice", product.SalePrice);
                cmd.Parameters.AddWithValue("@CalculatedPrice", product.CalculatedPrice);
                cmd.Parameters.AddWithValue("@FixedShippingPrice", product.FixedShippingPrice);
                cmd.Parameters.AddWithValue("@FreeShipping", GetBooleanFrom(product.FreeShipping));
                cmd.Parameters.AddWithValue("@AllowPurchases", GetBooleanFrom(product.AllowPurchases));
                cmd.Parameters.AddWithValue("@ProductVisible", GetBooleanFrom(product.ProductVisible));
                cmd.Parameters.AddWithValue("@ProductAvailability", GetBooleanFrom(product.ProductAvailability));
                cmd.Parameters.AddWithValue("@ProductInventoried", GetBooleanFrom(product.ProductInventoried));
                cmd.Parameters.AddWithValue("@StockLevel", product.StockLevel);
                cmd.Parameters.AddWithValue("@LowStockLevel", product.LowStockLevel);
                cmd.Parameters.AddWithValue("@CategoryDetails", product.CategoryDetails);
                cmd.Parameters.AddWithValue("@Images", product.Images);
                cmd.Parameters.AddWithValue("@PageTitle", product.PageTitle);
                cmd.Parameters.AddWithValue("@METAKeywords", product.METAKeywords);
                cmd.Parameters.AddWithValue("@METADescription", product.METADescription);
                cmd.Parameters.AddWithValue("@ProductCondition", product.ProductCondition);
                cmd.Parameters.AddWithValue("@ProductURL", product.ProductURL);
                cmd.Parameters.AddWithValue("@RedirectOldURL", product.RedirectOldURL);
                cmd.Parameters.AddWithValue("@ProductTaxCode", product.ProductTaxCode);
                cmd.Parameters.AddWithValue("@ProductCustomFields", product.ProductCustomFields);
                #endregion
                cnn.Open();
                int i = cmd.ExecuteNonQuery();
                if (i > 0)
                {
                    return true;
                }
                else
                {
                    return false;
                }
            }
            catch(SqlException ex)
            {
                Console.WriteLine("Error:- " + ex.Message);
                return false;
            }
        }
        public bool SaveVendorInfo(VendorAttribute vendor)
        {
            try
            {
                SqlCommand cmd = new SqlCommand();
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.CommandText = "InsertVendorInfo";
                cmd.Connection = cnn;
                #region Adding Parameter
                cmd.Parameters.AddWithValue("@VendorName", vendor.VendorName);
                cmd.Parameters.AddWithValue("@Address", vendor.Address);
                cmd.Parameters.AddWithValue("@State", vendor.State);
                cmd.Parameters.AddWithValue("@Zip", vendor.Zip);
                cmd.Parameters.AddWithValue("@ContactName", vendor.ContactName);
                cmd.Parameters.AddWithValue("@ShippingNotes", vendor.ShippingNotes);
                cmd.Parameters.AddWithValue("@ContactNumber", vendor.ContactNumber);
                cmd.Parameters.AddWithValue("@ContactEmail", vendor.ContactEmail);
                cmd.Parameters.AddWithValue("@PartTypeCategory", vendor.PartTypeCategory);
                cmd.Parameters.AddWithValue("@PaymentTermsOffered", vendor.PaymentTermsOffered);
                cmd.Parameters.AddWithValue("@City", vendor.City);
                #endregion
                cnn.Open();
                int i = cmd.ExecuteNonQuery();
                if (i > 0)
                {
                    return true;
                }
                else
                {
                    return false;
                }
            }
            catch (SqlException ex)
            {
                Console.WriteLine("Error:- " + ex.Message);
                return false;
            }
        }
        protected bool GetBooleanFrom(string key)
        {
            switch (key.Trim().ToUpper())
            {
                case "NO":
                case "N":
                case "0":
                case "":
                case " ":
                    key = "0";
                    break;
                default:
                    key = "1";
                    break;
            }
            return key == "1" ? true : false;
        }
        public void Dispose()
        {
            if (cnn.State == ConnectionState.Open)
            {
                cnn.Close();
            }
        }
    }
}