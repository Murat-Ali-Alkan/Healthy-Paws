using System;
using System.Collections.Generic;
using DBMS_Project.Models;
using Microsoft.AspNetCore.Mvc.ModelBinding.Validation;

namespace DBMS_Project.Models;

[ValidateNever]
public class Company
{
    public int Id { get; set; }

    public string Name { get; set; } = null!;

    public string PhoneNo { get; set; } = null!;

    public string EmailAddress { get; set; } = null!;

    public string Address { get; set; } = null!;

    public string TaxNumber { get; set; } = null!;

    public ICollection<CompanyProduct> CompanyProducts { get; set; } = new List<CompanyProduct>();

    public ICollection<Purchase> Purchases { get; set; } = new List<Purchase>();
}
