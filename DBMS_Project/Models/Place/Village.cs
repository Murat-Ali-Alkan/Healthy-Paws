using System;
using System.Collections.Generic;
using DBMS_Project.Models;

namespace DBMS_Project.Models;

public class Village
{
	public int Id { get; set; }

	public string Name { get; set; } = null!;

	public int DistrictId { get; set; }

	public string PostalCode { get; set; } = null!;

	public ICollection<Customer> Customers { get; set; } = new List<Customer>();

	public District District { get; set; } = null!;
}
