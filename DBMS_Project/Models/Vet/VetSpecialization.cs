using System;
using System.Collections.Generic;

namespace DBMS_Project.Models;

public partial class VetSpecialization
{
    public int Id { get; set; }

    public int VeterinarianId { get; set; }

    public int SpecializationId { get; set; }

    public virtual Specialization Specialization { get; set; } = null!;

    public virtual Veterinarian Veterinarian { get; set; } = null!;
}
