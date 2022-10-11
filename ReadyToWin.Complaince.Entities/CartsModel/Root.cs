using System;
using System.Collections.Generic;
using Newtonsoft.Json;

namespace ReadyToWin.Complaince.Entities.CartsModel
{
    public class Currency
    {
        [JsonProperty("code")]
        public string Code { get; set; }
    }

    public class LineItem
    {
        [JsonProperty("quantity")]
        public int Quantity { get; set; }

        [JsonProperty("product_id")]
        public int ProductId { get; set; }

        [JsonProperty("list_price")]
        public int ListPrice { get; set; }

        [JsonProperty("name")]
        public string Name { get; set; }
    }

    public class Root
    {
        [JsonProperty("customer_id")]
        public int CustomerId { get; set; }

        [JsonProperty("line_items")]
        public List<LineItem> LineItems { get; set; }

        [JsonProperty("channel_id")]
        public int ChannelId { get; set; }

        [JsonProperty("currency")]
        public Currency Currency { get; set; }

        [JsonProperty("locale")]
        public string Locale { get; set; }
    }

    // Root myDeserializedClass = JsonConvert.DeserializeObject<Root>(myJsonResponse);

    public class Data
    {
        [JsonProperty("id")]
        public string Id { get; set; }

        [JsonProperty("customer_id")]
        public int CustomerId { get; set; }

        [JsonProperty("channel_id")]
        public int ChannelId { get; set; }

        [JsonProperty("email")]
        public string Email { get; set; }

        [JsonProperty("currency")]
        public Currency Currency { get; set; }

        [JsonProperty("tax_included")]
        public bool TaxIncluded { get; set; }

        [JsonProperty("base_amount")]
        public int BaseAmount { get; set; }

        [JsonProperty("discount_amount")]
        public int DiscountAmount { get; set; }

        [JsonProperty("cart_amount")]
        public int CartAmount { get; set; }

        [JsonProperty("coupons")]
        public List<object> Coupons { get; set; }

        [JsonProperty("line_items")]
        public LineItems LineItems { get; set; }

        [JsonProperty("created_time")]
        public DateTime CreatedTime { get; set; }

        [JsonProperty("updated_time")]
        public DateTime UpdatedTime { get; set; }

        [JsonProperty("locale")]
        public string Locale { get; set; }

        [JsonProperty("redirect_urls")]
        public RedirectUrls RedirectUrls { get; set; }
    }

    public class LineItems
    {
        [JsonProperty("physical_items")]
        public List<PhysicalItem> PhysicalItems { get; set; }

        [JsonProperty("digital_items")]
        public List<object> DigitalItems { get; set; }

        [JsonProperty("gift_certificates")]
        public List<object> GiftCertificates { get; set; }

        [JsonProperty("custom_items")]
        public List<object> CustomItems { get; set; }
    }

    public class Meta
    {
    }

    public class PhysicalItem
    {
        [JsonProperty("id")]
        public string Id { get; set; }

        [JsonProperty("parent_id")]
        public object ParentId { get; set; }

        [JsonProperty("variant_id")]
        public int VariantId { get; set; }

        [JsonProperty("product_id")]
        public int ProductId { get; set; }

        [JsonProperty("sku")]
        public string Sku { get; set; }

        [JsonProperty("name")]
        public string Name { get; set; }

        [JsonProperty("url")]
        public string Url { get; set; }

        [JsonProperty("quantity")]
        public int Quantity { get; set; }

        [JsonProperty("taxable")]
        public bool Taxable { get; set; }

        [JsonProperty("image_url")]
        public string ImageUrl { get; set; }

        [JsonProperty("discounts")]
        public List<object> Discounts { get; set; }

        [JsonProperty("coupons")]
        public List<object> Coupons { get; set; }

        [JsonProperty("discount_amount")]
        public int DiscountAmount { get; set; }

        [JsonProperty("coupon_amount")]
        public int CouponAmount { get; set; }

        [JsonProperty("original_price")]
        public int OriginalPrice { get; set; }

        [JsonProperty("list_price")]
        public int ListPrice { get; set; }

        [JsonProperty("sale_price")]
        public int SalePrice { get; set; }

        [JsonProperty("extended_list_price")]
        public int ExtendedListPrice { get; set; }

        [JsonProperty("extended_sale_price")]
        public int ExtendedSalePrice { get; set; }

        [JsonProperty("is_require_shipping")]
        public bool IsRequireShipping { get; set; }

        [JsonProperty("is_mutable")]
        public bool IsMutable { get; set; }
    }

    public class RedirectUrls
    {
        [JsonProperty("cart_url")]
        public string CartUrl { get; set; }

        [JsonProperty("checkout_url")]
        public string CheckoutUrl { get; set; }

        [JsonProperty("embedded_checkout_url")]
        public string EmbeddedCheckoutUrl { get; set; }
    }

    public class RootResponse
    {
        [JsonProperty("data")]
        public Data Data { get; set; }

        [JsonProperty("meta")]
        public Meta Meta { get; set; }
    }


}
