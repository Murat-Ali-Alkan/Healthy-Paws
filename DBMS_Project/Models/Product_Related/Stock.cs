using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;

namespace DBMS_Project.Models;

public class Stock
{
    public int Id { get; set; }

    public int ProductId { get; set; }

    public DateOnly ExpirationDate { get; set; }

    
    public int Quantity { get; set; }

    public Product Product { get; set; } = null!;
}
