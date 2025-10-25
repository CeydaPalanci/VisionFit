using System.ComponentModel.DataAnnotations.Schema;

namespace VisionFit_API.Models
{
    public class Glasses
    {
            public int Id { get; set; }
            public string? Name { get; set; }
            public string? Brand { get; set; }
            public string? FrameShape { get; set; }

            [Column(TypeName = "decimal(18,2)")]
            public decimal  Price { get; set; }
            public string? ImageUrl { get; set; }
            public string? PurchaseLink { get; set; }
            public string? BrandImageUrl { get; set; }
            public string? FaceShape { get; set; }


    }
}
