using DBMS_Project.Models;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.ModelBinding;
using Microsoft.EntityFrameworkCore;
using Newtonsoft.Json;
using Web.Data;

namespace DBMS_Project.Controllers
{
	public class VeterinarianController : Controller
	{
		private readonly HealthyPawsContext _context;
		public VeterinarianController(HealthyPawsContext context)
		{
			_context = context;
		}

		public IActionResult List()
		{
			List<Veterinarian> veterinarians = _context.Veterinarians.OrderBy(v => v.RegistrationDate).ToList();
			return View(veterinarians);
		}

		[Authorize(Roles = "Admin")]
		[Route("{controller}/{action}/{veterinarianId}")]
		public IActionResult ListCustomers(int veterinarianId)
		{
			var customers = _context.Veterinarians.Where(v => v.Id == veterinarianId)
					.Include(v => v.VetCustomers)
					.ThenInclude(vc => vc.Customer)
					.ThenInclude(c => c.Village)
					.SelectMany(v => v.VetCustomers)
					.Select(vc => vc.Customer)
					.ToList();


			ViewBag.VeterinarianName = _context.Veterinarians.Where(v => v.Id == veterinarianId).Select(v => v.FirstName).FirstOrDefault();

			return View("Views/Customer/List.cshtml", customers);

		}


		[Authorize(Roles = "Admin")]
		[HttpGet]
		public IActionResult Add()
		{
			var veterinarianModel = new VeterinarianViewModel()
			{
				Specializations = _context.Specializations.ToList()
			};
			return View(veterinarianModel);
		}


		[Authorize(Roles = "Admin")]
		[HttpPost]
		public IActionResult Add(VeterinarianViewModel veterinarianModel)
		{

			foreach (var key in ModelState.Keys)
			{
				Console.WriteLine($"Key: {key}");
			}

			for (int i =0; i<veterinarianModel.Specializations.Count;i++)
			{
				if (veterinarianModel.Specializations[i].IsChecked == true)
				{
					ModelState.Remove("Specializations");
				}
			}

			

			if (ModelState.IsValid)
			{


				Veterinarian veterinarian = new Veterinarian()
				{
					FirstName = veterinarianModel.FirstName,
					LastName = veterinarianModel.LastName,
					PhoneNo = veterinarianModel.PhoneNo,
					EmailAddress = veterinarianModel.EmailAddress,
					Address = veterinarianModel.Address,
					RegistrationDate = DateOnly.FromDateTime(DateTime.Now)
				};

				_context.Veterinarians.Add(veterinarian);
				_context.SaveChanges();
				int vetId = veterinarian.Id;

				foreach (Specialization specialization in veterinarianModel.Specializations)
				{
					if (specialization.IsChecked == true)
					{
						VetSpecialization vetSpecialization = new VetSpecialization()
						{
							SpecializationId = specialization.Id,
							VeterinarianId = vetId
						};
						_context.VetSpecializations.Add(vetSpecialization);
					}
				}

				_context.SaveChanges();

				ViewBag.Name = "Veterinarian";
				return View("Success");
			}

			veterinarianModel.Specializations = _context.Specializations.ToList();

			return View(veterinarianModel);
		}
	}
}
