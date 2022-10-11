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
    public class UserBettingDetails : Base
    {
        public long GameBettingId { get; set; } 
        public long GameSelectionId { get; set; }
        public long UserId { get; set; }
        public string UserName { get; set; }               
        public int BetNumber { get; set; }
        public decimal BetAmount { get; set; }
        public string CategoryName { get; set; }
        public string GameSubCategoryName { get; set; }


    }
}
