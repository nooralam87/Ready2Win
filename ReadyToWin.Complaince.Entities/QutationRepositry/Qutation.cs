using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using ReadyToWin.Complaince.Entities.BaseModel;

namespace ReadyToWin.Complaince.Entities.QutationRepositry
{
    public class Qutation: Base
    {
        public int ProductID { get; set; }
        public string CustomerEmailID { get; set; }
        public string CustomerID { get; set; }
        public Decimal DefaultPrice { get; set; }
        public int Stock { get; set; }
        public int LowStock { get; set; }
        public string UserName { get; set; }
        public string IPAdress { get; set; }

    }
}
