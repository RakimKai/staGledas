namespace staGledas.Model.SearchObject
{
    public class ZalbeSearchObject : BaseSearchObject
    {
        public int? RecenzijaId { get; set; }
        public int? KorisnikId { get; set; }
        public string? Status { get; set; }
        public string? Razlog { get; set; }
        public string? OrderBy { get; set; }
        public bool? IsRecenzijaIncluded { get; set; }
        public bool? IsKorisnikIncluded { get; set; }
    }
}
