using DBMS_Project.Models.Validations;
using System.ComponentModel.DataAnnotations;

namespace DBMS_Project.Models
{
	public class CompanyViewModel
	{
		public int Id { get; set; }


		[Required(ErrorMessage = "Company's Name is required")]
		public string? Name { get; set; } = null!;

		[Required(ErrorMessage = "Company's Phone Number is required")]
		public string? PhoneNo { get; set; } = null!;

		[Required(ErrorMessage = "Company's Email Address is required")]
		public string? EmailAddress { get; set; } = null!;

		[Required(ErrorMessage = "Company's Address is required")]
		public string? Address { get; set; } = null!;

		[Required(ErrorMessage = "Company's Tax number is required")]
		public string? TaxNumber { get; set; }

        // Custom Validation Attribute To check a veterinarian has at least 1 specialization
		public List<Product> CompanyProducts { get; set; }
	}
}
