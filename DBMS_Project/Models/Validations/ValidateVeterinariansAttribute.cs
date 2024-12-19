using System.ComponentModel.DataAnnotations;

namespace DBMS_Project.Models.Validations
{
	public class ValidateVeterinariansAttribute : ValidationAttribute
	{
		protected override ValidationResult? IsValid(object? value, ValidationContext validationContext)
		{
			var veterinarians = value as List<Veterinarian>;

			int checkIfTrue = 0;

			foreach (Veterinarian veterinarian in veterinarians)
			{
				if(veterinarian.IsChecked == true)
				{
					checkIfTrue++;
				}
			}


			if (checkIfTrue == 0)
			{
				return new ValidationResult("There Must be at least one Veterinarian for a Customer!");
			}

			return ValidationResult.Success;

		}
	}
}
