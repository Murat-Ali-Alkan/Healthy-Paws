using Microsoft.AspNetCore.Mvc.ModelBinding.Validation;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace DBMS_Project.Models;

[ValidateNever]
public partial class Veterinarian
{
    public int Id { get; set; }

    public string FirstName { get; set; } = null!;

	public string LastName { get; set; } = null!;

	public string PhoneNo { get; set; } = null!;

	public string EmailAddress { get; set; } = null!;

	public string Address { get; set; } = null!;

    public DateOnly RegistrationDate { get; set; }

    [NotMapped]
    public bool IsChecked { get; set; }

    public virtual ICollection<VetCustomer> VetCustomers { get; set; } = new List<VetCustomer>();

    public virtual ICollection<VetSpecialization> VetSpecializations { get; set; } = new List<VetSpecialization>();
}
