using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ReadyToWin.Complaince.Entities.RequestModel
{
    public class GridRequestModel
    {
        public long TemplateId { get; set; }
        public int PageSize { get; set; }
        public int CurrentPage { get; set; }
        public string SortColumn { get; set; }
        public string SortOrder { get; set; }
        public string ColumnName { get; set; }
        public string Operator { get; set; }
        public string Value { get; set; }
        public Dictionary<string, string> ColumnParams { get; set; }
    }
}
