using ReadyToWin.Complaince.Entities.BaseModel;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ReadyToWin.Complaince.Entities.UserModel
{
    public class UserEdit : Base
    {
        [Required]
        public long Id { get; set; }
        public string UserId { get; set; }
        
        [Display(Name = "Name")]
        public string UserName { get; set; }
        
        [Display(Name = "Email")]
        public string Email { get; set; }

        [Display(Name = "City")]
        public string City { get; set; }
       
    }
}