using System;
using System.Collections.Generic;

namespace DBMS_Project.Models;

public class MedicineCategory
{
    public int Id { get; set; }

    public string Category { get; set; } = null!;

    public ICollection<Medicine> Medicines { get; set; } = new List<Medicine>();
}
