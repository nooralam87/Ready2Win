using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ReadyToWin.Complaince.Entities.QutationRepositry
{
    public class Products
    {
        public Data data { get; set; }
        public Meta meta { get; set; }
    }
    public class CustomUrl
    {
        public string url { get; set; }
        public bool is_customized { get; set; }
    }

    public class Data
    {
        public int id { get; set; }
        public string name { get; set; }
        public string type { get; set; }
        public string sku { get; set; }
        public string description { get; set; }
        public int weight { get; set; }
        public int width { get; set; }
        public int depth { get; set; }
        public int height { get; set; }
        public int price { get; set; }
        public int cost_price { get; set; }
        public int retail_price { get; set; }
        public int sale_price { get; set; }
        public int map_price { get; set; }
        public int tax_class_id { get; set; }
        public string product_tax_code { get; set; }
        public int calculated_price { get; set; }
        public List<int> categories { get; set; }
        public int brand_id { get; set; }
        public object option_set_id { get; set; }
        public string option_set_display { get; set; }
        public int inventory_level { get; set; }
        public int inventory_warning_level { get; set; }
        public string inventory_tracking { get; set; }
        public int reviews_rating_sum { get; set; }
        public int reviews_count { get; set; }
        public int total_sold { get; set; }
        public int fixed_cost_shipping_price { get; set; }
        public bool is_free_shipping { get; set; }
        public bool is_visible { get; set; }
        public bool is_featured { get; set; }
        public List<int> related_products { get; set; }
        public string warranty { get; set; }
        public string bin_picking_number { get; set; }
        public string layout_file { get; set; }
        public string upc { get; set; }
        public string mpn { get; set; }
        public string gtin { get; set; }
        public string search_keywords { get; set; }
        public string availability { get; set; }
        public string availability_description { get; set; }
        public string gift_wrapping_options_type { get; set; }
        public List<object> gift_wrapping_options_list { get; set; }
        public int sort_order { get; set; }
        public string condition { get; set; }
        public bool is_condition_shown { get; set; }
        public int order_quantity_minimum { get; set; }
        public int order_quantity_maximum { get; set; }
        public string page_title { get; set; }
        public List<object> meta_keywords { get; set; }
        public string meta_description { get; set; }
        public DateTime date_created { get; set; }
        public DateTime date_modified { get; set; }
        public int view_count { get; set; }
        public object preorder_release_date { get; set; }
        public string preorder_message { get; set; }
        public bool is_preorder_only { get; set; }
        public bool is_price_hidden { get; set; }
        public string price_hidden_label { get; set; }
        public CustomUrl custom_url { get; set; }
        public int base_variant_id { get; set; }
        public string open_graph_type { get; set; }
        public string open_graph_title { get; set; }
        public string open_graph_description { get; set; }
        public bool open_graph_use_meta_description { get; set; }
        public bool open_graph_use_product_name { get; set; }
        public bool open_graph_use_image { get; set; }
    }

    public class Meta
    {
    }
}
