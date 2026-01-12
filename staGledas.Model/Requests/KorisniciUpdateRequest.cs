namespace staGledas.Model.Requests
{
    public class KorisniciUpdateRequest
    {
        public string? Ime { get; set; }
        public string? Prezime { get; set; }
        public string? Email { get; set; }
        public string? Telefon { get; set; }
        public byte[]? Slika { get; set; }
        public string? Lozinka { get; set; }
        public string? LozinkaPotvrda { get; set; }
        public bool? Status { get; set; }
        public bool? IsPremium { get; set; }
    }
}
