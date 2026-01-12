using Microsoft.ML.Data;

namespace staGledas.Service.Recommender
{
    public class MovieEntry
    {
        [KeyType(count: 100000)]
        public uint FilmId { get; set; }

        [KeyType(count: 100000)]
        public uint RelatedFilmId { get; set; }

        public float Label { get; set; }
    }

    public class MoviePrediction
    {
        public float Score { get; set; }
    }

    public class UserMovieEntry
    {
        [KeyType(count: 100000)]
        public uint KorisnikId { get; set; }

        [KeyType(count: 100000)]
        public uint FilmId { get; set; }

        public float Label { get; set; }
    }

    public class UserMoviePrediction
    {
        public float Score { get; set; }
    }
}
