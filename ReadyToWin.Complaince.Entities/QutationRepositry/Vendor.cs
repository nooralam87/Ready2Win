using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using ReadyToWin.Complaince.Entities.BaseModel;

namespace ReadyToWin.Complaince.Entities.QutationRepositry
{
    public class Vendor:Base
    {
        public int Id { get; set; }
        public int CustomerID { get; set; }
        public string CustomerEmailID { get; set; }
        public int ProductID { get; set; }
        public int VendorID { get; set; }
        public string VendorName { get; set; }
        public Decimal Price { get; set; }
        public int Stock { get; set; }
        public string Description { get; set; }
        public string IPAdress { get; set; }
    }
}
