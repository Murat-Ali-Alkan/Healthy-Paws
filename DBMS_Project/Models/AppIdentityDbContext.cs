using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Identity.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Diagnostics;
using System.Reflection.Emit;

namespace DBMS_Project.Data
{
    public class AppIdentityDbContext : IdentityDbContext<IdentityUser>
    {

        public AppIdentityDbContext(DbContextOptions<AppIdentityDbContext> options) : base(options)
        {


        }

        // I Couldn't update the database because there were some bugs in the OnModelCreating
        // So I Bypassed the warnings
        protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
        {
            optionsBuilder
                .ConfigureWarnings(warnings => warnings.Ignore(RelationalEventId.PendingModelChangesWarning));
            base.OnConfiguring(optionsBuilder);
        }

        protected override void OnModelCreating(ModelBuilder builder)
        {
            base.OnModelCreating(builder);


            builder.Entity<IdentityRole>().HasData(
                new IdentityRole { Id = "1", Name = "Admin", NormalizedName = "ADMIN" },
                new IdentityRole { Id = "2", Name = "Customer", NormalizedName = "CUSTOMER" }
                );

            var adminUser = new IdentityUser
            {
                Id = "a1",
                UserName = "Admin",
                NormalizedUserName = "ADMIN",
                Email = "admin@healthy.com",
                NormalizedEmail = "ADMIN@HEALTHY.COM",
                EmailConfirmed = true,
                PhoneNumber = "05515232233",
                PhoneNumberConfirmed = true
            };

           

            var passwordHasher = new PasswordHasher<IdentityUser>();
            adminUser.PasswordHash = passwordHasher.HashPassword(adminUser, "Healthy123$");

            var customerUser = new IdentityUser
            {
                Id = "c1",
                UserName = "Customer",
                NormalizedUserName = "CUSTOMER",
                Email = "customer@Healthy.com",
                NormalizedEmail = "CUSTOMER@HEALTHY.COM",
                EmailConfirmed = true,
                PhoneNumber = "05333434433",
                PhoneNumberConfirmed = true
            };

            customerUser.PasswordHash = passwordHasher.HashPassword(customerUser, "Customer123$");



            builder.Entity<IdentityUser>().HasData(adminUser,customerUser);

            builder.Entity<IdentityUserRole<string>>().HasData(
                new IdentityUserRole<string>() { UserId = "a1", RoleId = "1" },
                new IdentityUserRole<string>() { UserId = "c1", RoleId = "2" }
                );

        }
    }
}
