using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using ReadyToWin.Complaince.Entities.BaseModel;

namespace ReadyToWin.Complaince.Entities.UserTransaction
{
    public class UserAmountWithdraw : Base
    {
        public long Id { get; set; }
        public long UserId { get; set; }
        [Required]
        [Display(Name = "UserRequestedAmount")]
        public decimal RequestedAmount { get; set; }
        public string MobileNoForPayment { get; set; }

        public string UserName { get; set; }
        public string Status { get; set; }
        public decimal ApprovedAmount { get; set; }
        public long PaymentModeId { get; set; }
        public long GameTypeId { get; set; }
        public long GameSubTypeId { get; set; }
        public string Remarks { get; set; }
        public DateTime CreatedDate { get; set; }
        public string CreatedBy { get; set; }
        public DateTime UpdatedDate { get; set; }
        public string UpdatedBy { get; set; }
        public Boolean isActive { get; set; }
        public Boolean isDeleted { get; set; }
    }
}
