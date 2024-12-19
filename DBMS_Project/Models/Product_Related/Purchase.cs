using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using DBMS_Project.Models;
using Microsoft.AspNetCore.Mvc.ModelBinding.Validation;

namespace DBMS_Project.Models;

public class Purchase
{
    public int Id { get; set; }

    public int CompanyId { get; set; }

    public int ProductId { get; set; }

    public DateOnly PurchaseDate { get; set; }

    public DateOnly? ArrivalDate { get; set; }

    [Required(ErrorMessage = "Quantity is required.")]
    [Range(1, 100, ErrorMessage = "Quantity must be between 1 and 100.")]
    public int Quantity { get; set; }

    public decimal? Price { get; set; }

    [NotMapped]
    [Required(ErrorMessage = "Expiration Date is required")]
    [DataType(DataType.Date)]
    public DateTime ExpirationDate { get; set; }
    [ValidateNever]
    public Company Company { get; set; } = null!;
    [ValidateNever]
    public Product Product { get; set; } = null!;
}
