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
    public class Response    {
        public string message_id { get; set; }
        public int message_count { get; set; }
       
    }
    public class UserAmountDeposit : Base
    {
        public long Id { get; set; }
        public long UserId { get; set; }
        public string UserName { get; set; }
        [Required]
        [Display(Name = "DepositAmount")]
        public decimal DepositAmount { get; set; }
        public byte[] PaymentScreenshot { get; set; }
        public long PaymentModeId { get; set; }
        public string Status { get; set; }
        public decimal ApprovedAmount { get; set; }
        public string Remarks { get; set; }
        public DateTime CreatedDate { get; set; }
        public string CreatedBy { get; set; }
        public DateTime UpdatedDate { get; set; }
        public string UpdatedBy { get; set; }
        public Boolean isActive { get; set; }
        public Boolean isDeleted { get; set; }

    }
}
