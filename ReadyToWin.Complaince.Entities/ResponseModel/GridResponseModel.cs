using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ReadyToWin.Complaince.Entities.ResponseModel
{
    public class GridResponse
    {
        public int RowCount { get; set; }
        public int PageCount { get; set; }
        public int CurrentPage { get; set; }
        public DataTable Table { get; set; }
    }
}
