using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Web.Data;

namespace DBMS_Project.Controllers
{
    [Authorize(Roles = "Admin")]

    public class StockController : Controller
	{
		private readonly HealthyPawsContext _context;

		public StockController(HealthyPawsContext context)
		{
			_context = context;
		}

		public IActionResult List()
		{
			var stocks = _context.Stocks.Include(s => s.Product).OrderBy(s => s.ExpirationDate).ToList();
			return View(stocks);
		}

		[Route("{controller}/{action}/{stockId?}")]
		public IActionResult Delete(int stockId)
		{
			var stockDelete = _context.Stocks.Where(s => s.Id == stockId).FirstOrDefault();
			_context.Stocks.Remove(stockDelete);
			_context.SaveChanges();
			return RedirectToAction("List");
		}


	}
}
