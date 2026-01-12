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
    public class KlubObjaveService : BaseCRUDService<Model.Models.KlubObjave, KlubObjaveSearchObject, Database.KlubObjave, KlubObjaveUpsertRequest, KlubObjaveUpsertRequest>, IKlubObjaveService
    {
        public KlubObjaveService(StaGledasContext dbContext, IMapper mapper) : base(dbContext, mapper)
        {
        }

        public override IQueryable<Database.KlubObjave> AddFilter(KlubObjaveSearchObject searchObject, IQueryable<Database.KlubObjave> query)
        {
            var filteredQuery = base.AddFilter(searchObject, query);

            if (searchObject?.IncludeDeleted != true)
            {
                filteredQuery = filteredQuery.Where(x => !x.IsDeleted);
            }

            if (searchObject?.KlubId.HasValue == true)
            {
                filteredQuery = filteredQuery.Where(x => x.KlubId == searchObject.KlubId);
            }

            if (searchObject?.KorisnikId.HasValue == true)
            {
                filteredQuery = filteredQuery.Where(x => x.KorisnikId == searchObject.KorisnikId);
            }

            if (searchObject?.IsKlubIncluded == true)
            {
                filteredQuery = filteredQuery.Include(x => x.Klub);
            }

            if (searchObject?.IsKorisnikIncluded == true)
            {
                filteredQuery = filteredQuery.Include(x => x.Korisnik);
            }

            filteredQuery = filteredQuery
                .Include(x => x.Komentari)
                .Include(x => x.Lajkovi);

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

        public override void BeforeInsert(KlubObjaveUpsertRequest request, Database.KlubObjave entity)
        {
            var klub = Context.KlubFilmova.Include(k => k.Clanovi).FirstOrDefault(k => k.Id == request.KlubId);
            if (klub == null)
            {
                throw new UserException("Klub ne postoji.");
            }

            if (string.IsNullOrWhiteSpace(request.Sadrzaj))
            {
                throw new UserException("Sadržaj objave je obavezan.");
            }

            var isMember = klub.Clanovi.Any(c => c.KorisnikId == entity.KorisnikId);
            if (!isMember)
            {
                throw new UserException("Morate biti član kluba da biste objavljivali.");
            }

            var korisnik = Context.Korisnici.Find(entity.KorisnikId);
            if (korisnik?.IsPremium != true)
            {
                throw new UserException("Samo premium korisnici mogu objavljivati u klubovima.");
            }

            entity.DatumKreiranja = DateTime.Now;
        }

        public override void BeforeUpdate(KlubObjaveUpsertRequest request, Database.KlubObjave entity)
        {
            if (string.IsNullOrWhiteSpace(request.Sadrzaj))
            {
                throw new UserException("Sadržaj objave je obavezan.");
            }

            entity.DatumIzmjene = DateTime.Now;
        }

        public override Model.Models.KlubObjave Delete(int id)
        {
            var entity = Context.KlubObjave.Find(id);

            if (entity != null)
            {
                entity.IsDeleted = true;
                entity.DatumBrisanja = DateTime.Now;
                Context.SaveChanges();
            }

            return Mapper.Map<Model.Models.KlubObjave>(entity);
        }
    }
}
