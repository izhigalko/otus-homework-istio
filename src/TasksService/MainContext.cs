using Microsoft.EntityFrameworkCore;

namespace TasksService
{
    public class MainContext : DbContext
    {
        public MainContext(DbContextOptions opts) : base(opts)
        {
            
        }

        public DbSet<TaskModel> Tasks { get; set; }
    }    
}