using MapsterMapper;
using Microsoft.EntityFrameworkCore;
using staGledas.Model.SearchObject;
using staGledas.Service.Database;
using staGledas.Service.Interfaces;
using System.Linq.Dynamic.Core;

namespace staGledas.Service.Services
{
    public class KlubLajkoviService : BaseService<Model.Models.KlubLajkovi, KlubLajkoviSearchObject, Database.KlubLajkovi>, IKlubLajkoviService
    {
        public KlubLajkoviService(StaGledasContext dbContext, IMapper mapper) : base(dbContext, mapper)
        {
        }

        public override IQueryable<Database.KlubLajkovi> AddFilter(KlubLajkoviSearchObject searchObject, IQueryable<Database.KlubLajkovi> query)
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
                filteredQuery = filteredQuery.OrderByDescending(x => x.DatumLajka);
            }

            return filteredQuery;
        }

        public async Task<bool> ToggleLike(int korisnikId, int objavaId)
        {
            var existing = await Context.KlubLajkovi
                .FirstOrDefaultAsync(kl => kl.KorisnikId == korisnikId && kl.ObjavaId == objavaId);

            if (existing != null)
            {
                Context.KlubLajkovi.Remove(existing);
                await Context.SaveChangesAsync();
                return false;
            }
            else
            {
                var lajk = new Database.KlubLajkovi
                {
                    KorisnikId = korisnikId,
                    ObjavaId = objavaId,
                    DatumLajka = DateTime.Now
                };
                Context.KlubLajkovi.Add(lajk);
                await Context.SaveChangesAsync();
                return true;
            }
        }

        public async Task<bool> IsLiked(int korisnikId, int objavaId)
        {
            return await Context.KlubLajkovi
                .AnyAsync(kl => kl.KorisnikId == korisnikId && kl.ObjavaId == objavaId);
        }

        public async Task<int> GetLikeCount(int objavaId)
        {
            return await Context.KlubLajkovi.CountAsync(kl => kl.ObjavaId == objavaId);
        }
    }
}
