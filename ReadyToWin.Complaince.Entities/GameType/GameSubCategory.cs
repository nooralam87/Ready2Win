using ReadyToWin.Complaince.Entities.BaseModel;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ReadyToWin.Complaince.Entities.GameType
{
    public class GameSubCategory : Base
    {
        [Display(Name = "GameSubCategoryId")]
        public long GameSubCategoryId { get; set; }

        [Required]
        [Display(Name = "GameCategeryId")]
        public GameCategory GameCategeryId { get; set; }
        
        [Required]
        [Display(Name = "SubCategoryName")]
        public string SubCategoryName { get; set; }

        [Required]
        [Display(Name = "bidRate")]
        public Decimal bidRate { get; set; }

    }
}
