using MapsterMapper;
using Microsoft.EntityFrameworkCore;
using staGledas.Model.Exceptions;
using staGledas.Model.Requests;
using staGledas.Model.SearchObject;
using staGledas.Service.Database;
using staGledas.Service.Interfaces;
using staGledas.Service.ZalbeStateMachine;
using System.Linq.Dynamic.Core;

namespace staGledas.Service.Services
{
    public class ZalbeService : BaseCRUDService<Model.Models.Zalbe, ZalbeSearchObject, Database.Zalbe, ZalbeInsertRequest, ZalbeUpdateRequest>, IZalbeService
    {
        public BaseZalbeState BaseState { get; set; }

        public ZalbeService(StaGledasContext dbContext, IMapper mapper, BaseZalbeState baseState) : base(dbContext, mapper)
        {
            BaseState = baseState;
        }

        public override Model.Models.Zalbe MapToModel(Database.Zalbe entity)
        {
            var model = Mapper.Map<Model.Models.Zalbe>(entity);

            if (entity.KorisnikId > 0 && model.Korisnik == null)
            {
                var korisnik = Context.Korisnici
                    .Where(k => k.Id == entity.KorisnikId)
                    .Select(k => new { k.Id, k.Ime, k.Prezime, k.KorisnickoIme, k.Email })
                    .FirstOrDefault();

                if (korisnik != null)
                {
                    model.Korisnik = new Model.Models.Korisnici
                    {
                        Id = korisnik.Id,
                        Ime = korisnik.Ime,
                        Prezime = korisnik.Prezime,
                        KorisnickoIme = korisnik.KorisnickoIme,
                        Email = korisnik.Email
                    };
                }
            }

            return model;
        }

        public override IQueryable<Database.Zalbe> AddFilter(ZalbeSearchObject searchObject, IQueryable<Database.Zalbe> query)
        {
            var filteredQuery = base.AddFilter(searchObject, query);

            if (searchObject?.RecenzijaId.HasValue == true)
            {
                filteredQuery = filteredQuery.Where(x => x.RecenzijaId == searchObject.RecenzijaId);
            }

            if (searchObject?.KorisnikId.HasValue == true)
            {
                filteredQuery = filteredQuery.Where(x => x.KorisnikId == searchObject.KorisnikId);
            }

            if (!string.IsNullOrWhiteSpace(searchObject?.Status))
            {
                filteredQuery = filteredQuery.Where(x => x.Status == searchObject.Status);
            }

            if (!string.IsNullOrWhiteSpace(searchObject?.Razlog))
            {
                filteredQuery = filteredQuery.Where(x => x.Razlog != null && x.Razlog.ToLower().Contains(searchObject.Razlog.ToLower()));
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

        public Model.Models.Zalbe Insert(ZalbeInsertRequest request, int korisnikId)
        {
            var state = BaseState.CreateState("initial");
            return state.Insert(request, korisnikId);
        }

        public Model.Models.Zalbe Approve(int id, int adminId)
        {
            var entity = Context.Zalbe.Find(id);
            if (entity == null)
            {
                throw new UserException("Zalba ne postoji.");
            }

            var state = BaseState.CreateState(entity.Status);
            return state.Approve(id, adminId);
        }

        public Model.Models.Zalbe Reject(int id, int adminId)
        {
            var entity = Context.Zalbe.Find(id);
            if (entity == null)
            {
                throw new UserException("Zalba ne postoji.");
            }

            var state = BaseState.CreateState(entity.Status);
            return state.Reject(id, adminId);
        }

        public List<string> AllowedActions(int id)
        {
            if (id <= 0)
            {
                var state = BaseState.CreateState("initial");
                return state.AllowedActions(null);
            }
            else
            {
                var entity = Context.Zalbe.Find(id);
                if (entity == null)
                {
                    return new List<string>();
                }
                var state = BaseState.CreateState(entity.Status);
                return state.AllowedActions(entity);
            }
        }
    }
}
