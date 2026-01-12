namespace staGledas.Model.Requests
{
    public class NovostiUpsertRequest
    {
        public string? Naslov { get; set; }
        public string? Sadrzaj { get; set; }
        public byte[]? Slika { get; set; }
        public int? AutorId { get; set; }
    }
}
