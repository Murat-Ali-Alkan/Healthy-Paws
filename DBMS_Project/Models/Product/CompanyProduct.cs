using System;
using System.Collections.Generic;
using DBMS_Project.Models;

namespace DBMS_Project.Models;

public  class CompanyProduct
{
    public int CompanyProductId { get; set; }

    public int CompanyId { get; set; }

    public int ProductId { get; set; }

    public Company Company { get; set; } = null!;

    public Product Product { get; set; } = null!;
}
