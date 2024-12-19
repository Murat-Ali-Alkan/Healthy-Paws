using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations.Schema;
using DBMS_Project.Models;
using Microsoft.AspNetCore.Mvc.ModelBinding.Validation;

namespace DBMS_Project.Models;

[ValidateNever]
public class Specialization
{
    public int Id { get; set; }

    public string Name { get; set; } = null!;

    public int SpecializationTypeId { get; set; }

    [NotMapped]
    public bool IsChecked { get; set; }

    public virtual SpecializationType SpecializationType { get; set; } = null!;

    public virtual ICollection<VetSpecialization> VetSpecializations { get; set; } = new List<VetSpecialization>();
}
