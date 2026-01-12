namespace staGledas.Model.Requests
{
    public class KlubObjaveUpsertRequest
    {
        public int KlubId { get; set; }
        public int KorisnikId { get; set; }
        public string? Sadrzaj { get; set; }
    }
}
