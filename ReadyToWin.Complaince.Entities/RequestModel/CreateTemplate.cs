using ReadyToWin.Complaince.Entities.Constant;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ReadyToWin.Complaince.Entities.RequestModels
{
    public class NewTemplateModel : IValidatableObject
    {
        public NewTemplateModel()
        {
            ColumnsList = new List<TemplateDetailModel>();
        }
        [Required]
        public long ModuleId { get; set; }
        [Required]
        public string ReportName { get; set; }
        [Required]
        public string CreatedBy { get; set; }

        public List<TemplateDetailModel> ColumnsList{ get; set; }

        public IEnumerable<ValidationResult> Validate(ValidationContext validationContext)
        {
            List<ValidationResult> errors = new List<ValidationResult>();
            if (ModuleId.Equals(0))
                errors.Add(new ValidationResult(Messages.VE_MODULEID));

            if (ColumnsList.Count <= 0)
                errors.Add(new ValidationResult(Messages.VE_COLUMNLIST));

            return errors;
        }
    }

    public class TemplateDetailModel
    {
        public string ColumnName { get; set; }
        public string DataType { get; set; }
        public string DisplayName { get; set; }
        public bool OrderBy { get; set; }
    }
}
