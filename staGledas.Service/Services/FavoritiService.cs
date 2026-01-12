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
    public class FavoritiService : BaseCRUDService<Model.Models.Favoriti, FavoritiSearchObject, Database.Favoriti, FavoritiUpsertRequest, FavoritiUpsertRequest>, IFavoritiService
    {
        public FavoritiService(StaGledasContext dbContext, IMapper mapper) : base(dbContext, mapper)
        {
        }

        public override IQueryable<Database.Favoriti> AddFilter(FavoritiSearchObject searchObject, IQueryable<Database.Favoriti> query)
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
                filteredQuery = filteredQuery.OrderByDescending(x => x.DatumDodavanja);
            }

            return filteredQuery;
        }

        public override void BeforeInsert(FavoritiUpsertRequest request, Database.Favoriti entity)
        {
            var film = Context.Filmovi.Find(request.FilmId);
            if (film == null)
            {
                throw new UserException("Film ne postoji.");
            }

            entity.DatumDodavanja = DateTime.Now;
        }

        public async Task<bool> ToggleFavorit(int korisnikId, int filmId)
        {
            var existing = await Context.Favoriti
                .FirstOrDefaultAsync(f => f.KorisnikId == korisnikId && f.FilmId == filmId);

            if (existing != null)
            {
                Context.Favoriti.Remove(existing);
                await Context.SaveChangesAsync();
                return false;
            }
            else
            {
                var favorit = new Database.Favoriti
                {
                    KorisnikId = korisnikId,
                    FilmId = filmId,
                    DatumDodavanja = DateTime.Now
                };
                Context.Favoriti.Add(favorit);
                await Context.SaveChangesAsync();
                return true;
            }
        }

        public async Task<bool> IsFavorit(int korisnikId, int filmId)
        {
            return await Context.Favoriti
                .AnyAsync(f => f.KorisnikId == korisnikId && f.FilmId == filmId);
        }
    }
}
