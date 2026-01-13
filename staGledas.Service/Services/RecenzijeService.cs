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
    public class RecenzijeService : BaseCRUDService<Model.Models.Recenzije, RecenzijeSearchObject, Database.Recenzije, RecenzijeUpsertRequest, RecenzijeUpsertRequest>, IRecenzijeService
    {
        public RecenzijeService(StaGledasContext dbContext, IMapper mapper) : base(dbContext, mapper)
        {
        }

        public override Model.Models.Recenzije MapToModel(Database.Recenzije entity)
        {
            var model = base.MapToModel(entity);

            if (entity.Korisnik != null)
            {
                model.Username = entity.Korisnik.KorisnickoIme;
                model.KorisnikSlika = entity.Korisnik.Slika;
            }

            if (entity.Film != null)
            {
                model.FilmNaslov = entity.Film.Naslov;
                model.FilmPosterPath = entity.Film.PosterPath;
            }

            return model;
        }

        public override IQueryable<Database.Recenzije> AddFilter(RecenzijeSearchObject searchObject, IQueryable<Database.Recenzije> query)
        {
            IQueryable<Database.Recenzije> filteredQuery = base.AddFilter(searchObject, query)
                .Include(x => x.Film)
                .Include(x => x.Korisnik);

            if (searchObject?.IncludeHidden != true)
            {
                filteredQuery = filteredQuery.Where(x => !x.IsHidden);
            }

            if (!string.IsNullOrWhiteSpace(searchObject?.SearchText))
            {
                var searchLower = searchObject.SearchText.ToLower();
                filteredQuery = filteredQuery.Where(x =>
                    (x.Korisnik != null && x.Korisnik.KorisnickoIme != null && x.Korisnik.KorisnickoIme.ToLower().Contains(searchLower)) ||
                    (x.Film != null && x.Film.Naslov != null && x.Film.Naslov.ToLower().Contains(searchLower))
                );
            }

            if (searchObject?.KorisnikId.HasValue == true)
            {
                filteredQuery = filteredQuery.Where(x => x.KorisnikId == searchObject.KorisnikId);
            }

            if (searchObject?.FilmId.HasValue == true)
            {
                filteredQuery = filteredQuery.Where(x => x.FilmId == searchObject.FilmId);
            }

            if (searchObject?.MinOcjena.HasValue == true)
            {
                filteredQuery = filteredQuery.Where(x => x.Ocjena >= searchObject.MinOcjena);
            }

            if (searchObject?.MaxOcjena.HasValue == true)
            {
                filteredQuery = filteredQuery.Where(x => x.Ocjena <= searchObject.MaxOcjena);
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
                filteredQuery = filteredQuery.OrderByDescending(x => x.DatumKreiranja);
            }

            return filteredQuery;
        }

        public override void BeforeInsert(RecenzijeUpsertRequest request, Database.Recenzije entity)
        {
            if (request.Ocjena < 1 || request.Ocjena > 5 || (request.Ocjena * 2) % 1 != 0)
            {
                throw new UserException("Ocjena mora biti između 1 i 5, u koracima od 0.5.");
            }

            var film = Context.Filmovi.Find(request.FilmId);
            if (film == null)
            {
                throw new UserException("Film ne postoji.");
            }

            entity.DatumKreiranja = DateTime.Now;
        }

        public override void AfterInsert(Database.Recenzije entity, RecenzijeUpsertRequest request)
        {
            UpdateFilmRating(entity.FilmId);
        }

        public override void BeforeUpdate(RecenzijeUpsertRequest request, Database.Recenzije entity)
        {
            if (request.Ocjena < 1 || request.Ocjena > 5 || (request.Ocjena * 2) % 1 != 0)
            {
                throw new UserException("Ocjena mora biti između 1 i 5, u koracima od 0.5.");
            }
            entity.DatumIzmjene = DateTime.Now;
        }

        public override void BeforeDelete(Database.Recenzije entity)
        {
            var filmId = entity.FilmId;
            base.BeforeDelete(entity);
        }

        private void UpdateFilmRating(int filmId)
        {
            var film = Context.Filmovi.Find(filmId);
            if (film != null)
            {
                var recenzije = Context.Recenzije.Where(r => r.FilmId == filmId && !r.IsHidden).ToList();
                if (recenzije.Any())
                {
                    film.ProsjecnaOcjena = recenzije.Average(r => r.Ocjena);
                    film.BrojOcjena = recenzije.Count;
                }
                else
                {
                    film.ProsjecnaOcjena = 0;
                    film.BrojOcjena = 0;
                }
                Context.SaveChanges();
            }
        }
    }
}
