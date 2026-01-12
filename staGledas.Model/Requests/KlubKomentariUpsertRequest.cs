namespace staGledas.Model.Requests
{
    public class KlubKomentariUpsertRequest
    {
        public int ObjavaId { get; set; }
        public int KorisnikId { get; set; }
        public string? Sadrzaj { get; set; }
        public int? ParentKomentarId { get; set; }
    }
}
