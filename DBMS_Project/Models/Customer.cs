using System;
using System.Collections.Generic;
using DBMS_Project.Models;

namespace DBMS_Project.Models;

public class Customer
{
    public int Id { get; set; }

    public string FirstName { get; set; } = null!;

    public string LastName { get; set; } = null!;

    public string PhoneNo { get; set; } = null!;

    public string? EmailAddress { get; set; }

    public string? Address { get; set; }

    public int? VillageId { get; set; }

    public ICollection<VetCustomer> VetCustomers { get; set; } = new List<VetCustomer>();
           
    public Village Village { get; set; } = null!;
}
