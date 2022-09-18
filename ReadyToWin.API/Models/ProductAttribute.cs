namespace ReadyToWin.API.Models
{
    public class ProductAttribute
    {
        public string ProductID { get; set; }
        public string ProductType { get; set; }
        public string Code { get; set; }
        public string Name { get; set; }
        public string Brand { get; set; }
        public string Description { get; set; }
        public string CostPrice { get; set; }
        public string RetailPrice { get; set; }
        public string SalePrice { get; set; }
        public string CalculatedPrice { get; set; }
        public string FixedShippingPrice { get; set; }
        public string FreeShipping { get; set; }
        public string Warranty { get; set; }
        public string Weight { get; set; }
        public string Width { get; set; }
        public string Height { get; set; }
        public string Depth { get; set; }
        public string AllowPurchases { get; set; }
        public string ProductVisible { get; set; }
        public string ProductAvailability { get; set; }
        public string ProductInventoried { get; set; }
        public string StockLevel { get; set; }
        public string LowStockLevel { get; set; }
        public string DateAdded { get; set; }
        public string DateModified { get; set; }
        public string CategoryDetails { get; set; }
        public string Images { get; set; }
        public string PageTitle { get; set; }
        public string METAKeywords { get; set; }
        public string METADescription { get; set; }
        public string ProductCondition { get; set; }
        public string ProductURL { get; set; }
        public string RedirectOldURL { get; set; }
        public string ProductTaxCode { get; set; }
        public string ProductCustomFields { get; set; }

    }
    public class VendorAttribute
    {
        public string VendorID { get; set; }
        public string VendorName { get; set; }
        public string Address { get; set; }
        public string City { get; set; }
        public string State { get; set; }
        public string Zip { get; set; }
        public string ContactName { get; set; }
        public string ContactNumber { get; set; }
        public string ContactEmail { get; set; }
        public string PartTypeCategory { get; set; }
        public string PaymentTermsOffered { get; set; }
        public string ShippingNotes { get; set; }

    }
}