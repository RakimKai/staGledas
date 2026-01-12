namespace staGledas.Model.SearchObject
{
    public class KlubFilmovaSearchObject : BaseSearchObject
    {
        public string? NazivGTE { get; set; }
        public int? VlasnikId { get; set; }
        public bool? IsPrivate { get; set; }
        public int? KorisnikJeClan { get; set; }
        public string? OrderBy { get; set; }
        public bool? IsVlasnikIncluded { get; set; }
        public bool? IsClanoviIncluded { get; set; }
    }
}
