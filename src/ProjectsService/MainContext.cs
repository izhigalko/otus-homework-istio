using Microsoft.EntityFrameworkCore;

namespace ProjectsService
{
    public class MainContext : DbContext
    {
        public MainContext(DbContextOptions opts) : base(opts)
        {
            
        }

        public DbSet<ProjectModel> Projects { get; set; }
        public DbSet<TaskModel> Tasks { get; set; }
    }
    
}