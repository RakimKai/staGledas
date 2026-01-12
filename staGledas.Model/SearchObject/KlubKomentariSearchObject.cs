namespace staGledas.Model.SearchObject
{
    public class KlubKomentariSearchObject : BaseSearchObject
    {
        public int? ObjavaId { get; set; }
        public int? KorisnikId { get; set; }
        public int? ParentKomentarId { get; set; }
        public string? OrderBy { get; set; }
        public bool? IsObjavaIncluded { get; set; }
        public bool? IsKorisnikIncluded { get; set; }
    }
}
