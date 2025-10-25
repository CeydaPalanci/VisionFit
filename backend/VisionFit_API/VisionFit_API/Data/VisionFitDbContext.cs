using System.Collections.Generic;
using VisionFit_API.Models;
using Microsoft.EntityFrameworkCore;

namespace VisionFit_API.Data
{

    namespace VisionFit_API.Data
    {
        public class VisionFitDbContext : DbContext
        {
            public VisionFitDbContext(DbContextOptions<VisionFitDbContext> options) : base(options) { }

            public DbSet<Glasses> Glasses { get; set; }

            public DbSet<User> Users { get; set; } 
        }
    }

}
