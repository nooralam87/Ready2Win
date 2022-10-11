using ReadyToWin.Complaince.Entities.BaseModel;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ReadyToWin.Complaince.Entities.AdminModel
{
     
    public class AmountOnGameByGameType : Base
    {
        public long GameBettingId { get; set; }
        public long UserId { get; set; }
        public string UserName { get; set; }
        public long GameTypeId { get; set; }
        public string GameTypeName { get; set; }
        public long GameCategoryId { get; set; }
        public string CategoryName { get; set; }
        public long GameSubCategoryId { get; set; }
        public string GameSubCategoryName { get; set; }       
        public int BetNumber { get; set; }
        public decimal BetAmount { get; set; }
        public DateTime createdDate { get; set; }

    }
}
