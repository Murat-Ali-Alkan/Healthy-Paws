using DBMS_Project.Data;
using DBMS_Project.Models;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Npgsql;

namespace DBMS_Project.Controllers
{
    [Authorize(Roles = "Admin")]

    public class SaleController : Controller
    {
        private readonly HealthyPawsContext _context;

        public SaleController(HealthyPawsContext context)
        {
            _context = context;
        }

        public IActionResult List()
        {
            var sales = _context.Sales.Include(s => s.Product).OrderByDescending(s => s.SaleDate).ToList();
            return View(sales);
        }

        [HttpGet]
        [Route("{controller}/{action}/{stockId}")]
        public IActionResult Sell(int stockId)
        {
            var product = _context.Stocks.Where(s => s.Id == stockId).Include(s => s.Product).FirstOrDefault();
            return View(product);
        }

        [HttpPost]
        public IActionResult Sell(Stock stock)
        {
            var item = _context.Stocks.Where(s => s.Id == stock.Id).Include(s => s.Product).FirstOrDefault();

            if (stock.Quantity != 0 && stock.Quantity <= item.Quantity)
            {
                item.Quantity -= stock.Quantity;

                Sale sale = new Sale()
                {
                    ProductId = item.ProductId,
                    Price = stock.Quantity * item.Product.Price,
                    SaleDate = DateOnly.FromDateTime(DateTime.Now),
                    Quantity = stock.Quantity

                };

                _context.Sales.Add(sale);
                _context.Stocks.Update(item);
                _context.SaveChanges();
                return RedirectToAction("List");
            }

            ViewBag.NotEnoughStock = "We Don't have enough stock";
            return View(item);
        }
    }
}
