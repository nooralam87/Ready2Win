using ReadyToWin.Complaince.Entities.BaseModel;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ReadyToWin.Complaince.Entities.UserTransaction
{
    public class UserWalletBalance : Base
    {
        public long Id { get; set; }
        public string UserId { get; set; }
        public string UserName { get; set; }
        public string Mobile { get; set; }
        public string Email { get; set; }
        public string City { get; set; }
        public DateTime CreatedDate { get; set; }
        public decimal WalletBalance { get; set; }

    }
}
