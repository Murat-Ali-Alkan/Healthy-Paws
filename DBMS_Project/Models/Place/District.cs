using System;
using System.Collections.Generic;

namespace DBMS_Project.Models;

public  class District
{
    public int Id { get; set; }

    public string Name { get; set; } = null!;

    public int CityId { get; set; }

    public City City { get; set; } = null!;

    public ICollection<Village> Villages { get; set; } = new List<Village>();
}
