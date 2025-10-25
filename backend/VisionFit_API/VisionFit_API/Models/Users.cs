namespace VisionFit_API.Models
{
    public class User
    {
        public int Id { get; set; }
        public string? Username { get; set; } //email olarak kullanılıyor
        public string? PasswordHash { get; set; }
        public string? Name { get; set; }
        public string? Surname { get; set; }
    }
}
