using System;
using System.Collections.Generic;

namespace DBMS_Project.Models;

public class Sale
{
    public int Id { get; set; }

    public int ProductId { get; set; }

    public int Quantity { get; set; }

    public DateOnly SaleDate { get; set; }

    public decimal? Price { get; set; }

    public Product Product { get; set; } = null!;
}
