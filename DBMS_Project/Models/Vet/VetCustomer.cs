using System;
using System.Collections.Generic;

namespace DBMS_Project.Models;

public partial class VetCustomer
{
    public int Id { get; set; }

    public int VeterinarianId { get; set; }

    public int CustomerId { get; set; }

    public virtual Customer Customer { get; set; } = null!;

    public virtual Veterinarian Veterinarian { get; set; } = null!;
}
