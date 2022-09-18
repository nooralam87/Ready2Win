using ReadyToWin.Complaince.Entities.BaseModel;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ReadyToWin.Complaince.Entities.GameType
{
    public class GameType : Base
    {
        public long GameTypeId { get; set; }

        [Required]
        [Display(Name = "GameName")]
        public string GameName { get; set; }

        [Required]
        [Display(Name = "StartDate")]
        public DateTime StartDate { get; set; }

        [Required]
        [Display(Name = "EndDate")]
        public DateTime EndDate { get; set; }

    }
}
