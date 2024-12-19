using System;
using System.Collections.Generic;

namespace DBMS_Project.Models;

public class SpecializationType
{
    public int Id { get; set; }

    public string Description { get; set; } = null!;

    public string Abbreviation { get; set; } = null!;

    public virtual ICollection<Specialization> Specializations { get; set; } = new List<Specialization>();
}
