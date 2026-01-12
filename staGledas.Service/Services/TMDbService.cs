using MapsterMapper;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;
using staGledas.Model.DTOs.TMDb;
using staGledas.Model.Exceptions;
using staGledas.Service.Database;
using staGledas.Service.Interfaces;
using System.Net.Http.Json;

namespace staGledas.Service.Services
{
    public class TMDbService : ITMDbService
    {
        private readonly HttpClient _httpClient;
        private readonly StaGledasContext _context;
        private readonly IMapper _mapper;
        private readonly string _apiKey;
        private const string BaseUrl = "https://api.themoviedb.org/3";
        private const string ImageBaseUrl = "https://image.tmdb.org/t/p/w500";

        public TMDbService(HttpClient httpClient, StaGledasContext context, IMapper mapper, IConfiguration configuration)
        {
            _httpClient = httpClient;
            _context = context;
            _mapper = mapper;
            _apiKey = configuration["TMDb:ApiKey"] ?? throw new Exception("TMDb API key not configured");
        }

        public async Task<TMDbMovieSearchResponse> SearchMoviesAsync(string query, int page = 1)
        {
            var url = $"{BaseUrl}/search/movie?api_key={_apiKey}&query={Uri.EscapeDataString(query)}&page={page}&language=en-US";
            var response = await _httpClient.GetFromJsonAsync<TMDbMovieSearchResponse>(url);
            return response ?? new TMDbMovieSearchResponse();
        }

        public async Task<List<TMDbMovie>> GetPopularMoviesAsync(int page = 1)
        {
            var url = $"{BaseUrl}/movie/popular?api_key={_apiKey}&page={page}&language=en-US";
            var response = await _httpClient.GetFromJsonAsync<TMDbMovieSearchResponse>(url);
            return response?.Results ?? new List<TMDbMovie>();
        }

        public async Task<List<TMDbMovie>> GetTopRatedMoviesAsync(int page = 1)
        {
            var url = $"{BaseUrl}/movie/top_rated?api_key={_apiKey}&page={page}&language=en-US";
            var response = await _httpClient.GetFromJsonAsync<TMDbMovieSearchResponse>(url);
            return response?.Results ?? new List<TMDbMovie>();
        }

        public async Task<List<TMDbMovie>> GetTrendingMoviesAsync(int page = 1)
        {
            var url = $"{BaseUrl}/trending/movie/week?api_key={_apiKey}&page={page}&language=en-US";
            var response = await _httpClient.GetFromJsonAsync<TMDbMovieSearchResponse>(url);
            return response?.Results ?? new List<TMDbMovie>();
        }

        public async Task<List<TMDbMovie>> GetNowPlayingMoviesAsync(int page = 1)
        {
            var url = $"{BaseUrl}/movie/now_playing?api_key={_apiKey}&page={page}&language=en-US";
            var response = await _httpClient.GetFromJsonAsync<TMDbMovieSearchResponse>(url);
            return response?.Results ?? new List<TMDbMovie>();
        }

        public async Task<List<TMDbMovie>> GetUpcomingMoviesAsync(int page = 1)
        {
            var url = $"{BaseUrl}/movie/upcoming?api_key={_apiKey}&page={page}&language=en-US";
            var response = await _httpClient.GetFromJsonAsync<TMDbMovieSearchResponse>(url);
            return response?.Results ?? new List<TMDbMovie>();
        }

        public async Task<List<TMDbMovie>> DiscoverByGenreAsync(int genreId, int page = 1)
        {
            var url = $"{BaseUrl}/discover/movie?api_key={_apiKey}&with_genres={genreId}&page={page}&language=en-US&sort_by=popularity.desc";
            var response = await _httpClient.GetFromJsonAsync<TMDbMovieSearchResponse>(url);
            return response?.Results ?? new List<TMDbMovie>();
        }

        public async Task<TMDbMovieDetails?> GetMovieDetailsAsync(int tmdbId)
        {
            var url = $"{BaseUrl}/movie/{tmdbId}?api_key={_apiKey}&append_to_response=credits&language=en-US";
            return await _httpClient.GetFromJsonAsync<TMDbMovieDetails>(url);
        }

        public async Task<List<TMDbMovie>> GetTMDbRecommendationsAsync(int tmdbId, int page = 1)
        {
            var url = $"{BaseUrl}/movie/{tmdbId}/recommendations?api_key={_apiKey}&page={page}&language=en-US";
            var response = await _httpClient.GetFromJsonAsync<TMDbMovieSearchResponse>(url);
            return response?.Results ?? new List<TMDbMovie>();
        }

        public async Task<List<TMDbMovie>> GetSimilarMoviesAsync(int tmdbId, int page = 1)
        {
            var url = $"{BaseUrl}/movie/{tmdbId}/similar?api_key={_apiKey}&page={page}&language=en-US";
            var response = await _httpClient.GetFromJsonAsync<TMDbMovieSearchResponse>(url);
            return response?.Results ?? new List<TMDbMovie>();
        }

        public async Task<List<TMDbGenre>> GetGenresAsync()
        {
            var url = $"{BaseUrl}/genre/movie/list?api_key={_apiKey}&language=en-US";
            var response = await _httpClient.GetFromJsonAsync<TMDbGenreListResponse>(url);
            return response?.Genres ?? new List<TMDbGenre>();
        }

        public async Task<List<TMDbMovie>> GetTop100PopularMoviesAsync()
        {
            var allMovies = new List<TMDbMovie>();

            for (int page = 1; page <= 5; page++)
            {
                var movies = await GetPopularMoviesAsync(page);
                allMovies.AddRange(movies);
            }

            return allMovies.Take(100).ToList();
        }

        public async Task<Model.Models.Filmovi> GetOrImportMovieAsync(int tmdbId)
        {
            var existingFilm = await _context.Filmovi
                .Include(f => f.FilmoviZanrovi).ThenInclude(fz => fz.Zanr)
                .FirstOrDefaultAsync(f => f.TmdbId == tmdbId);

            if (existingFilm != null)
            {
                return _mapper.Map<Model.Models.Filmovi>(existingFilm);
            }

            return await ImportMovieAsync(tmdbId);
        }

        public async Task<Model.Models.Filmovi> ImportMovieAsync(int tmdbId)
        {
            var movieDetails = await GetMovieDetailsAsync(tmdbId);
            if (movieDetails == null)
            {
                throw new UserException("Film nije pronađen na TMDb.");
            }

            var existingFilm = await _context.Filmovi.FirstOrDefaultAsync(f => f.TmdbId == tmdbId);
            if (existingFilm != null)
            {
                return _mapper.Map<Model.Models.Filmovi>(existingFilm);
            }

            int? releaseYear = null;
            if (!string.IsNullOrEmpty(movieDetails.ReleaseDate) && movieDetails.ReleaseDate.Length >= 4)
            {
                if (int.TryParse(movieDetails.ReleaseDate.Substring(0, 4), out int year))
                {
                    releaseYear = year;
                }
            }

            var director = movieDetails.Credits?.Crew?.FirstOrDefault(c => c.Job == "Director")?.Name;

            var genreIds = new List<int>();
            foreach (var tmdbGenre in movieDetails.Genres)
            {
                var existingGenre = await _context.Zanrovi.FirstOrDefaultAsync(z => z.Naziv == tmdbGenre.Name);
                if (existingGenre == null)
                {
                    existingGenre = new Database.Zanrovi
                    {
                        Naziv = tmdbGenre.Name,
                        Opis = $"Imported from TMDb"
                    };
                    _context.Zanrovi.Add(existingGenre);
                    await _context.SaveChangesAsync();
                }
                genreIds.Add(existingGenre.Id);
            }

            var film = new Database.Filmovi
            {
                TmdbId = tmdbId,
                Naslov = movieDetails.Title,
                Opis = movieDetails.Overview,
                GodinaIzdanja = releaseYear,
                Trajanje = movieDetails.Runtime,
                Reziser = director,
                PosterPath = movieDetails.PosterPath,
                ProsjecnaOcjena = movieDetails.VoteAverage / 2,
                BrojOcjena = movieDetails.VoteCount,
                BrojPregleda = 0,
                DatumKreiranja = DateTime.Now,
                DatumIzmjene = DateTime.Now
            };

            _context.Filmovi.Add(film);
            await _context.SaveChangesAsync();

            foreach (var genreId in genreIds)
            {
                _context.FilmoviZanrovi.Add(new Database.FilmoviZanrovi
                {
                    FilmId = film.Id,
                    ZanrId = genreId
                });
            }

            await _context.SaveChangesAsync();

            var result = await _context.Filmovi
                .Include(f => f.FilmoviZanrovi).ThenInclude(fz => fz.Zanr)
                .FirstOrDefaultAsync(f => f.Id == film.Id);

            return _mapper.Map<Model.Models.Filmovi>(result);
        }

        public async Task<List<Model.Models.Filmovi>> SeedPopularMoviesAsync(int pages = 3)
        {
            var importedMovies = new List<Model.Models.Filmovi>();

            for (int page = 1; page <= pages; page++)
            {
                var popularMovies = await GetPopularMoviesAsync(page);

                foreach (var movie in popularMovies)
                {
                    try
                    {
                        var existing = await _context.Filmovi.FirstOrDefaultAsync(f => f.TmdbId == movie.Id);
                        if (existing == null)
                        {
                            var imported = await ImportMovieAsync(movie.Id);
                            importedMovies.Add(imported);
                        }
                    }
                    catch
                    {
                        continue;
                    }
                }
            }

            return importedMovies;
        }
    }

    public class TMDbGenreListResponse
    {
        public List<TMDbGenre> Genres { get; set; } = new List<TMDbGenre>();
    }
}
