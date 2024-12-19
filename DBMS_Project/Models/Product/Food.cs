using System;
using System.Collections.Generic;

namespace DBMS_Project.Models;

public  class Food
{
    public int ProductId { get; set; }

    public int? Calorie { get; set; }

    public decimal? Weight { get; set; }

    public bool? IsDry { get; set; }

    public Product Product { get; set; } = null!;
}
