
using DBMS_Project.Models.Validations;
using System.ComponentModel.DataAnnotations;

namespace DBMS_Project.Models
{
    public class ProductViewModel
    {
        public int ProductId { get; set; }

        [Required(ErrorMessage ="Product Name is required")]
        public string? Name { get; set; }

        [Required(ErrorMessage = "Product Price is required")]
        public decimal? Price { get; set; }

        [Required(ErrorMessage = "Product Type is required")]
        public char ProductType { get; set; }

		[Required(ErrorMessage = "Usage Instruction is required")]
		public string? UsageInstruction { get; set; } = null!;

		[Required(ErrorMessage = "Medicine Category is required")]
		public int? MedicineCategoryId { get; set; }

		[Required(ErrorMessage = "Dosage is required")]
		public int? Dosage { get; set; }

		[Required(ErrorMessage = "Calorie of product is required")]
		public int? Calorie { get; set; }

		[Required(ErrorMessage = "Weight of product is required")]
		public decimal? Weight { get; set; }

		[Required(ErrorMessage = "Texture is required")]
		public bool? IsDry { get; set; }

		// Custom Validation Attribute To check a Product has at least 1 Animal Type
		[ValidateAnimalTypes]
        public List<AnimalType> AnimalTypes { get; set; }

    }
}
