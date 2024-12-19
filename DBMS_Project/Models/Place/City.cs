using System;
using System.Collections.Generic;

namespace DBMS_Project.Models;

public  class City
{
    public int Id { get; set; }

    public string Name { get; set; } = null!;

    public ICollection<District> Districts { get; set; } = new List<District>();
}
