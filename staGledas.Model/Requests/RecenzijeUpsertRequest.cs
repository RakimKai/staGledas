namespace staGledas.Model.Requests
{
    public class RecenzijeUpsertRequest
    {
        public int? KorisnikId { get; set; }
        public int FilmId { get; set; }
        public double Ocjena { get; set; }
        public string? Naslov { get; set; }
        public string? Sadrzaj { get; set; }
        public bool ImaSpoiler { get; set; }
    }
}
