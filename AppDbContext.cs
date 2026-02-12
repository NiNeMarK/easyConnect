using Microsoft.EntityFrameworkCore;

public class UserEntity
{
    public int Id { get; set; }
    public string FirstName { get; set; } = "";
    public string LastName { get; set; } = "";
    public string Address { get; set; } = "";
    public string BirthDate { get; set; } = "";
    public int Age { get; set; }
}

public class AppDbContext : DbContext
{
    public AppDbContext(DbContextOptions<AppDbContext> options) : base(options) { }
    public DbSet<UserEntity> Users { get; set; }
}