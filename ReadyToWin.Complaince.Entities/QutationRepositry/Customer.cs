using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ReadyToWin.Complaince.Entities.QutationRepositry
{
    #region Customer
    public class Customer
    {
        public int id { get; set; }
        public string company { get; set; }
        public string first_name { get; set; }
        public string last_name { get; set; }
        public string email { get; set; }
        public string phone { get; set; }
        public object form_fields { get; set; }
        public string date_created { get; set; }
        public string date_modified { get; set; }
        public string store_credit { get; set; }
        public string registration_ip_address { get; set; }
        public int customer_group_id { get; set; }
        public string notes { get; set; }
        public string tax_exempt_category { get; set; }
        public bool reset_pass_on_login { get; set; }
        public bool accepts_marketing { get; set; }
        public Addresses addresses { get; set; }
    }
    public class Addresses
    {
        public string url { get; set; }
        public string resource { get; set; }
    }
    #endregion
}
