using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ReadyToWin.Complaince.Entities.RequestModels
{
    public class TemplateRequestEditModel
    {
        [Required]
        public long ReportTemplateId { get; set; }
        [Required]
        public string ReportName { get; set; }
        [Required]
        public string UpdatedBy { get; set; }
    }

    public class TemplateRequestDeleteModel
    {
        [Required]
        public long ReportTemplateId { get; set; }
        [Required]
        public string DeletedBy { get; set; }
    }
}
