using DBMS_Project.Models;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Web.Data;

namespace DBMS_Project.Controllers
{
    [Authorize(Roles = "Admin")]

    public class PurchaseController : Controller
    {

        private readonly HealthyPawsContext _context;
        public PurchaseController(HealthyPawsContext context)
        {
            _context = context;
        }
        public IActionResult List()
        {
            var purchases = _context.Purchases.Include(p => p.Company).Include(p => p.Product).OrderByDescending(p => p.PurchaseDate).ToList();
            return View(purchases);
        }


        [HttpGet("{controller}/{action}/{companyId}/{productId}")]
        public IActionResult MakePurchase(int companyId, int productId)
        {


            Purchase purchase = new Purchase()
            {
                Company = _context.Companies.Where(c => c.Id == companyId).FirstOrDefault(),
                Product = _context.Products.Where(p => p.ProductId == productId).FirstOrDefault(),
                ExpirationDate = DateTime.UtcNow.AddDays(15)
            };

            return View(purchase);
        }

        [HttpPost("{controller}/{action}/{companyId}/{productId}")]
        public IActionResult MakePurchase(int companyId,int productId,Purchase purchase)
        {

            if (ModelState.IsValid)
            {
                purchase.ProductId = productId;
                purchase.CompanyId = companyId;
                purchase.PurchaseDate = DateOnly.FromDateTime(DateTime.Now);
                purchase.ArrivalDate = DateOnly.FromDateTime(DateTime.Now);
				purchase.Price = purchase.Quantity * purchase.Price;

                _context.Purchases.Add(purchase);

                List<Stock> stocks = _context.Stocks.Where(s => s.ProductId == purchase.ProductId && s.ExpirationDate == DateOnly.FromDateTime(purchase.ExpirationDate)).ToList();

                if(stocks.Any())
                {
                    Stock stock = stocks.FirstOrDefault();

                    stock.Quantity += purchase.Quantity;

                    _context.Stocks.Update(stock);
                }

                else 
                {
                    Stock stock = new Stock()
                    {
                        ProductId = purchase.ProductId,
                        Quantity = purchase.Quantity,
                        ExpirationDate = DateOnly.FromDateTime(purchase.ExpirationDate)
                    };

                    _context.Stocks.Add(stock);
                }

                _context.SaveChanges();


                ViewBag.Name = "Purchase";
                return View("Success");
            }



            return View(purchase);

        }
    }
}
