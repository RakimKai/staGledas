using staGledas.Model.DTOs.TMDb;
using staGledas.Model.Models;

namespace staGledas.Service.Interfaces
{
    public interface IRecommenderService
    {
        Task<List<TMDbMovie>> GetRecommendationsForUserAsync(int korisnikId, int count = 10);

        Task<List<TMDbMovie>> GetSimilarMoviesAsync(int filmId, int count = 10);

        Task<PersonalizedFeed> GetPersonalizedFeedAsync(int korisnikId);

        List<Filmovi> GetLocalRecommendationsForUser(int korisnikId, int count = 10);
        List<Filmovi> GetLocalSimilarMovies(int filmId, int count = 4);

        void TrainModel();
    }

    public class PersonalizedFeed
    {
        public List<TMDbMovie> Trending { get; set; } = new();
        public List<TMDbMovie> Popular { get; set; } = new();
        public List<TMDbMovie> ForYou { get; set; } = new();
        public List<TMDbMovie> BecauseYouLiked { get; set; } = new();
        public string? BecauseYouLikedTitle { get; set; }
    }
}
