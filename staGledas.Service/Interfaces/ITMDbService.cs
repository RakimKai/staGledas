using staGledas.Model.DTOs.TMDb;
using staGledas.Model.Models;

namespace staGledas.Service.Interfaces
{
    public interface ITMDbService
    {
        Task<TMDbMovieSearchResponse> SearchMoviesAsync(string query, int page = 1);

        Task<List<TMDbMovie>> GetPopularMoviesAsync(int page = 1);
        Task<List<TMDbMovie>> GetTopRatedMoviesAsync(int page = 1);
        Task<List<TMDbMovie>> GetTrendingMoviesAsync(int page = 1);
        Task<List<TMDbMovie>> GetNowPlayingMoviesAsync(int page = 1);
        Task<List<TMDbMovie>> GetUpcomingMoviesAsync(int page = 1);
        Task<List<TMDbMovie>> DiscoverByGenreAsync(int genreId, int page = 1);

        Task<TMDbMovieDetails?> GetMovieDetailsAsync(int tmdbId);

        Task<List<TMDbMovie>> GetTMDbRecommendationsAsync(int tmdbId, int page = 1);
        Task<List<TMDbMovie>> GetSimilarMoviesAsync(int tmdbId, int page = 1);

        Task<Filmovi> ImportMovieAsync(int tmdbId);

        Task<Filmovi> GetOrImportMovieAsync(int tmdbId);

        Task<List<Filmovi>> SeedPopularMoviesAsync(int pages = 3);

        Task<List<TMDbGenre>> GetGenresAsync();

        Task<List<TMDbMovie>> GetTop100PopularMoviesAsync();
    }
}
