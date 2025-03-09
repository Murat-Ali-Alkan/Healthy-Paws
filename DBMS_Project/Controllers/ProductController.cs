using DBMS_Project.Models;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Npgsql;
using System.Data.Common;
using Web.Data;

namespace DBMS_Project.Controllers
{
    public class ProductController : Controller
    {

        private readonly HealthyPawsContext _context;

        public ProductController(HealthyPawsContext context)
        {
            _context = context;
        }


        public IActionResult List()
        {
            var products = _context.Products.OrderByDescending(p => p.ProductType).ToList();
           
            return View(products);
        }

        [Authorize(Roles ="Admin")]
        [HttpGet]
        public IActionResult Add(char productType)
        {
           
            ProductViewModel model = new ProductViewModel();

            // Populate Animal Types for selection
            model.AnimalTypes = _context.AnimalTypes.ToList();

            

            // If user selects Add Medicine
            if (productType == 'M')
            {
                ViewBag.Medicines = _context.Medicines.Include(m => m.MedicineCategory).ToList();
                ViewBag.ProductType = 'M';
                ViewBag.MedicineCategories = _context.MedicineCategories.ToList();
                ViewBag.Action = "Add Medicine";
            }
			// If user selects Add Food
			else
			{
                ViewBag.Foods = _context.Foods.ToList();
                ViewBag.ProductType = 'F';
                ViewBag.Action = "Add Food";
            }
            return View(model);
        }

		[Authorize(Roles = "Admin")]
		[HttpPost]
        public IActionResult Add(ProductViewModel productViewModel)
        {

			if (productViewModel.ProductType == 'M') // Medicine
			{
				ModelState.Remove(nameof(productViewModel.Calorie));
				ModelState.Remove(nameof(productViewModel.IsDry));
				ModelState.Remove(nameof(productViewModel.Weight));
			}
			else if (productViewModel.ProductType == 'F') // Food
			{
				ModelState.Remove(nameof(productViewModel.MedicineCategoryId));
				ModelState.Remove(nameof(productViewModel.Dosage));
				ModelState.Remove(nameof(productViewModel.UsageInstruction));
			}

			// If Model state is valid
			if (ModelState.IsValid)
            {
                Product product = new Product()
                {
                    ProductType = productViewModel.ProductType,
                    Name = productViewModel.Name,
                    Price = productViewModel.Price
                };

                _context.Products.Add(product);
                _context.SaveChanges();
                int productId = product.ProductId;
                if (productViewModel.ProductType == 'M')
                {
                    Medicine medicine = new Medicine()
                    {
                        ProductId = productId,
                        MedicineCategoryId = productViewModel.MedicineCategoryId,
                        Dosage = productViewModel.Dosage,
                        UsageInstruction = productViewModel.UsageInstruction,
                    };
                    _context.Medicines.Add(medicine);
                }
                else if (productViewModel.ProductType == 'F')
                {
                    Food food = new Food()
                    {
						ProductId = productId,
						Calorie = productViewModel.Calorie,
                        IsDry = productViewModel.IsDry,
                        Weight = productViewModel.Weight,
                    };
                    _context.Foods.Add(food);
                }


                foreach(AnimalType animalType in productViewModel.AnimalTypes)
                {
                    if(animalType.IsChecked == true)
                    {
                        AnimalProduct animalProduct = new AnimalProduct()
                        {
                            AnimalTypeId = animalType.Id,
                            ProductId = productId
						};

                        _context.AnimalProducts.Add(animalProduct);
                    }
                }

                _context.SaveChanges(); 
                ViewBag.Name = "Product";
				return View("Success");
			}

            if(productViewModel.ProductType == 'M')
            {
				ViewBag.ProductType = 'M';
				ViewBag.MedicineCategories = _context.MedicineCategories.ToList();
				ViewBag.Action = "Add Medicine";
			}
			else
			{
				ViewBag.Foods = _context.Foods.ToList();
				ViewBag.ProductType = 'F';
				ViewBag.Action = "Add Food";
			}

			return View(productViewModel);

        }

		[Authorize(Roles = "Admin")]
		[HttpGet("{controller}/{action}/{productId}")]
        public IActionResult Update(int productId)
        {
            var product = _context.Products.Where(p => p.ProductId == productId).FirstOrDefault();

            if(product.ProductType == 'M')
            {
                product.Medicine = _context.Medicines.Where(m => m.ProductId == productId).Include(m => m.MedicineCategory).FirstOrDefault();    
            }

            else
            {
                product.Food = _context.Foods.Where(f => f.ProductId == productId).FirstOrDefault();
            }
            
            return View(product);
        }

		[Authorize(Roles = "Admin")]
		[HttpPost]
        public IActionResult Update(Product product)
        {
            var productChange = _context.Products.Where(p => p.ProductId == product.ProductId).FirstOrDefault();

            productChange.Price = product.Price;

            _context.Products.Update(productChange);
            _context.SaveChanges();

            return RedirectToAction("List");
        }

    }
}
