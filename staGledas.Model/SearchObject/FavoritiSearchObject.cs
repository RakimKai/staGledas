namespace staGledas.Model.SearchObject
{
    public class FavoritiSearchObject : BaseSearchObject
    {
        public int? KorisnikId { get; set; }
        public int? FilmId { get; set; }
        public string? OrderBy { get; set; }
        public bool? IsKorisnikIncluded { get; set; }
        public bool? IsFilmIncluded { get; set; }
    }
}
