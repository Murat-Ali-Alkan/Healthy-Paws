using DBMS_Project.Models.Validations;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.ModelBinding.Validation;
using System.ComponentModel.DataAnnotations;

namespace DBMS_Project.Models
{
	public class VeterinarianViewModel
	{
		public int Id { get; set; }

		[Required(ErrorMessage = "Veterinarian's First Name is required")]
		public string FirstName { get; set; } = null!;

		[Required(ErrorMessage = "Veterinarian's Last Name is required")]
		public string LastName { get; set; } = null!;

		[Required(ErrorMessage = "Veterinarian's Phone Number is required")]
		public string PhoneNo { get; set; } = null!;

		[Required(ErrorMessage = "Veterinarian's Email Address is required")]
		public string EmailAddress { get; set; } = null!;

		[Required(ErrorMessage = "Veterinarian's Address is required")]
		public string Address { get; set; } = null!;

		public DateOnly RegistrationDate { get; set; }

		// Custom Validation Attribute To check a veterinarian has at least 1 specialization
		[ValidateSpecializations]
        public List<Specialization> Specializations { get; set; }
    }
}
