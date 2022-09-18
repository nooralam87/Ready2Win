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
    public class UserGameSelection :Base
    {
        public long UserId { get; set; }
        public long GameTypeId { get; set; }       
        public string GameTypeName { get; set; }
        public long GameCategoryId { get; set; }
        public string CategoryName { get; set; }
        public long GameSubCategoryId { get; set; }
        public string GameSubCategoryName { get; set; }
        public string NumberType { get; set; }
        public double Amount { get; set; }
        public string BetNumbers { get; set; }
        public string BetAmounts { get; set; }
        
    }
}
