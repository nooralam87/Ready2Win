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
    public class WinNumberDeclare : Base
    {
        public long GameTypeId { get; set; }
        public string GameTypeName { get; set; }                     
        public int WinningNumber { get; set; }
        public DateTime CreatedDate { get; set; }
        
    }
}
