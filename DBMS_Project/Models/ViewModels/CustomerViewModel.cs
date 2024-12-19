using DBMS_Project.Models.Validations;
using System.ComponentModel.DataAnnotations;

namespace DBMS_Project.Models
{
    public class CustomerViewModel
    {
		public int Id { get; set; }

		[Required(ErrorMessage = "Customer's First Name is required")]
		public string FirstName { get; set; } = null!;

		[Required(ErrorMessage = "Customer's Last Name is required")]
		public string LastName { get; set; } = null!;

		[Required(ErrorMessage = "Customer's Phone Number is required")]
		public string PhoneNo { get; set; } = null!;

		public string EmailAddress { get; set; } = null!;

		public string Address { get; set; } = null!;

		[Required(ErrorMessage ="Customer's Village information is required")]
		public int? VillageId { get; set; }

		// Custom Validation Attribute To check a veterinarian has at least 1 specialization
		[ValidateVeterinarians]
		public List<Veterinarian> Veterinarians { get; set; }
	}
}
