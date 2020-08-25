using Microsoft.EntityFrameworkCore;

namespace WorkingHoursService
{
    public class MainContext : DbContext
    {
        public MainContext(DbContextOptions opts) : base(opts)
        {
            
        }

        public DbSet<WorkingHoursRecord> WorkingHoursRecords { get; set; }
    }    
}