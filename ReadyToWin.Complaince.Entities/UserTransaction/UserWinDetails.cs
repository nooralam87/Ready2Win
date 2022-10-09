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
    public class UserWinDetails : Base
    {
        public long WinningId { get; set; } 
        public long GameBettingId { get; set; }
        public long UserId { get; set; }
        public string UserName { get; set; }               
        public int BettingNumber { get; set; }
        public decimal BettingAmount { get; set; }
        public long GameTypeId { get; set; }
        public string GameTypeName { get; set; }
        public long GameCategoryId { get; set; }
        public string CategoryName { get; set; }
        public long GameSubCategoryId { get; set; }
        public string GameSubCategoryName { get; set; }
        public decimal WinAmount { get; set; }
        public DateTime WinDate { get; set; }


    }
}
