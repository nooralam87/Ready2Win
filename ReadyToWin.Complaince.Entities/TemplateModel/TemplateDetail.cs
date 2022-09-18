using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ReadyToWin.Complaince.Entities.TemplateModel
{
    public class TemplateDetail
    {
        public long TemplateId { get; set; }
        public long ColumnId { get; set; }
        public long ModuleId { get; set; }
        public string ColumnName { get; set; }
        public string DataType { get; set; }
        public string DisplayName { get; set; }
        public bool OrderBy { get; set; }
    }
}
