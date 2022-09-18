using ReadyToWin.Complaince.Entities.BaseModel;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ReadyToWin.Complaince.Entities.UserModel
{
    public class Department:Base
    {
        public long Id { get; set; }
        [Required]
        [Display(Name = "Department Name")]
        public string Name { get; set; }
    }
}
