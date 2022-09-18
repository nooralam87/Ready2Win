using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ReadyToWin.Complaince.Entities.RequestModels
{
    public class CreateDepartmentModel
    {
        [Required]
        public string DepartmentName { get; set; }
        [Required]
        public string CreatedBy { get; set; }
    }
    
    public class EditDepartmentModel
    {
        [Required]
        public long DepartmentId { get; set; }
        [Required]
        public string DepartmentName { get; set; }
        [Required]
        public string UpdatedBy { get; set; }
    }
    
    public class DeleteDepartmentModel
    {
        [Required]
        public long DepartmentId { get; set; }
        [Required]
        public string UpdatedBy { get; set; }
    }

    public class CreatePolicyStatusModel
    {
        [Required]
        public string Name { get; set; }
        [Required]
        public string CreatedBy { get; set; }
    }

    public class EditPolicyStatusModel
    {
        [Required]
        public int Id { get; set; }
        [Required]
        public string Name { get; set; }
        [Required]
        public string UpdatedBy { get; set; }
    }

    public class DeletePolicyStatusModel
    {
        [Required]
        public long Id { get; set; }
        [Required]
        public string UpdatedBy { get; set; }
    }

    public class CreateModuleModel
    {
        [Required]
        public string Name { get; set; }
        [Required]
        public string CreatedBy { get; set; }
    }

    public class EditModuleModel
    {
        [Required]
        public int Id { get; set; }
        [Required]
        public string Name { get; set; }
        [Required]
        public string UpdatedBy { get; set; }
    }

    public class DeleteModuleModel
    {
        [Required]
        public long Id { get; set; }
        [Required]
        public string UpdatedBy { get; set; }
    }
}
