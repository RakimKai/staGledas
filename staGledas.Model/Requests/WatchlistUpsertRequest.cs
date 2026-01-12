namespace staGledas.Model.Requests
{
    public class WatchlistUpsertRequest
    {
        public int FilmId { get; set; }
        public bool? Pogledano { get; set; }
    }
}
