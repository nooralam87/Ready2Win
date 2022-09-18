using ReadyToWin.Complaince.Entities.BaseModel;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ReadyToWin.Complaince.Entities.GameType
{
    public class GameCategory : Base
    {
        [Display(Name = "GameCategoryId")]
        public long GameCategoryId { get; set; }

        [Required]
        [Display(Name = "GameTypeId")]
        public GameType GameTypeId { get; set; }
        [Required]
        [Display(Name = "CategoryName")]
        public string CategoryName { get; set; }

        [Required]
        [Display(Name = "bidRate")]
        public Decimal bidRate { get; set; }

    }
}
