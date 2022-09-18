using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ReadyToWin.Complaince.Entities.Dashboard
{
    public class ModuleReports
    {
        public ModuleReports()
        {
            ReportList = new List<Report>();
        }

        public long ModuleId { get; set; }
        public string ModuleName { get; set; }
        public List<Report> ReportList { get; set; }
    }

    public class ModuleReport
    {
        public long ModuleId { get; set; }
        public string ModuleName { get; set; }
        public long ReportId { get; set; }
        public string ReportName { get; set; }
    }

    public class Report
    {
        public long ReportId { get; set; }
        public string ReportName { get; set; }
    }
}
