using DBMS_Project.Models;
using Microsoft.AspNetCore.Mvc;
using Npgsql;
using System.Diagnostics;
using Web.Data;

namespace DBMS_Project.Controllers
{
    public class HomeController : Controller
    {
        private readonly HealthyPawsContext _connection;

        public HomeController(HealthyPawsContext connection)
        {
            _connection = connection;
        }

        public IActionResult Index()
        {
            return View();
        }


    }
}
