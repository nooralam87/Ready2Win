using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ReadyToWin.Complaince.Entities.TemplateModel
{
    public class Template
    {
        public long TemplateId { get; set; }
        public long ModuleId { get; set; }
        public string ReportName { get; set; }
        public string AssociatedTable { get; set; }
        public string Remarks { get; set; }
        public List<TemplateDetail> DetailList { get; set; }
        public Template()
        {
            DetailList = new List<TemplateDetail>();
        }
    }
}
