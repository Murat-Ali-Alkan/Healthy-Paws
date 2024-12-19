using DBMS_Project.Data;
using DBMS_Project.Models;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace DBMS_Project.Controllers
{
    [Authorize(Roles = "Admin")]
    public class CompanyController : Controller
	{
		private readonly HealthyPawsContext _context;
        public CompanyController(HealthyPawsContext context)
        {
            _context = context;
        }
        public IActionResult List()
		{
			var companies = _context.Companies.ToList();
			return View(companies);
		}

		[Route("{controller}/{action}/{companyId?}")]
		public IActionResult ListProducts(int companyId)
		{
			var products = _context.Companies.Where(c => c.Id == companyId)
							.Include(c => c.CompanyProducts)
							.ThenInclude(cp => cp.Product)
							.SelectMany(c => c.CompanyProducts)
							.Select(cp => cp.Product).ToList();

			ViewBag.CompanyName = _context.Companies.Where(c => c.Id == companyId).Select(c => c.Name).FirstOrDefault();
			ViewBag.CompanyId = companyId;

			return View("Views/Product/List.cshtml", products);

		}


		[HttpGet]
		public IActionResult Add()
		{
			CompanyViewModel companyModel = new CompanyViewModel()
			{
				CompanyProducts = _context.Products.ToList()
			};

			return View(companyModel);
		}


		[HttpPost]

		public IActionResult Add(CompanyViewModel companyModel)
		{

			if(ModelState.IsValid)
			{
				Company company = new Company()
				{
					Address = companyModel.Address,
					EmailAddress = companyModel.EmailAddress,
					Name = companyModel.Name,
					PhoneNo = companyModel.PhoneNo,
					TaxNumber = companyModel.TaxNumber,
				};

				_context.Companies.Add(company);
				_context.SaveChanges();
				int company_id = company.Id;


				foreach (Product product in companyModel.CompanyProducts)
				{
					if(product.IsChecked == true)
					{
						CompanyProduct companyProduct = new CompanyProduct()
						{
							CompanyId = company_id,
							ProductId = product.ProductId
						};

						_context.CompanyProducts.Add(companyProduct);
					}
				}
				
				_context.SaveChanges();

				ViewBag.Name = "Company";
				return View("Success");
			}

			companyModel.CompanyProducts = _context.Products.ToList();

			return View(companyModel);

		}
	}
}
