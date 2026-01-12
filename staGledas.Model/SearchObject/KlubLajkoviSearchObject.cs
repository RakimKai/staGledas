namespace staGledas.Model.SearchObject
{
    public class KlubLajkoviSearchObject : BaseSearchObject
    {
        public int? ObjavaId { get; set; }
        public int? KorisnikId { get; set; }
        public string? OrderBy { get; set; }
        public bool? IsObjavaIncluded { get; set; }
        public bool? IsKorisnikIncluded { get; set; }
    }
}
