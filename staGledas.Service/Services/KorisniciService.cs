using MapsterMapper;
using Microsoft.EntityFrameworkCore;
using staGledas.Model.Exceptions;
using staGledas.Model.Requests;
using staGledas.Model.SearchObject;
using staGledas.Service.Database;
using staGledas.Service.Interfaces;

namespace staGledas.Service.Services
{
    public class KorisniciService : BaseCRUDService<Model.Models.Korisnici, KorisniciSearchObject, Database.Korisnici, KorisniciInsertRequest, KorisniciUpdateRequest>, IKorisniciService
    {
        private readonly ITMDbService _tmdbService;
        private readonly IEmailService _emailService;

        public KorisniciService(StaGledasContext dbContext, IMapper mapper, ITMDbService tmdbService, IEmailService emailService) : base(dbContext, mapper)
        {
            _tmdbService = tmdbService;
            _emailService = emailService;
        }

        public override IQueryable<Database.Korisnici> AddFilter(KorisniciSearchObject searchObject, IQueryable<Database.Korisnici> query)
        {
            var filteredQuery = base.AddFilter(searchObject, query);

            if (!string.IsNullOrWhiteSpace(searchObject?.Ime))
            {
                filteredQuery = filteredQuery.Where(x =>
                    (x.Ime != null && x.Ime.Contains(searchObject.Ime)) ||
                    (x.Prezime != null && x.Prezime.Contains(searchObject.Ime)));
            }

            if (!string.IsNullOrWhiteSpace(searchObject?.Email))
            {
                filteredQuery = filteredQuery.Where(x => x.Email == searchObject.Email);
            }

            if (searchObject?.Status.HasValue == true)
            {
                filteredQuery = filteredQuery.Where(x => x.Status == searchObject.Status);
            }

            if (searchObject?.IsPremium.HasValue == true)
            {
                filteredQuery = filteredQuery.Where(x => x.IsPremium == searchObject.IsPremium);
            }

            if (searchObject?.IsUlogeIncluded == true)
            {
                filteredQuery = filteredQuery.Include(x => x.KorisniciUloge).ThenInclude(x => x.Uloga);
            }

            return filteredQuery;
        }

        public override void BeforeInsert(KorisniciInsertRequest request, Database.Korisnici entity)
        {
            if (request.Lozinka != request.LozinkaPotvrda)
            {
                throw new UserException("Lozinka i potvrda lozinke moraju biti iste.");
            }

            var existingUser = Context.Korisnici.FirstOrDefault(x => x.KorisnickoIme == request.KorisnickoIme);
            if (existingUser != null)
            {
                throw new UserException("Korisnicko ime vec postoji.");
            }

            var existingEmail = Context.Korisnici.FirstOrDefault(x => x.Email == request.Email);
            if (existingEmail != null)
            {
                throw new UserException("Email vec postoji.");
            }

            entity.LozinkaSalt = StaGledasContext.GenerateSalt();
            entity.LozinkaHash = StaGledasContext.GenerateHash(entity.LozinkaSalt, request.Lozinka!);
            entity.Status = true;
            entity.IsPremium = request.UlogaId == 1;
        }

        public override void BeforeUpdate(KorisniciUpdateRequest request, Database.Korisnici entity)
        {
            if (!string.IsNullOrWhiteSpace(request.Lozinka))
            {
                if (request.Lozinka != request.LozinkaPotvrda)
                {
                    throw new UserException("Lozinka i potvrda lozinke moraju biti iste.");
                }

                entity.LozinkaSalt = StaGledasContext.GenerateSalt();
                entity.LozinkaHash = StaGledasContext.GenerateHash(entity.LozinkaSalt, request.Lozinka);
            }
        }

        public override void AfterInsert(Database.Korisnici entity, KorisniciInsertRequest request)
        {
            int roleId;

            if (request.UlogaId.HasValue)
            {
                var specifiedRole = Context.Uloge.FirstOrDefault(x => x.Id == request.UlogaId.Value);
                if (specifiedRole == null)
                {
                    throw new UserException("Uloga ne postoji.");
                }
                roleId = specifiedRole.Id;
            }
            else
            {
                var korisnikRole = Context.Uloge.FirstOrDefault(x => x.Naziv == "Korisnik");
                if (korisnikRole == null)
                {
                    throw new UserException("Uloga 'Korisnik' ne postoji.");
                }
                roleId = korisnikRole.Id;
            }

            var roleEntity = new Database.KorisniciUloge()
            {
                KorisnikId = entity.Id,
                UlogaId = roleId
            };

            Context.Add(roleEntity);
            Context.SaveChanges();

            if (!string.IsNullOrWhiteSpace(entity.Email) && roleId != 1)
            {
                _emailService.SendWelcomeEmail(entity.Email, entity.Ime ?? entity.KorisnickoIme ?? "Korisniče");
            }

            base.AfterInsert(entity, request);
        }

        public override Model.Models.Korisnici Delete(int id)
        {
            var entity = Context.Korisnici.Find(id);

            if (entity != null)
            {
                entity.IsDeleted = true;
                entity.DatumBrisanja = DateTime.Now;
                entity.Status = false;
                Context.SaveChanges();
            }

            return Mapper.Map<Model.Models.Korisnici>(entity);
        }

        public Model.Models.Korisnici? Login(string username, string password)
        {
            var entity = Context.Korisnici
                .Include(x => x.KorisniciUloge)
                .ThenInclude(x => x.Uloga)
                .FirstOrDefault(x => x.KorisnickoIme == username);

            if (entity == null)
            {
                return null;
            }

            var hash = StaGledasContext.GenerateHash(entity.LozinkaSalt!, password);

            if (hash != entity.LozinkaHash)
            {
                return null;
            }

            return Mapper.Map<Model.Models.Korisnici>(entity);
        }

        public async Task<Model.Models.UserProfile> GetProfile(int id)
        {
            var entity = await Context.Korisnici
                .FirstOrDefaultAsync(x => x.Id == id);

            if (entity == null)
            {
                throw new UserException("Korisnik ne postoji.");
            }

            var profile = new Model.Models.UserProfile
            {
                Id = entity.Id,
                Ime = entity.Ime,
                Prezime = entity.Prezime,
                KorisnickoIme = entity.KorisnickoIme,
                Email = entity.Email,
                Slika = entity.Slika,
                IsPremium = entity.IsPremium,
                DatumKreiranja = entity.DatumKreiranja,
                BrojRecenzija = await Context.Recenzije.CountAsync(r => r.KorisnikId == id && !r.IsHidden),
                BrojFilmova = await Context.Watchlist.CountAsync(w => w.KorisnikId == id && w.Pogledano == true),
                BrojPratioca = await Context.Pratitelji.CountAsync(p => p.KorisnikId == id),
                BrojPratim = await Context.Pratitelji.CountAsync(p => p.PratiteljId == id),
                BrojFavorita = await Context.Favoriti.CountAsync(f => f.KorisnikId == id),
                BrojLajkova = await Context.FilmoviLajkovi.CountAsync(fl => fl.KorisnikId == id),
                NedavneRecenzije = Mapper.Map<List<Model.Models.Recenzije>>(
                    await Context.Recenzije
                        .Include(r => r.Film)
                        .Where(r => r.KorisnikId == id && !r.IsHidden)
                        .OrderByDescending(r => r.DatumKreiranja)
                        .Take(5)
                        .ToListAsync()),
                NedavnoPogledano = Mapper.Map<List<Model.Models.Filmovi>>(
                    await Context.Watchlist
                        .Include(w => w.Film)
                        .Where(w => w.KorisnikId == id && w.Pogledano == true)
                        .OrderByDescending(w => w.DatumGledanja)
                        .Take(5)
                        .Select(w => w.Film)
                        .ToListAsync()),
                OmiljeniFilmovi = Mapper.Map<List<Model.Models.Filmovi>>(
                    await Context.Favoriti
                        .Include(f => f.Film)
                        .Where(f => f.KorisnikId == id)
                        .OrderByDescending(f => f.DatumDodavanja)
                        .Take(5)
                        .Select(f => f.Film)
                        .ToListAsync())
            };

            return profile;
        }

        public async Task<Model.Models.UserStatistics> GetStatistics(int id)
        {
            var stats = new Model.Models.UserStatistics
            {
                BrojRecenzija = await Context.Recenzije.CountAsync(r => r.KorisnikId == id && !r.IsHidden),
                BrojPogledanihFilmova = await Context.Watchlist.CountAsync(w => w.KorisnikId == id && w.Pogledano == true),
                BrojPratioca = await Context.Pratitelji.CountAsync(p => p.KorisnikId == id),
                BrojPratim = await Context.Pratitelji.CountAsync(p => p.PratiteljId == id),
                BrojFavorita = await Context.Favoriti.CountAsync(f => f.KorisnikId == id),
                BrojLajkovanihFilmova = await Context.FilmoviLajkovi.CountAsync(fl => fl.KorisnikId == id),
                ProsjecnaOcjena = await Context.Recenzije
                    .Where(r => r.KorisnikId == id && !r.IsHidden)
                    .AverageAsync(r => (double?)r.Ocjena) ?? 0
            };

            return stats;
        }

        public async Task<List<Model.Models.Filmovi>> GetFavoriti(int id)
        {
            var filmovi = await Context.Favoriti
                .Include(f => f.Film)
                .Where(f => f.KorisnikId == id)
                .OrderByDescending(f => f.DatumDodavanja)
                .Select(f => f.Film)
                .ToListAsync();

            return Mapper.Map<List<Model.Models.Filmovi>>(filmovi);
        }

        public async Task<List<Model.Models.Filmovi>> GetLajkovi(int id)
        {
            var filmovi = await Context.FilmoviLajkovi
                .Include(fl => fl.Film)
                .Where(fl => fl.KorisnikId == id)
                .OrderByDescending(fl => fl.DatumLajka)
                .Select(fl => fl.Film)
                .ToListAsync();

            return Mapper.Map<List<Model.Models.Filmovi>>(filmovi);
        }

        public async Task<List<Model.Models.Filmovi>> GetNedavnoPogledano(int id)
        {
            var filmovi = await Context.Watchlist
                .Include(w => w.Film)
                .Where(w => w.KorisnikId == id && w.Pogledano == true)
                .OrderByDescending(w => w.DatumGledanja)
                .Select(w => w.Film)
                .ToListAsync();

            return Mapper.Map<List<Model.Models.Filmovi>>(filmovi);
        }

        public async Task<Model.Models.OnboardingResponse> ProcessOnboarding(int korisnikId, Model.Requests.OnboardingRequest request)
        {
            var response = new Model.Models.OnboardingResponse();

            try
            {
                foreach (var tmdbId in request.WatchedTmdbIds)
                {
                    try
                    {
                        var film = await _tmdbService.GetOrImportMovieAsync(tmdbId);

                        var existingWatchlist = await Context.Watchlist
                            .FirstOrDefaultAsync(w => w.KorisnikId == korisnikId && w.FilmId == film.Id);

                        if (existingWatchlist == null)
                        {
                            Context.Watchlist.Add(new Database.Watchlist
                            {
                                KorisnikId = korisnikId,
                                FilmId = film.Id,
                                DatumDodavanja = DateTime.Now,
                                Pogledano = true,
                                DatumGledanja = DateTime.Now
                            });
                            response.MoviesWatched++;
                        }
                    }
                    catch
                    {
                        continue;
                    }
                }

                foreach (var tmdbId in request.LikedTmdbIds)
                {
                    try
                    {
                        var film = await _tmdbService.GetOrImportMovieAsync(tmdbId);

                        var existingLike = await Context.FilmoviLajkovi
                            .FirstOrDefaultAsync(fl => fl.KorisnikId == korisnikId && fl.FilmId == film.Id);

                        if (existingLike == null)
                        {
                            Context.FilmoviLajkovi.Add(new Database.FilmoviLajkovi
                            {
                                KorisnikId = korisnikId,
                                FilmId = film.Id,
                                DatumLajka = DateTime.Now
                            });

                            var dbFilm = await Context.Filmovi.FindAsync(film.Id);
                            if (dbFilm != null)
                            {
                                dbFilm.BrojLajkova = (dbFilm.BrojLajkova ?? 0) + 1;
                            }

                            response.MoviesLiked++;
                        }
                    }
                    catch
                    {
                        continue;
                    }
                }

                foreach (var rating in request.Ratings)
                {
                    try
                    {
                        var film = await _tmdbService.GetOrImportMovieAsync(rating.TmdbId);

                        var existingReview = await Context.Recenzije
                            .FirstOrDefaultAsync(r => r.KorisnikId == korisnikId && r.FilmId == film.Id);

                        if (existingReview == null)
                        {
                            var ocjena = Math.Clamp(rating.Ocjena, 1, 5);

                            Context.Recenzije.Add(new Database.Recenzije
                            {
                                KorisnikId = korisnikId,
                                FilmId = film.Id,
                                Ocjena = ocjena,
                                Naslov = "Onboarding",
                                Sadrzaj = null,
                                ImaSpoiler = false,
                                DatumKreiranja = DateTime.Now
                            });

                            var dbFilm = await Context.Filmovi.FindAsync(film.Id);
                            if (dbFilm != null)
                            {
                                var reviews = await Context.Recenzije
                                    .Where(r => r.FilmId == film.Id && !r.IsHidden)
                                    .ToListAsync();

                                var allRatings = reviews.Select(r => r.Ocjena).Append(ocjena).ToList();
                                dbFilm.ProsjecnaOcjena = allRatings.Average();
                                dbFilm.BrojOcjena = allRatings.Count;
                            }

                            response.ReviewsCreated++;
                        }
                    }
                    catch
                    {
                        continue;
                    }
                }

                await Context.SaveChangesAsync();

                response.Success = true;
                response.Message = $"Uspješno obrađeno: {response.MoviesWatched} pogledanih, {response.MoviesLiked} lajkovanih, {response.ReviewsCreated} ocjenjenih filmova.";
            }
            catch (Exception ex)
            {
                response.Success = false;
                response.Message = $"Greška prilikom obrade: {ex.Message}";
            }

            return response;
        }

        public async Task<bool> ChangePassword(int korisnikId, ChangePasswordRequest request)
        {
            if (request.NewPassword != request.ConfirmPassword)
            {
                throw new UserException("Nova lozinka i potvrda lozinke moraju biti iste.");
            }

            if (string.IsNullOrWhiteSpace(request.NewPassword) || request.NewPassword.Length < 4)
            {
                throw new UserException("Nova lozinka mora imati najmanje 4 karaktera.");
            }

            var entity = await Context.Korisnici.FindAsync(korisnikId);
            if (entity == null)
            {
                throw new UserException("Korisnik ne postoji.");
            }

            var currentHash = StaGledasContext.GenerateHash(entity.LozinkaSalt!, request.CurrentPassword);
            if (currentHash != entity.LozinkaHash)
            {
                throw new UserException("Trenutna lozinka nije ispravna.");
            }

            entity.LozinkaSalt = StaGledasContext.GenerateSalt();
            entity.LozinkaHash = StaGledasContext.GenerateHash(entity.LozinkaSalt, request.NewPassword);
            entity.DatumIzmjene = DateTime.Now;

            await Context.SaveChangesAsync();
            return true;
        }

        public async Task<bool> DeleteAccount(int korisnikId, string password)
        {
            var entity = await Context.Korisnici.FindAsync(korisnikId);
            if (entity == null)
            {
                throw new UserException("Korisnik ne postoji.");
            }

            var hash = StaGledasContext.GenerateHash(entity.LozinkaSalt!, password);
            if (hash != entity.LozinkaHash)
            {
                throw new UserException("Lozinka nije ispravna.");
            }

            entity.IsDeleted = true;
            entity.DatumBrisanja = DateTime.Now;
            entity.Status = false;

            await Context.SaveChangesAsync();
            return true;
        }
    }
}
