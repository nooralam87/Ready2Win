using ReadyToWin.Complaince.Entities.BaseModel;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ReadyToWin.Complaince.Entities.AdminModel
{
    public class Response
    {
        public string message_id { get; set; }
        public int message_count { get; set; }
        public double price { get; set; }
    }
    public class RootObject
    {
        public Response Response { get; set; }
        public string ErrorMessage { get; set; }
        public int Status { get; set; }
    }
    public class Admin : Base
    {
        public long Id { get; set; }
        public long UserId { get; set; }
        public long GameTypeId { get; set; }
        public string GameTypeName { get; set; }
        public long GameCategoryId { get; set; }
        public string CategoryName { get; set; }
        public long GameSubCategoryId { get; set; }
        public string GameSubCategoryName { get; set; }
        public string NumberType { get; set; }
        [Required]
        [Display(Name = "WinningAmount")]
        public double WinningAmount { get; set; }
        public string Remarks { get; set; }
        public Boolean isActive { get; set; }
        public Boolean isDeleted { get; set; }
        public DateTime CreatedDate { get; set; }
        public string CreatedBy { get; set; }
        public DateTime UpdatedDate { get; set; }
        public string UpdatedBy { get; set; }
        public double ApprovedAmount { get; set; }
        public long AdminUserId { get; set; }
       
    }
}
