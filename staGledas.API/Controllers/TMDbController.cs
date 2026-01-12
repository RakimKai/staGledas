using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using staGledas.Model.DTOs.TMDb;
using staGledas.Model.Models;
using staGledas.Model.Requests;
using staGledas.Service.Interfaces;

namespace staGledas.API.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    [Authorize]
    public class TMDbController : ControllerBase
    {
        private readonly ITMDbService _tmdbService;

        public TMDbController(ITMDbService tmdbService)
        {
            _tmdbService = tmdbService;
        }

        [HttpGet("search")]
        [AllowAnonymous]
        public async Task<TMDbMovieSearchResponse> SearchMovies([FromQuery] string query, [FromQuery] int page = 1)
        {
            return await _tmdbService.SearchMoviesAsync(query, page);
        }

        [HttpGet("popular")]
        [AllowAnonymous]
        public async Task<List<TMDbMovie>> GetPopularMovies([FromQuery] int page = 1)
        {
            return await _tmdbService.GetPopularMoviesAsync(page);
        }

        [HttpGet("top-rated")]
        [AllowAnonymous]
        public async Task<List<TMDbMovie>> GetTopRatedMovies([FromQuery] int page = 1)
        {
            return await _tmdbService.GetTopRatedMoviesAsync(page);
        }

        [HttpGet("trending")]
        [AllowAnonymous]
        public async Task<List<TMDbMovie>> GetTrendingMovies([FromQuery] int page = 1)
        {
            return await _tmdbService.GetTrendingMoviesAsync(page);
        }

        [HttpGet("now-playing")]
        [AllowAnonymous]
        public async Task<List<TMDbMovie>> GetNowPlayingMovies([FromQuery] int page = 1)
        {
            return await _tmdbService.GetNowPlayingMoviesAsync(page);
        }

        [HttpGet("upcoming")]
        [AllowAnonymous]
        public async Task<List<TMDbMovie>> GetUpcomingMovies([FromQuery] int page = 1)
        {
            return await _tmdbService.GetUpcomingMoviesAsync(page);
        }

        [HttpGet("discover/genre/{genreId}")]
        [AllowAnonymous]
        public async Task<List<TMDbMovie>> DiscoverByGenre(int genreId, [FromQuery] int page = 1)
        {
            return await _tmdbService.DiscoverByGenreAsync(genreId, page);
        }

        [HttpGet("genres")]
        [AllowAnonymous]
        public async Task<List<TMDbGenre>> GetGenres()
        {
            return await _tmdbService.GetGenresAsync();
        }

        [HttpGet("movie/{tmdbId}")]
        [AllowAnonymous]
        public async Task<ActionResult<TMDbMovieDetails>> GetMovieDetails(int tmdbId)
        {
            var movie = await _tmdbService.GetMovieDetailsAsync(tmdbId);
            if (movie == null)
            {
                return NotFound();
            }
            return movie;
        }

        [HttpGet("movie/{tmdbId}/recommendations")]
        [AllowAnonymous]
        public async Task<List<TMDbMovie>> GetRecommendations(int tmdbId, [FromQuery] int page = 1)
        {
            return await _tmdbService.GetTMDbRecommendationsAsync(tmdbId, page);
        }

        [HttpGet("movie/{tmdbId}/similar")]
        [AllowAnonymous]
        public async Task<List<TMDbMovie>> GetSimilarMovies(int tmdbId, [FromQuery] int page = 1)
        {
            return await _tmdbService.GetSimilarMoviesAsync(tmdbId, page);
        }

        [HttpGet("movie/{tmdbId}/local")]
        public async Task<Filmovi> GetOrImportMovie(int tmdbId)
        {
            return await _tmdbService.GetOrImportMovieAsync(tmdbId);
        }

        [HttpPost("import")]
        public async Task<Filmovi> ImportMovie([FromBody] FilmImportRequest request)
        {
            return await _tmdbService.ImportMovieAsync(request.TmdbId);
        }

        [HttpPost("import/{tmdbId}")]
        public async Task<Filmovi> ImportMovieById(int tmdbId)
        {
            return await _tmdbService.ImportMovieAsync(tmdbId);
        }

        [HttpPost("seed-popular")]
        public async Task<ActionResult<List<Filmovi>>> SeedPopularMovies([FromQuery] int pages = 3)
        {
            var movies = await _tmdbService.SeedPopularMoviesAsync(pages);
            return Ok(new { imported = movies.Count, movies });
        }
    }
}
