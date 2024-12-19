using DBMS_Project.Data;
using Microsoft.AspNetCore.Identity;
using Microsoft.EntityFrameworkCore;
using Microsoft.AspNetCore.Identity.EntityFrameworkCore;
using Microsoft.Extensions.FileSystemGlobbing.Internal;

var builder = WebApplication.CreateBuilder(args);

// Add services to the container.
builder.Services.AddControllersWithViews();

builder.Services.AddDbContext<HealthyPawsContext>(options =>
    options.UseNpgsql(builder.Configuration.GetConnectionString("HealtyPawsWebConnection"))
    );


builder.Services.AddDbContext<AppIdentityDbContext>(opts =>
opts.UseSqlite(
builder.Configuration["ConnectionStrings:IdentityDBConnection"]));
builder.Services.AddIdentity<IdentityUser, IdentityRole>()
.AddRoles<IdentityRole>()
.AddEntityFrameworkStores<AppIdentityDbContext>();

var app = builder.Build();


app.UseHttpsRedirection();
app.UseStaticFiles();

app.UseRouting();

app.UseAuthorization();
app.MapControllerRoute(
name: "product",
    pattern: "{controller=Home}/{action=Index}/{productType?}"
    );

app.MapControllerRoute(
    name: "default",
    pattern: "{controller=Home}/{action=Index}/{id?}");

app.Run();
