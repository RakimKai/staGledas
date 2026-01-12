namespace staGledas.Model.SearchObject
{
    public class RecenzijeSearchObject : BaseSearchObject
    {
        public string? SearchText { get; set; }
        public int? KorisnikId { get; set; }
        public int? FilmId { get; set; }
        public int? MinOcjena { get; set; }
        public int? MaxOcjena { get; set; }
        public string? OrderBy { get; set; }
        public bool? IsKorisnikIncluded { get; set; }
        public bool? IsFilmIncluded { get; set; }
        public bool IncludeHidden { get; set; } = false;
    }
}
