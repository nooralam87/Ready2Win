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
    public class Response
    {
        public string message_id { get; set; }
        public int message_count { get; set; }
        public double price { get; set; }
    }
    public class RootObject
    {
        public Response Response { get; set; }
        public string ErrorMessage { get; set; }
        public int Status { get; set; }
    }
    public class User : Base
    {
        public long Id { get; set; }

        public string UserId { get; set; }

        //[Required]
        [Display(Name = "FirstName")]
        public string FirstName { get; set; }

        //[Required]
        [Display(Name = "LastName")]
        public string LastName { get; set; }

        [Required]
        [Display(Name = "Name")]
        public string UserName { get; set; }
        
        //[Required]
        [StringLength(100, ErrorMessage = "The {0} must be at least {2} characters long.", MinimumLength = 6)]
        [DataType(DataType.Password)]
        [Display(Name = "Password")]
        public string Password { get; set; }

        //[DataType(DataType.Password)]
        //[Display(Name = "Confirm password")]
        //[Compare("Password", ErrorMessage = "The password and confirmation password do not match.")]
        public string ConfirmPassword { get; set; }

        [Required]
        [Display(Name = "Email")]
        public string Email { get; set; }

        //[Required]
        [Display(Name = "Mobile")]
        [StringLength(10, ErrorMessage = "The length must be at least {10} characters long.", MinimumLength = 6)]
        public string Mobile { get; set; }

        //[Required]
        //[Display(Name = "Role")]
        //public long RoleId { get; set; }

        public string Roles { get; set; }

       // [Required]
        public string IPAdress { get; set; }
        public string KeyIdentifier { get; set; }
        public string OTPCode { get; set; }

        [NotMapped]
        public string Token { get; set; }

        [NotMapped]
        public List<Menu> Menus{ get; set; }

        //[Required]
        public string City { get; set; }

        public User()
        {
            Menus = new List<Menu>();
        }
    }
}
