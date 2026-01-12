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
    public class PratiteljiService : BaseCRUDService<Model.Models.Pratitelji, PratiteljiSearchObject, Database.Pratitelji, PratiteljiInsertRequest, PratiteljiInsertRequest>, IPratiteljiService
    {
        private readonly IChatNotificationService _chatNotificationService;

        public PratiteljiService(StaGledasContext dbContext, IMapper mapper, IChatNotificationService chatNotificationService) : base(dbContext, mapper)
        {
            _chatNotificationService = chatNotificationService;
        }

        public override IQueryable<Database.Pratitelji> AddFilter(PratiteljiSearchObject searchObject, IQueryable<Database.Pratitelji> query)
        {
            var filteredQuery = base.AddFilter(searchObject, query);

            if (searchObject?.KorisnikId.HasValue == true)
            {
                filteredQuery = filteredQuery.Where(x => x.KorisnikId == searchObject.KorisnikId);
            }

            if (searchObject?.PratiteljId.HasValue == true)
            {
                filteredQuery = filteredQuery.Where(x => x.PratiteljId == searchObject.PratiteljId);
            }

            if (searchObject?.IsKorisnikIncluded == true)
            {
                filteredQuery = filteredQuery.Include(x => x.Korisnik);
            }

            if (searchObject?.IsPratiteljIncluded == true)
            {
                filteredQuery = filteredQuery.Include(x => x.Pratitelj);
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
                filteredQuery = filteredQuery.OrderByDescending(x => x.DatumPracenja);
            }

            return filteredQuery;
        }

        public override void BeforeInsert(PratiteljiInsertRequest request, Database.Pratitelji entity)
        {
            var korisnik = Context.Korisnici.Find(request.KorisnikId);
            if (korisnik == null)
            {
                throw new UserException("Korisnik ne postoji.");
            }

            var existingFollow = Context.Pratitelji
                .FirstOrDefault(p => p.KorisnikId == request.KorisnikId && p.PratiteljId == entity.PratiteljId);

            if (existingFollow != null)
            {
                throw new UserException("Već pratite ovog korisnika.");
            }

            entity.DatumPracenja = DateTime.Now;
        }

        public Model.Models.Pratitelji Insert(PratiteljiInsertRequest request, int pratiteljId)
        {
            var entity = new Database.Pratitelji
            {
                KorisnikId = request.KorisnikId,
                PratiteljId = pratiteljId,
                DatumPracenja = DateTime.Now
            };

            var korisnik = Context.Korisnici.Find(request.KorisnikId);
            if (korisnik == null)
            {
                throw new UserException("Korisnik ne postoji.");
            }

            var existingFollow = Context.Pratitelji
                .FirstOrDefault(p => p.KorisnikId == request.KorisnikId && p.PratiteljId == pratiteljId);

            if (existingFollow != null)
            {
                throw new UserException("Već pratite ovog korisnika.");
            }

            if (request.KorisnikId == pratiteljId)
            {
                throw new UserException("Ne možete pratiti sami sebe.");
            }

            Context.Pratitelji.Add(entity);
            Context.SaveChanges();

            var follower = Context.Korisnici.Find(pratiteljId);
            var notification = new Database.Obavijesti
            {
                Tip = "new_follower",
                PosiljateljId = pratiteljId,
                PrimateljId = request.KorisnikId,
                Poruka = $"{follower?.Ime} {follower?.Prezime} vas sada prati.",
                Status = "info",
                Procitano = false,
                DatumKreiranja = DateTime.Now
            };
            Context.Obavijesti.Add(notification);
            Context.SaveChanges();

            notification.Posiljatelj = follower;

            _ = _chatNotificationService.NotifyNewNotification(Mapper.Map<Model.Models.Obavijesti>(notification));

            return Mapper.Map<Model.Models.Pratitelji>(entity);
        }
    }
}
