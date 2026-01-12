using MapsterMapper;
using Microsoft.EntityFrameworkCore;
using staGledas.Model.Exceptions;
using staGledas.Model.Requests;
using staGledas.Model.SearchObject;
using staGledas.Service.Database;
using staGledas.Service.Interfaces;
using System.Linq.Dynamic.Core;

namespace staGledas.Service.Services
{
    public class WatchlistService : BaseCRUDService<Model.Models.Watchlist, WatchlistSearchObject, Database.Watchlist, WatchlistUpsertRequest, WatchlistUpsertRequest>, IWatchlistService
    {
        public WatchlistService(StaGledasContext dbContext, IMapper mapper) : base(dbContext, mapper)
        {
        }

        public override IQueryable<Database.Watchlist> AddFilter(WatchlistSearchObject searchObject, IQueryable<Database.Watchlist> query)
        {
            var filteredQuery = base.AddFilter(searchObject, query);

            if (searchObject?.KorisnikId.HasValue == true)
            {
                filteredQuery = filteredQuery.Where(x => x.KorisnikId == searchObject.KorisnikId);
            }

            if (searchObject?.FilmId.HasValue == true)
            {
                filteredQuery = filteredQuery.Where(x => x.FilmId == searchObject.FilmId);
            }

            if (searchObject?.Pogledano.HasValue == true)
            {
                filteredQuery = filteredQuery.Where(x => x.Pogledano == searchObject.Pogledano);
            }

            if (searchObject?.IsKorisnikIncluded == true)
            {
                filteredQuery = filteredQuery.Include(x => x.Korisnik);
            }

            if (searchObject?.IsFilmIncluded == true)
            {
                filteredQuery = filteredQuery.Include(x => x.Film);
            }

            if (!string.IsNullOrWhiteSpace(searchObject?.OrderBy))
            {
                var items = searchObject.OrderBy.Split(' ');
                if (items.Length == 1)
                {
                    filteredQuery = filteredQuery.OrderBy("@0", searchObject.OrderBy);
                }
                else
                {
                    filteredQuery = filteredQuery.OrderBy(string.Format("{0} {1}", items[0], items[1]));
                }
            }
            else
            {
                filteredQuery = filteredQuery.OrderByDescending(x => x.DatumDodavanja);
            }

            return filteredQuery;
        }

        public override void BeforeInsert(WatchlistUpsertRequest request, Database.Watchlist entity)
        {
            var film = Context.Filmovi.Find(request.FilmId);
            if (film == null)
            {
                throw new UserException("Film ne postoji.");
            }

            entity.DatumDodavanja = DateTime.Now;
            entity.Pogledano = false;
        }

        public override void BeforeUpdate(WatchlistUpsertRequest request, Database.Watchlist entity)
        {
            if (request.Pogledano == true && entity.Pogledano != true)
            {
                entity.DatumGledanja = DateTime.Now;
            }
        }

        public async Task<bool> ToggleWatchlist(int korisnikId, int filmId)
        {
            var filmExists = await Context.Filmovi.AnyAsync(f => f.Id == filmId);
            if (!filmExists)
            {
                throw new UserException("Film ne postoji.");
            }

            var existing = await Context.Watchlist
                .FirstOrDefaultAsync(w => w.KorisnikId == korisnikId && w.FilmId == filmId);

            if (existing == null)
            {
                Context.Watchlist.Add(new Database.Watchlist
                {
                    KorisnikId = korisnikId,
                    FilmId = filmId,
                    DatumDodavanja = DateTime.Now,
                    Pogledano = false
                });
                await Context.SaveChangesAsync();
                return true;
            }
            else if (existing.Pogledano == false)
            {
                Context.Watchlist.Remove(existing);
                await Context.SaveChangesAsync();
                return false;
            }
            else
            {
                existing.Pogledano = false;
                existing.DatumGledanja = null;
                await Context.SaveChangesAsync();
                return true;
            }
        }

        public async Task<bool> IsInWatchlist(int korisnikId, int filmId)
        {
            return await Context.Watchlist
                .AnyAsync(w => w.KorisnikId == korisnikId && w.FilmId == filmId && w.Pogledano == false);
        }

        public async Task<bool> MarkAsWatched(int korisnikId, int filmId)
        {
            var filmExists = await Context.Filmovi.AnyAsync(f => f.Id == filmId);
            if (!filmExists)
            {
                throw new UserException("Film ne postoji.");
            }

            var existing = await Context.Watchlist
                .FirstOrDefaultAsync(w => w.KorisnikId == korisnikId && w.FilmId == filmId);

            if (existing == null)
            {
                Context.Watchlist.Add(new Database.Watchlist
                {
                    KorisnikId = korisnikId,
                    FilmId = filmId,
                    DatumDodavanja = DateTime.Now,
                    Pogledano = true,
                    DatumGledanja = DateTime.Now
                });
                await Context.SaveChangesAsync();
                return true;
            }
            else if (existing.Pogledano == true)
            {
                Context.Watchlist.Remove(existing);
                await Context.SaveChangesAsync();
                return false;
            }
            else
            {
                existing.Pogledano = true;
                existing.DatumGledanja = DateTime.Now;
                await Context.SaveChangesAsync();
                return true;
            }
        }

        public async Task<bool> IsWatched(int korisnikId, int filmId)
        {
            return await Context.Watchlist
                .AnyAsync(w => w.KorisnikId == korisnikId && w.FilmId == filmId && w.Pogledano == true);
        }
    }
}
