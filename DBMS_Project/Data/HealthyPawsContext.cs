using System;
using System.Collections.Generic;
using DBMS_Project.Models;
using Microsoft.EntityFrameworkCore;

namespace Web.Data;

public partial class HealthyPawsContext : DbContext
{
    public HealthyPawsContext()
    {
    }

    public HealthyPawsContext(DbContextOptions<HealthyPawsContext> options)
        : base(options)
    {
    }

    public virtual DbSet<AnimalProduct> AnimalProducts { get; set; }

    public virtual DbSet<AnimalType> AnimalTypes { get; set; }

    public virtual DbSet<City> Cities { get; set; }

    public virtual DbSet<Company> Companies { get; set; }

    public virtual DbSet<CompanyProduct> CompanyProducts { get; set; }

    public virtual DbSet<Customer> Customers { get; set; }

    public virtual DbSet<District> Districts { get; set; }

    public virtual DbSet<Food> Foods { get; set; }

    public virtual DbSet<Medicine> Medicines { get; set; }

    public virtual DbSet<MedicineCategory> MedicineCategories { get; set; }

    public virtual DbSet<Product> Products { get; set; }

    public virtual DbSet<Purchase> Purchases { get; set; }

    public virtual DbSet<Sale> Sales { get; set; }

    public virtual DbSet<Specialization> Specializations { get; set; }

    public virtual DbSet<SpecializationType> SpecializationTypes { get; set; }

    public virtual DbSet<Stock> Stocks { get; set; }

    public virtual DbSet<VetCustomer> VetCustomers { get; set; }

    public virtual DbSet<VetSpecialization> VetSpecializations { get; set; }

    public virtual DbSet<Veterinarian> Veterinarians { get; set; }

    public virtual DbSet<Village> Villages { get; set; }

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        modelBuilder.Entity<AnimalProduct>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("animal_product_pk");

            entity.ToTable("animal_product");

            entity.Property(e => e.Id).HasColumnName("id");
            entity.Property(e => e.AnimalTypeId).HasColumnName("animal_type_id");
            entity.Property(e => e.ProductId).HasColumnName("product_id");

            entity.HasOne(d => d.AnimalType).WithMany(p => p.AnimalProducts)
                .HasForeignKey(d => d.AnimalTypeId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("animal_product_animal_type_fk");

            entity.HasOne(d => d.Product).WithMany(p => p.AnimalProducts)
                .HasForeignKey(d => d.ProductId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("animal_product_product_fk");
        });

        modelBuilder.Entity<AnimalType>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("animal_type_pk");

            entity.ToTable("animal_types");

            entity.HasIndex(e => e.SpeciesName, "animal_type_species_name_key").IsUnique();

            entity.Property(e => e.Id)
                .HasDefaultValueSql("nextval('animal_type_id_seq'::regclass)")
                .HasColumnName("id");
            entity.Property(e => e.SpeciesName)
                .HasMaxLength(50)
                .HasColumnName("species_name");
        });

        modelBuilder.Entity<City>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("city_pk");

            entity.ToTable("cities");

            entity.HasIndex(e => e.Name, "cities_name_key").IsUnique();

            entity.Property(e => e.Id).HasColumnName("id");
            entity.Property(e => e.Name)
                .HasMaxLength(50)
                .HasColumnName("name");
        });

        modelBuilder.Entity<Company>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("company_pk");

            entity.ToTable("companies");

            entity.HasIndex(e => e.Address, "companies_address_key").IsUnique();

            entity.HasIndex(e => e.EmailAddress, "companies_email_address_key").IsUnique();

            entity.HasIndex(e => e.Name, "companies_name_key").IsUnique();

            entity.HasIndex(e => e.PhoneNo, "companies_phone_no_key").IsUnique();

            entity.HasIndex(e => e.TaxNumber, "companies_tax_number_key").IsUnique();

            entity.Property(e => e.Id).HasColumnName("id");
            entity.Property(e => e.Address).HasColumnName("address");
            entity.Property(e => e.EmailAddress)
                .HasMaxLength(70)
                .HasColumnName("email_address");
            entity.Property(e => e.Name)
                .HasMaxLength(50)
                .HasColumnName("name");
            entity.Property(e => e.PhoneNo)
                .HasMaxLength(14)
                .HasColumnName("phone_no");
            entity.Property(e => e.TaxNumber)
                .HasMaxLength(11)
                .HasColumnName("tax_number");
        });

        modelBuilder.Entity<CompanyProduct>(entity =>
        {
            entity.HasKey(e => e.CompanyProductId).HasName("company_product_pkey");

            entity.ToTable("company_product");

            entity.Property(e => e.CompanyProductId).HasColumnName("company_product_id");
            entity.Property(e => e.CompanyId).HasColumnName("company_id");
            entity.Property(e => e.ProductId).HasColumnName("product_id");

            entity.HasOne(d => d.Company).WithMany(p => p.CompanyProducts)
                .HasForeignKey(d => d.CompanyId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("company_product_company_fk");

            entity.HasOne(d => d.Product).WithMany(p => p.CompanyProducts)
                .HasForeignKey(d => d.ProductId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("company_product_product_fk");
        });

        modelBuilder.Entity<Customer>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("customer_pk");

            entity.ToTable("customers");

            entity.HasIndex(e => e.Address, "customers_address_key").IsUnique();

            entity.HasIndex(e => e.EmailAddress, "customers_email_address_key").IsUnique();

            entity.HasIndex(e => e.PhoneNo, "customers_phone_no_key").IsUnique();

            entity.Property(e => e.Id).HasColumnName("id");
            entity.Property(e => e.Address).HasColumnName("address");
            entity.Property(e => e.EmailAddress)
                .HasMaxLength(70)
                .HasColumnName("email_address");
            entity.Property(e => e.FirstName)
                .HasMaxLength(50)
                .HasColumnName("first_name");
            entity.Property(e => e.LastName)
                .HasMaxLength(50)
                .HasColumnName("last_name");
            entity.Property(e => e.PhoneNo)
                .HasMaxLength(14)
                .HasColumnName("phone_no");
            entity.Property(e => e.VillageId).HasColumnName("village_id");

            entity.HasOne(d => d.Village).WithMany(p => p.Customers)
                .HasForeignKey(d => d.VillageId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("customer_village_fk");
        });

        modelBuilder.Entity<District>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("district_pk");

            entity.ToTable("districts");

            entity.HasIndex(e => e.Name, "districts_name_key").IsUnique();

            entity.Property(e => e.Id).HasColumnName("id");
            entity.Property(e => e.CityId).HasColumnName("city_id");
            entity.Property(e => e.Name)
                .HasMaxLength(50)
                .HasColumnName("name");

            entity.HasOne(d => d.City).WithMany(p => p.Districts)
                .HasForeignKey(d => d.CityId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("district_city_fk");
        });

        modelBuilder.Entity<Food>(entity =>
        {
            entity.HasKey(e => e.ProductId).HasName("food_pkey");

            entity.ToTable("foods");

            entity.Property(e => e.ProductId)
                .ValueGeneratedNever()
                .HasColumnName("product_id");
            entity.Property(e => e.Calorie).HasColumnName("calorie");
            entity.Property(e => e.IsDry).HasColumnName("is_dry");
            entity.Property(e => e.Weight)
                .HasPrecision(8, 3)
                .HasColumnName("weight");

            entity.HasOne(d => d.Product).WithOne(p => p.Food)
                .HasForeignKey<Food>(d => d.ProductId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("food_product_fk");
        });

        modelBuilder.Entity<Medicine>(entity =>
        {
            entity.HasKey(e => e.ProductId).HasName("medicines_pkey");

            entity.ToTable("medicines");

            entity.Property(e => e.ProductId)
                .ValueGeneratedNever()
                .HasColumnName("product_id");
            entity.Property(e => e.Dosage).HasColumnName("dosage");
            entity.Property(e => e.MedicineCategoryId).HasColumnName("medicine_category_id");
            entity.Property(e => e.UsageInstruction)
                .HasMaxLength(50)
                .HasColumnName("usage_instruction");

            entity.HasOne(d => d.MedicineCategory).WithMany(p => p.Medicines)
                .HasForeignKey(d => d.MedicineCategoryId)
                .HasConstraintName("medicine_medicine_category_fk");

            entity.HasOne(d => d.Product).WithOne(p => p.Medicine)
                .HasForeignKey<Medicine>(d => d.ProductId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("medicine_product_fk");
        });

        modelBuilder.Entity<MedicineCategory>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("medicine_category_pk");

            entity.ToTable("medicine_categories");

            entity.HasIndex(e => e.Category, "medicine_categories_category_key").IsUnique();

            entity.Property(e => e.Id).HasColumnName("id");
            entity.Property(e => e.Category)
                .HasMaxLength(40)
                .HasColumnName("category");
        });

        modelBuilder.Entity<Product>(entity =>
        {
            entity.HasKey(e => e.ProductId).HasName("product_pk");

            entity.ToTable("products");

            entity.HasIndex(e => e.Name, "products_name_key").IsUnique();

            entity.Property(e => e.ProductId)
                .HasDefaultValueSql("nextval('products_id_seq'::regclass)")
                .HasColumnName("product_id");
            entity.Property(e => e.Name)
                .HasMaxLength(50)
                .HasColumnName("name");
            entity.Property(e => e.Price)
                .HasPrecision(10, 2)
                .HasColumnName("price");
            entity.Property(e => e.ProductType)
                .HasMaxLength(1)
                .HasColumnName("product_type");
        });

        modelBuilder.Entity<Purchase>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("purchase_pk");

            entity.ToTable("purchases");

            entity.Property(e => e.Id).HasColumnName("id");
            entity.Property(e => e.ArrivalDate).HasColumnName("arrival_date");
            entity.Property(e => e.CompanyId).HasColumnName("company_id");
            entity.Property(e => e.Price)
                .HasPrecision(10, 2)
                .HasColumnName("price");
            entity.Property(e => e.ProductId).HasColumnName("product_id");
            entity.Property(e => e.PurchaseDate).HasColumnName("purchase_date");
            entity.Property(e => e.Quantity).HasColumnName("quantity");

            entity.HasOne(d => d.Company).WithMany(p => p.Purchases)
                .HasForeignKey(d => d.CompanyId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("purchase_company_fk");
        });

        modelBuilder.Entity<Sale>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("sale_pk");

            entity.ToTable("sales");

            entity.Property(e => e.Id).HasColumnName("id");
            entity.Property(e => e.Price)
                .HasPrecision(10, 2)
                .HasColumnName("price");
            entity.Property(e => e.ProductId).HasColumnName("product_id");
            entity.Property(e => e.Quantity).HasColumnName("quantity");
            entity.Property(e => e.SaleDate).HasColumnName("sale_date");

            entity.HasOne(d => d.Product).WithMany(p => p.Sales)
                .HasForeignKey(d => d.ProductId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("sale_product_fk");
        });

        modelBuilder.Entity<Specialization>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("specialization_pk");

            entity.ToTable("specializations");

            entity.HasIndex(e => e.Name, "specialization_name_key").IsUnique();

            entity.Property(e => e.Id)
                .HasDefaultValueSql("nextval('specialization_id_seq'::regclass)")
                .HasColumnName("id");
            entity.Property(e => e.Name)
                .HasMaxLength(50)
                .HasColumnName("name");
            entity.Property(e => e.SpecializationTypeId).HasColumnName("specialization_type_id");

            entity.HasOne(d => d.SpecializationType).WithMany(p => p.Specializations)
                .HasForeignKey(d => d.SpecializationTypeId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("specialization_specialization_type_fk");
        });

        modelBuilder.Entity<SpecializationType>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("specialization_type_pk");

            entity.ToTable("specialization_types");

            entity.HasIndex(e => e.Abbreviation, "specialization_type_abbreviation_key").IsUnique();

            entity.HasIndex(e => e.Description, "specialization_type_description_key").IsUnique();

            entity.Property(e => e.Id)
                .HasDefaultValueSql("nextval('specialization_type_id_seq'::regclass)")
                .HasColumnName("id");
            entity.Property(e => e.Abbreviation)
                .HasMaxLength(50)
                .HasColumnName("abbreviation");
            entity.Property(e => e.Description)
                .HasMaxLength(50)
                .HasColumnName("description");
        });

        modelBuilder.Entity<Stock>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("stock_pk");

            entity.ToTable("stocks");

            entity.Property(e => e.Id).HasColumnName("id");
            entity.Property(e => e.ExpirationDate).HasColumnName("expiration_date");
            entity.Property(e => e.ProductId).HasColumnName("product_id");
            entity.Property(e => e.Quantity).HasColumnName("quantity");

            entity.HasOne(d => d.Product).WithMany(p => p.Stocks)
                .HasForeignKey(d => d.ProductId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("stock_product_fk");
        });

        modelBuilder.Entity<VetCustomer>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("vet_customers_pk");

            entity.ToTable("vet_customers");

            entity.Property(e => e.Id).HasColumnName("id");
            entity.Property(e => e.CustomerId).HasColumnName("customer_id");
            entity.Property(e => e.VeterinarianId).HasColumnName("veterinarian_id");

            entity.HasOne(d => d.Customer).WithMany(p => p.VetCustomers)
                .HasForeignKey(d => d.CustomerId)
                .HasConstraintName("vet_customers_customers_fk");

            entity.HasOne(d => d.Veterinarian).WithMany(p => p.VetCustomers)
                .HasForeignKey(d => d.VeterinarianId)
                .HasConstraintName("vet_customers_veterinarian_fk");
        });

        modelBuilder.Entity<VetSpecialization>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("vet_specialization_pk");

            entity.ToTable("vet_specializations");

            entity.Property(e => e.Id).HasColumnName("id");
            entity.Property(e => e.SpecializationId).HasColumnName("specialization_id");
            entity.Property(e => e.VeterinarianId).HasColumnName("veterinarian_id");

            entity.HasOne(d => d.Specialization).WithMany(p => p.VetSpecializations)
                .HasForeignKey(d => d.SpecializationId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("vet_specialization_specialization_fk");

            entity.HasOne(d => d.Veterinarian).WithMany(p => p.VetSpecializations)
                .HasForeignKey(d => d.VeterinarianId)
                .HasConstraintName("vet_specialization_veterinarian_fk");
        });

        modelBuilder.Entity<Veterinarian>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("veterinarian_pk");

            entity.ToTable("veterinarians");

            entity.HasIndex(e => e.EmailAddress, "veterinarians_email_address_key").IsUnique();

            entity.HasIndex(e => e.PhoneNo, "veterinarians_phone_no_key").IsUnique();

            entity.Property(e => e.Id).HasColumnName("id");
            entity.Property(e => e.Address).HasColumnName("address");
            entity.Property(e => e.EmailAddress)
                .HasMaxLength(70)
                .HasColumnName("email_address");
            entity.Property(e => e.FirstName)
                .HasMaxLength(50)
                .HasColumnName("first_name");
            entity.Property(e => e.LastName)
                .HasMaxLength(50)
                .HasColumnName("last_name");
            entity.Property(e => e.PhoneNo)
                .HasMaxLength(14)
                .HasColumnName("phone_no");
            entity.Property(e => e.RegistrationDate).HasColumnName("registration_date");
        });

        modelBuilder.Entity<Village>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("village_pk");

            entity.ToTable("villages");

            entity.HasIndex(e => new { e.Name, e.PostalCode }, "unique_village_name_postal_code").IsUnique();

            entity.Property(e => e.Id).HasColumnName("id");
            entity.Property(e => e.DistrictId).HasColumnName("district_id");
            entity.Property(e => e.Name)
                .HasMaxLength(50)
                .HasColumnName("name");
            entity.Property(e => e.PostalCode)
                .HasMaxLength(5)
                .IsFixedLength()
                .HasColumnName("postal_code");

            entity.HasOne(d => d.District).WithMany(p => p.Villages)
                .HasForeignKey(d => d.DistrictId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("village_district_fk");
        });

        OnModelCreatingPartial(modelBuilder);
    }

    partial void OnModelCreatingPartial(ModelBuilder modelBuilder);
}
