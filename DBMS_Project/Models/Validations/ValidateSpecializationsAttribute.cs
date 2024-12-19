using System.ComponentModel.DataAnnotations;

namespace DBMS_Project.Models.Validations
{
	public class ValidateSpecializationsAttribute : ValidationAttribute
	{
		protected override ValidationResult? IsValid(object? value, ValidationContext validationContext)
		{
			var specializations = value as List<Specialization>;
			int checkIfTrue = 0;

			// Check if there is any checkbox is selected
			foreach (Specialization specialization in specializations)
			{
				if (specialization.IsChecked == true)
				{
					checkIfTrue++;
				}
			}

			if (checkIfTrue == 0)
			{
				return new ValidationResult("There MUST be at least an specialization for a product.");
			}

			return ValidationResult.Success;
		}
	}
}
