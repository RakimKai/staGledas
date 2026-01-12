using MapsterMapper;
using Microsoft.EntityFrameworkCore;
using Microsoft.ML;
using Microsoft.ML.Trainers;
using staGledas.Model.DTOs.TMDb;
using staGledas.Service.Database;
using staGledas.Service.Interfaces;
using staGledas.Service.Recommender;

namespace staGledas.Service.Services
{
    public class RecommenderService : IRecommenderService
    {
        private readonly StaGledasContext _context;
        private readonly IMapper _mapper;
        private readonly ITMDbService _tmdbService;

        private static MLContext? _mlContext;
        private static ITransformer? _genreModel;
        private static ITransformer? _userModel;
        private static readonly object _lockObject = new object();
        private static bool _isTrainingUserModel = false;

        private const string GenreModelPath = "genre-model.zip";
        private const string UserModelPath = "user-model.zip";
        private const int MinimumInteractionsForML = 5;

        public RecommenderService(StaGledasContext context, IMapper mapper, ITMDbService tmdbService)
        {
            _context = context;
            _mapper = mapper;
            _tmdbService = tmdbService;
        }

        public async Task<List<TMDbMovie>> GetRecommendationsForUserAsync(int korisnikId, int count = 10)
        {
            var userReviews = await _context.Recenzije
                .Where(r => r.KorisnikId == korisnikId)
                .Include(r => r.Film)
                .OrderByDescending(r => r.Ocjena)
                .ToListAsync();

            var watchlist = await _context.Watchlist
                .Where(w => w.KorisnikId == korisnikId && w.Pogledano == true)
                .Include(w => w.Film)
                .ToListAsync();

            var userLikes = await _context.FilmoviLajkovi
                .Where(fl => fl.KorisnikId == korisnikId)
                .Include(fl => fl.Film)
                .OrderByDescending(fl => fl.DatumLajka)
                .ToListAsync();

            var totalInteractions = userReviews.Count + watchlist.Count + userLikes.Count;

            if (totalInteractions == 0)
            {
                return await _tmdbService.GetTrendingMoviesAsync();
            }

            var likedMovies = userReviews
                .Where(r => r.Ocjena >= 4 && r.Film?.TmdbId != null)
                .Select(r => r.Film!)
                .ToList();

            if (!likedMovies.Any())
            {
                likedMovies = userLikes
                    .Where(fl => fl.Film?.TmdbId != null)
                    .Select(fl => fl.Film!)
                    .ToList();
            }

            if (!likedMovies.Any())
            {
                likedMovies = watchlist
                    .Where(w => w.Film?.TmdbId != null)
                    .Select(w => w.Film!)
                    .ToList();
            }

            if (!likedMovies.Any())
            {
                return await _tmdbService.GetPopularMoviesAsync();
            }

            var topMovie = likedMovies.First();
            var recommendations = await _tmdbService.GetTMDbRecommendationsAsync(topMovie.TmdbId!.Value);

            if (totalInteractions >= MinimumInteractionsForML && likedMovies.Count > 1)
            {
                var secondMovie = likedMovies.Skip(1).First();
                var moreRecs = await _tmdbService.GetTMDbRecommendationsAsync(secondMovie.TmdbId!.Value);

                var existingIds = recommendations.Select(r => r.Id).ToHashSet();
                recommendations.AddRange(moreRecs.Where(r => !existingIds.Contains(r.Id)));
            }

            var seenTmdbIds = userReviews.Select(r => r.Film?.TmdbId)
                .Union(watchlist.Select(w => w.Film?.TmdbId))
                .Union(userLikes.Select(fl => fl.Film?.TmdbId))
                .Where(id => id.HasValue)
                .Select(id => id!.Value)
                .ToHashSet();

            return recommendations
                .Where(r => !seenTmdbIds.Contains(r.Id))
                .Take(count)
                .ToList();
        }

        public async Task<List<TMDbMovie>> GetSimilarMoviesAsync(int filmId, int count = 10)
        {
            var film = await _context.Filmovi.FindAsync(filmId);

            if (film?.TmdbId != null)
            {
                return await _tmdbService.GetSimilarMoviesAsync(film.TmdbId.Value);
            }

            var localSimilar = GetLocalSimilarMovies(filmId, count);

            return localSimilar.Select(f => new TMDbMovie
            {
                Id = f.TmdbId ?? f.Id,
                Title = f.Naslov,
                Overview = f.Opis,
                VoteAverage = (f.ProsjecnaOcjena ?? 0) * 2,
                VoteCount = f.BrojOcjena ?? 0
            }).ToList();
        }

        public async Task<PersonalizedFeed> GetPersonalizedFeedAsync(int korisnikId)
        {
            var feed = new PersonalizedFeed
            {
                Trending = await _tmdbService.GetTrendingMoviesAsync(),
                Popular = await _tmdbService.GetPopularMoviesAsync()
            };

            var likedReview = await _context.Recenzije
                .Where(r => r.KorisnikId == korisnikId && r.Ocjena >= 4)
                .Include(r => r.Film)
                .OrderByDescending(r => r.DatumKreiranja)
                .FirstOrDefaultAsync();

            if (likedReview?.Film?.TmdbId != null)
            {
                feed.BecauseYouLiked = await _tmdbService.GetTMDbRecommendationsAsync(likedReview.Film.TmdbId.Value);
                feed.BecauseYouLikedTitle = likedReview.Film.Naslov;
            }

            feed.ForYou = await GetRecommendationsForUserAsync(korisnikId, 20);

            return feed;
        }

        public List<Model.Models.Filmovi> GetLocalSimilarMovies(int filmId, int count = 4)
        {
            EnsureGenreModelTrained();

            var film = _context.Filmovi
                .Include(f => f.FilmoviZanrovi)
                .FirstOrDefault(f => f.Id == filmId);

            if (film == null)
                return new List<Model.Models.Filmovi>();

            var filmGenreIds = film.FilmoviZanrovi.Select(fz => fz.ZanrId).ToList();
            if (!filmGenreIds.Any())
                return new List<Model.Models.Filmovi>();

            var potentialFilms = _context.Filmovi
                .Include(f => f.FilmoviZanrovi)
                .ThenInclude(fz => fz.Zanr)
                .Where(f => f.Id != filmId && f.FilmoviZanrovi.Any(fz => filmGenreIds.Contains(fz.ZanrId)))
                .ToList();

            if (!potentialFilms.Any())
                return new List<Model.Models.Filmovi>();

            var predictionResult = new List<(Filmovi film, float score)>();

            foreach (var potentialFilm in potentialFilms)
            {
                var predictionEngine = _mlContext!.Model.CreatePredictionEngine<MovieEntry, MoviePrediction>(_genreModel);
                var prediction = predictionEngine.Predict(new MovieEntry
                {
                    FilmId = (uint)filmId,
                    RelatedFilmId = (uint)potentialFilm.Id
                });
                predictionResult.Add((potentialFilm, prediction.Score));
            }

            var finalResult = predictionResult
                .OrderByDescending(x => x.score)
                .Select(x => x.film)
                .Take(count)
                .ToList();

            return _mapper.Map<List<Model.Models.Filmovi>>(finalResult);
        }

        public List<Model.Models.Filmovi> GetLocalRecommendationsForUser(int korisnikId, int count = 10)
        {
            var userFilmIds = _context.Recenzije
                .Where(r => r.KorisnikId == korisnikId)
                .Select(r => r.FilmId)
                .Union(_context.Watchlist
                    .Where(w => w.KorisnikId == korisnikId)
                    .Select(w => w.FilmId))
                .ToList();

            if (_userModel == null)
            {
                if (!_isTrainingUserModel && !File.Exists(UserModelPath))
                {
                    _isTrainingUserModel = true;
                    Task.Run(() =>
                    {
                        try
                        {
                            EnsureUserModelTrained();
                        }
                        finally
                        {
                            _isTrainingUserModel = false;
                        }
                    });
                }
                else if (File.Exists(UserModelPath))
                {
                    EnsureUserModelTrained();
                }

                if (_userModel == null)
                {
                    return GetPopularMoviesFallback(userFilmIds, count);
                }
            }

            var potentialFilms = _context.Filmovi
                .Include(f => f.FilmoviZanrovi)
                .ThenInclude(fz => fz.Zanr)
                .Where(f => !userFilmIds.Contains(f.Id))
                .ToList();

            if (!potentialFilms.Any())
                return new List<Model.Models.Filmovi>();

            var predictionResult = new List<(Filmovi film, float score)>();

            foreach (var potentialFilm in potentialFilms)
            {
                var predictionEngine = _mlContext!.Model.CreatePredictionEngine<UserMovieEntry, UserMoviePrediction>(_userModel);
                var prediction = predictionEngine.Predict(new UserMovieEntry
                {
                    KorisnikId = (uint)korisnikId,
                    FilmId = (uint)potentialFilm.Id
                });
                predictionResult.Add((potentialFilm, prediction.Score));
            }

            var finalResult = predictionResult
                .OrderByDescending(x => x.score)
                .Select(x => x.film)
                .Take(count)
                .ToList();

            return _mapper.Map<List<Model.Models.Filmovi>>(finalResult);
        }

        private List<Model.Models.Filmovi> GetPopularMoviesFallback(List<int> excludeFilmIds, int count)
        {
            var popularFilms = _context.Filmovi
                .Where(f => !excludeFilmIds.Contains(f.Id))
                .OrderByDescending(f => f.ProsjecnaOcjena ?? 0)
                .ThenByDescending(f => f.BrojOcjena ?? 0)
                .Take(count)
                .ToList();

            return _mapper.Map<List<Model.Models.Filmovi>>(popularFilms);
        }

        public void TrainModel()
        {
            lock (_lockObject)
            {
                _mlContext = new MLContext();
                TrainGenreModel();
                TrainUserModel();
            }
        }

        private void EnsureGenreModelTrained()
        {
            if (_mlContext == null || _genreModel == null)
            {
                lock (_lockObject)
                {
                    if (_mlContext == null)
                        _mlContext = new MLContext();

                    if (_genreModel == null)
                    {
                        if (File.Exists(GenreModelPath))
                        {
                            using var stream = new FileStream(GenreModelPath, FileMode.Open, FileAccess.Read, FileShare.Read);
                            _genreModel = _mlContext.Model.Load(stream, out _);
                        }
                        else
                        {
                            TrainGenreModel();
                        }
                    }
                }
            }
        }

        private void EnsureUserModelTrained()
        {
            if (_mlContext == null || _userModel == null)
            {
                lock (_lockObject)
                {
                    if (_mlContext == null)
                        _mlContext = new MLContext();

                    if (_userModel == null)
                    {
                        if (File.Exists(UserModelPath))
                        {
                            using var stream = new FileStream(UserModelPath, FileMode.Open, FileAccess.Read, FileShare.Read);
                            _userModel = _mlContext.Model.Load(stream, out _);
                        }
                        else
                        {
                            TrainUserModel();
                        }
                    }
                }
            }
        }

        private void TrainGenreModel()
        {
            var films = _context.Filmovi
                .Include(f => f.FilmoviZanrovi)
                .ToList();

            var data = new List<MovieEntry>();

            foreach (var film in films)
            {
                var filmGenreIds = film.FilmoviZanrovi.Select(fz => fz.ZanrId).ToHashSet();

                var relatedFilms = films
                    .Where(f => f.Id != film.Id && f.FilmoviZanrovi.Any(fz => filmGenreIds.Contains(fz.ZanrId)));

                foreach (var relatedFilm in relatedFilms)
                {
                    var relatedGenreIds = relatedFilm.FilmoviZanrovi.Select(fz => fz.ZanrId).ToHashSet();
                    var sharedGenres = filmGenreIds.Intersect(relatedGenreIds).Count();
                    var totalGenres = filmGenreIds.Union(relatedGenreIds).Count();
                    var similarity = totalGenres > 0 ? (float)sharedGenres / totalGenres : 0f;

                    data.Add(new MovieEntry
                    {
                        FilmId = (uint)film.Id,
                        RelatedFilmId = (uint)relatedFilm.Id,
                        Label = similarity
                    });
                }
            }

            if (!data.Any())
            {
                data.Add(new MovieEntry { FilmId = 1, RelatedFilmId = 2, Label = 0.5f });
            }

            var trainData = _mlContext!.Data.LoadFromEnumerable(data);

            var options = new MatrixFactorizationTrainer.Options
            {
                MatrixColumnIndexColumnName = nameof(MovieEntry.FilmId),
                MatrixRowIndexColumnName = nameof(MovieEntry.RelatedFilmId),
                LabelColumnName = "Label",
                LossFunction = MatrixFactorizationTrainer.LossFunctionType.SquareLossOneClass,
                Alpha = 0.01,
                Lambda = 0.025,
                NumberOfIterations = 20,
                C = 0.00001,
                Quiet = true
            };

            var est = _mlContext.Recommendation().Trainers.MatrixFactorization(options);
            _genreModel = est.Fit(trainData);

            using var stream = new FileStream(GenreModelPath, FileMode.Create, FileAccess.Write, FileShare.Write);
            _mlContext.Model.Save(_genreModel, trainData.Schema, stream);
        }

        private void TrainUserModel()
        {
            var interactions = _context.Recenzije
                .Select(r => new { r.KorisnikId, r.FilmId, Rating = (float)r.Ocjena })
                .ToList();

            var watchlistInteractions = _context.Watchlist
                .Select(w => new { w.KorisnikId, w.FilmId, Rating = w.Pogledano == true ? 4f : 3f })
                .ToList();

            var data = interactions
                .Select(i => new UserMovieEntry
                {
                    KorisnikId = (uint)i.KorisnikId,
                    FilmId = (uint)i.FilmId,
                    Label = i.Rating / 5f
                })
                .Concat(watchlistInteractions.Select(w => new UserMovieEntry
                {
                    KorisnikId = (uint)w.KorisnikId,
                    FilmId = (uint)w.FilmId,
                    Label = w.Rating / 5f
                }))
                .ToList();

            if (!data.Any())
            {
                data.Add(new UserMovieEntry { KorisnikId = 1, FilmId = 1, Label = 0.8f });
            }

            var trainData = _mlContext!.Data.LoadFromEnumerable(data);

            var options = new MatrixFactorizationTrainer.Options
            {
                MatrixColumnIndexColumnName = nameof(UserMovieEntry.KorisnikId),
                MatrixRowIndexColumnName = nameof(UserMovieEntry.FilmId),
                LabelColumnName = "Label",
                LossFunction = MatrixFactorizationTrainer.LossFunctionType.SquareLossOneClass,
                Alpha = 0.01,
                Lambda = 0.025,
                NumberOfIterations = 20,
                C = 0.00001,
                Quiet = true
            };

            var est = _mlContext.Recommendation().Trainers.MatrixFactorization(options);
            _userModel = est.Fit(trainData);

            using var stream = new FileStream(UserModelPath, FileMode.Create, FileAccess.Write, FileShare.Write);
            _mlContext.Model.Save(_userModel, trainData.Schema, stream);
        }
    }
}
