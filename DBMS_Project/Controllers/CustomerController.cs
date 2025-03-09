using DBMS_Project.Models;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Web.Data;

namespace DBMS_Project.Controllers
{
    [Authorize(Roles = "Admin")]
    public class CustomerController : Controller
	{
		public readonly HealthyPawsContext _context;

		public CustomerController(HealthyPawsContext context)
		{
			_context = context;
		}

		public IActionResult List()
		{

			List<Customer> customers = _context.Customers.Include(c => c.Village).ToList();
			return View(customers);

		}


		[Route("{controller}/{action}/{customerId}")]
		public IActionResult ListVeterinarians(int customerId)
		{
			var veterinarians = _context.Customers.Where(c => c.Id == customerId)
				   .Include(v => v.VetCustomers)
				   .ThenInclude(vc => vc.Veterinarian)
				   .SelectMany(v => v.VetCustomers)
				   .Select(vc => vc.Veterinarian)
				   .ToList();


			ViewBag.CustomerName = _context.Customers.Where(c => c.Id == customerId).Select(c => c.FirstName).FirstOrDefault();

			return View("Views/Veterinarian/List.cshtml", veterinarians);

		}


		[HttpGet]
		public IActionResult Add()
		{

			CustomerViewModel customerViewModel = new CustomerViewModel()
			{
				Veterinarians = _context.Veterinarians.ToList()
			};

			ViewBag.Villages = _context.Villages.ToList();

			return View(customerViewModel);
		}


		[HttpPost]
		public IActionResult Add(CustomerViewModel customerModel)
		{

			if (ModelState.IsValid)
			{

				Customer customer = new Customer()
				{
					FirstName = customerModel.FirstName,
					LastName = customerModel.LastName,
					EmailAddress = customerModel.EmailAddress,
					Address = customerModel.Address,
					PhoneNo = customerModel.PhoneNo,
					VillageId = customerModel.VillageId

				};


				_context.Customers.Add(customer);
				_context.SaveChanges();

				var customerId = customer.Id;


				foreach (Veterinarian veterinarian in customerModel.Veterinarians)
				{

					if (veterinarian.IsChecked == true)
					{
						VetCustomer customerViewModel = new VetCustomer()
						{
							VeterinarianId = veterinarian.Id,
							CustomerId = customerId
						};
						_context.VetCustomers.Add(customerViewModel);
					}
					
				}


				_context.SaveChanges();

				ViewBag.Name = "Customer";
				return View("Success");
			}


			customerModel.Veterinarians = _context.Veterinarians.ToList();
			ViewBag.Villages = _context.Villages.ToList();

			return View(customerModel);
		}

	}
}
