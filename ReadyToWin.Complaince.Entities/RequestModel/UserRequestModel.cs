using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ReadyToWin.Complaince.Entities.RequestModels
{
    public class AuthModel
    {
        public string BrowserName { get; set; }
        public string IPaddress { get; set; }
        [Required]
        public string UserId { get; set; }
        [Required]
        public string Password { get; set; }
    }

    public class AssignRoleModel
    {
        [Required]
        public string UserId { get; set; }
        [Required]
        public long RoleId { get; set; }
        [Required]
        public string CreatedBy { get; set; }
    }

    public class DeleteRoleModel
    {
        [Required]
        public string UserId { get; set; }
        [Required]
        public string DeletedBy { get; set; }
    }

    public class ChangePasswordModel
    {
        [Required]
        public string UserId { get; set; }
        [Required]
        public string UpdatedBy { get; set; }
        [Required]
        [StringLength(100, ErrorMessage = "The {0} must be at least {2} characters long.", MinimumLength = 6)]
        [DataType(DataType.Password)]
        [Display(Name = "Password")]
        public string Password { get; set; }
        [Required]
       [DataType(DataType.Password)]
        [Display(Name = "Confirm new password")]
        //[Compare("NewPassword", ErrorMessage = "The new password and confirmation password do not match.")]
        public string ConfirmPassword { get; set; }
    }

    public class ResetPasswordModel
    {
        [Required]
        public string UserId { get; set; }
        [Required]
        public string UpdatedBy { get; set; }
        [Required]
        [StringLength(100, ErrorMessage = "The {0} must be at least {2} characters long.", MinimumLength = 6)]
        [DataType(DataType.Password)]
        [Display(Name = "Password")]
        public string Password { get; set; }
        [Required]
        [DataType(DataType.Password)]
        [Display(Name = "Confirm password")]
        [Compare("Password", ErrorMessage = "The password and confirmation password do not match.")]
        public string ConfirmPassword { get; set; }
        [Required]
        public string ResetToken { get; set; }
    }

    public class UserSearchRequest
    {
        public string SearchValue { get; set; } 
        [Required]
        public int PageNo { get; set; }
        [Required]
        public int PageSize { get; set; }
        public string SortColumn { get; set; } 
        public string SortOrder { get; set; } 
    }


}
