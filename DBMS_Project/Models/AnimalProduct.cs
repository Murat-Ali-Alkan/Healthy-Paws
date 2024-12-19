using System;
using System.Collections.Generic;

namespace DBMS_Project.Models;

public  class AnimalProduct
{
    public int Id { get; set; }

    public int AnimalTypeId { get; set; }

    public int ProductId { get; set; }

    public AnimalType AnimalType { get; set; } = null!;

    public Product Product { get; set; } = null!;
}
