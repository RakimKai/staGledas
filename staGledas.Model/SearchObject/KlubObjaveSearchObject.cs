namespace staGledas.Model.SearchObject
{
    public class KlubObjaveSearchObject : BaseSearchObject
    {
        public int? KlubId { get; set; }
        public int? KorisnikId { get; set; }
        public string? OrderBy { get; set; }
        public bool? IsKlubIncluded { get; set; }
        public bool? IsKorisnikIncluded { get; set; }
        public bool IncludeDeleted { get; set; } = false;
    }
}
