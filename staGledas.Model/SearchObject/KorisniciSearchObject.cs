namespace staGledas.Model.SearchObject
{
    public class KorisniciSearchObject : BaseSearchObject
    {
        public string? Ime { get; set; }
        public string? Email { get; set; }
        public bool? Status { get; set; }
        public bool? IsPremium { get; set; }
        public bool? IsUlogeIncluded { get; set; }
    }
}
