using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using DBMS_Project.Models;
using Microsoft.AspNetCore.Mvc.ModelBinding.Validation;

namespace DBMS_Project.Models;

public class Product
{
    public int ProductId { get; set; }

	public string Name { get; set; } = null!;

    public char ProductType { get; set; }

	public decimal? Price { get; set; }

    public ICollection<AnimalProduct> AnimalProducts { get; set; } = new List<AnimalProduct>();

    public ICollection<CompanyProduct> CompanyProducts { get; set; } = new List<CompanyProduct>();

    public Food? Food { get; set; }

    public Medicine? Medicine { get; set; }

    [NotMapped]
    public bool IsChecked { get; set; }

    public ICollection<Sale> Sales { get; set; } = new List<Sale>();

    public ICollection<Stock> Stocks { get; set; } = new List<Stock>();
}
