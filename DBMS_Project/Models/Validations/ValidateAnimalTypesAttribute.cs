using System.ComponentModel.DataAnnotations;

namespace DBMS_Project.Models.Validations
{
	public class ValidateAnimalTypesAttribute : ValidationAttribute
	{
		protected override ValidationResult? IsValid(object? value, ValidationContext validationContext)
		{
			var animalTypes = value as List<AnimalType>;
			int checkIfTrue = 0;

			// Check if there is any checkbox is selected
			foreach (AnimalType animalType in animalTypes)
			{
				if(animalType.IsChecked== true)
				{
					checkIfTrue++;
				}
			}

			if(checkIfTrue == 0)
			{
				return new ValidationResult("There MUST be at least an animal type for a product.");
			}

			return ValidationResult.Success;
		}
	}
}
