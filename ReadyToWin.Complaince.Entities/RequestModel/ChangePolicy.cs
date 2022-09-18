using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ReadyToWin.Complaince.Entities.RequestModels
{
    public class ChangePolicyStatusModel
    {
        [Required]
        public string PolicyIds { get; set; }
        [Required]
        public int Status { get; set; }
        [Required]
        public string Remarks { get; set; }
        [Required]
        public long DepartmentId { get; set; }
        [Required]
        public string UpdatedBy { get; set; }
    }

    public class GetPolicyDetailModel
    {
        public string PolicyId { get; set; }
        public long ReportId { get; set; }
    }
}
