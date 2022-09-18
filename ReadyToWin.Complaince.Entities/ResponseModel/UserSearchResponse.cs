using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ReadyToWin.Complaince.Entities.ResponseModel
{
    public class UserSearchResponse
    {
        public int Count { get; set; }
        public DataTable result { get; set; }
    }
}
