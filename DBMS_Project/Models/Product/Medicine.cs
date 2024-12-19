using System;
using System.Collections.Generic;

namespace DBMS_Project.Models;

public class Medicine
{
    public int ProductId { get; set; }

    public string UsageInstruction { get; set; } = null!;

    public int? MedicineCategoryId { get; set; }

    public int? Dosage { get; set; }

    public MedicineCategory? MedicineCategory { get; set; }

    public Product Product { get; set; } = null!;
}
