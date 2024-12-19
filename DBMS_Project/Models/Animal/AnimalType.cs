using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations.Schema;
using DBMS_Project.Models;

namespace DBMS_Project.Models;

public class AnimalType
{
	public int Id { get; set; }

	public string SpeciesName { get; set; } = null!;

	[NotMapped]
    public bool IsChecked { get; set; }

    public ICollection<AnimalProduct> AnimalProducts { get; set; } = new List<AnimalProduct>();
}
