using MapsterMapper;
using Microsoft.EntityFrameworkCore;
using staGledas.Model.SearchObject;
using staGledas.Service.Database;
using staGledas.Service.Interfaces;
using System.Linq.Dynamic.Core;

namespace staGledas.Service.Services
{
    public class FilmoviLajkoviService : BaseService<Model.Models.FilmoviLajkovi, FilmoviLajkoviSearchObject, Database.FilmoviLajkovi>, IFilmoviLajkoviService
    {
        public FilmoviLajkoviService(StaGledasContext dbContext, IMapper mapper) : base(dbContext, mapper)
        {
        }

        public override IQueryable<Database.FilmoviLajkovi> AddFilter(FilmoviLajkoviSearchObject searchObject, IQueryable<Database.FilmoviLajkovi> query)
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
                filteredQuery = filteredQuery.OrderByDescending(x => x.DatumLajka);
            }

            return filteredQuery;
        }

        public async Task<bool> ToggleLike(int korisnikId, int filmId)
        {
            var existing = await Context.FilmoviLajkovi
                .FirstOrDefaultAsync(fl => fl.KorisnikId == korisnikId && fl.FilmId == filmId);

            if (existing != null)
            {
                Context.FilmoviLajkovi.Remove(existing);
                await UpdateFilmLikeCount(filmId, -1);
                await Context.SaveChangesAsync();
                return false;
            }
            else
            {
                var lajk = new Database.FilmoviLajkovi
                {
                    KorisnikId = korisnikId,
                    FilmId = filmId,
                    DatumLajka = DateTime.Now
                };
                Context.FilmoviLajkovi.Add(lajk);
                await UpdateFilmLikeCount(filmId, 1);
                await Context.SaveChangesAsync();
                return true;
            }
        }

        public async Task<bool> IsLiked(int korisnikId, int filmId)
        {
            return await Context.FilmoviLajkovi
                .AnyAsync(fl => fl.KorisnikId == korisnikId && fl.FilmId == filmId);
        }

        public async Task<int> GetLikeCount(int filmId)
        {
            return await Context.FilmoviLajkovi.CountAsync(fl => fl.FilmId == filmId);
        }

        private async Task UpdateFilmLikeCount(int filmId, int delta)
        {
            var film = await Context.Filmovi.FindAsync(filmId);
            if (film != null)
            {
                film.BrojLajkova = (film.BrojLajkova ?? 0) + delta;
                if (film.BrojLajkova < 0) film.BrojLajkova = 0;
            }
        }
    }
}
