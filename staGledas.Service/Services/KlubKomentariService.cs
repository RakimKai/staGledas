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
    public class KlubKomentariService : BaseCRUDService<Model.Models.KlubKomentari, KlubKomentariSearchObject, Database.KlubKomentari, KlubKomentariUpsertRequest, KlubKomentariUpsertRequest>, IKlubKomentariService
    {
        public KlubKomentariService(StaGledasContext dbContext, IMapper mapper) : base(dbContext, mapper)
        {
        }

        public override IQueryable<Database.KlubKomentari> AddFilter(KlubKomentariSearchObject searchObject, IQueryable<Database.KlubKomentari> query)
        {
            var filteredQuery = base.AddFilter(searchObject, query);

            if (searchObject?.ObjavaId.HasValue == true)
            {
                filteredQuery = filteredQuery.Where(x => x.ObjavaId == searchObject.ObjavaId);
            }

            if (searchObject?.KorisnikId.HasValue == true)
            {
                filteredQuery = filteredQuery.Where(x => x.KorisnikId == searchObject.KorisnikId);
            }

            if (searchObject?.ParentKomentarId.HasValue == true)
            {
                filteredQuery = filteredQuery.Where(x => x.ParentKomentarId == searchObject.ParentKomentarId);
            }

            if (searchObject?.IsObjavaIncluded == true)
            {
                filteredQuery = filteredQuery.Include(x => x.Objava);
            }

            if (searchObject?.IsKorisnikIncluded == true)
            {
                filteredQuery = filteredQuery.Include(x => x.Korisnik);
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

        public override void BeforeInsert(KlubKomentariUpsertRequest request, Database.KlubKomentari entity)
        {
            var objava = Context.KlubObjave.Include(o => o.Klub).ThenInclude(k => k.Clanovi).FirstOrDefault(o => o.Id == request.ObjavaId);
            if (objava == null || objava.IsDeleted)
            {
                throw new UserException("Objava ne postoji.");
            }

            if (string.IsNullOrWhiteSpace(request.Sadrzaj))
            {
                throw new UserException("Sadržaj komentara je obavezan.");
            }

            var isMember = objava.Klub?.Clanovi.Any(c => c.KorisnikId == entity.KorisnikId) ?? false;
            if (!isMember)
            {
                throw new UserException("Morate biti član kluba da biste komentarisali.");
            }

            var korisnik = Context.Korisnici.Find(entity.KorisnikId);
            if (korisnik?.IsPremium != true)
            {
                throw new UserException("Samo premium korisnici mogu komentarisati u klubovima.");
            }

            if (request.ParentKomentarId.HasValue)
            {
                var parentKomentar = Context.KlubKomentari.Find(request.ParentKomentarId);
                if (parentKomentar == null)
                {
                    throw new UserException("Parent komentar ne postoji.");
                }
            }

            entity.DatumKreiranja = DateTime.Now;
        }
    }
}
