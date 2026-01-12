namespace staGledas.Model.SearchObject
{
    public class PratiteljiSearchObject : BaseSearchObject
    {
        public int? KorisnikId { get; set; }
        public int? PratiteljId { get; set; }
        public string? OrderBy { get; set; }
        public bool? IsKorisnikIncluded { get; set; }
        public bool? IsPratiteljIncluded { get; set; }
    }
}
