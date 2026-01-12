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
    public class KlubFilmovaService : BaseCRUDService<Model.Models.KlubFilmova, KlubFilmovaSearchObject, Database.KlubFilmova, KlubFilmovaInsertRequest, KlubFilmovaUpdateRequest>, IKlubFilmovaService
    {
        private readonly IChatNotificationService _chatNotificationService;

        public KlubFilmovaService(StaGledasContext dbContext, IMapper mapper, IChatNotificationService chatNotificationService) : base(dbContext, mapper)
        {
            _chatNotificationService = chatNotificationService;
        }

        public override IQueryable<Database.KlubFilmova> AddFilter(KlubFilmovaSearchObject searchObject, IQueryable<Database.KlubFilmova> query)
        {
            var filteredQuery = base.AddFilter(searchObject, query);

            if (!string.IsNullOrWhiteSpace(searchObject?.NazivGTE))
            {
                filteredQuery = filteredQuery.Where(x => x.Naziv != null && x.Naziv.ToLower().Contains(searchObject.NazivGTE.ToLower()));
            }

            if (searchObject?.VlasnikId.HasValue == true)
            {
                filteredQuery = filteredQuery.Where(x => x.VlasnikId == searchObject.VlasnikId);
            }

            if (searchObject?.IsPrivate.HasValue == true)
            {
                filteredQuery = filteredQuery.Where(x => x.IsPrivate == searchObject.IsPrivate);
            }

            if (searchObject?.KorisnikJeClan.HasValue == true)
            {
                filteredQuery = filteredQuery.Where(x => x.Clanovi.Any(c => c.KorisnikId == searchObject.KorisnikJeClan));
            }

            if (searchObject?.IsVlasnikIncluded == true)
            {
                filteredQuery = filteredQuery.Include(x => x.Vlasnik);
            }

            if (searchObject?.IsClanoviIncluded == true)
            {
                filteredQuery = filteredQuery.Include(x => x.Clanovi).ThenInclude(c => c.Korisnik);
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

        public override void BeforeInsert(KlubFilmovaInsertRequest request, Database.KlubFilmova entity)
        {
            if (string.IsNullOrWhiteSpace(request.Naziv))
            {
                throw new UserException("Naziv kluba je obavezan.");
            }

            var vlasnik = Context.Korisnici.Find(entity.VlasnikId);
            if (vlasnik == null)
            {
                throw new UserException("Korisnik ne postoji.");
            }

            if (vlasnik.IsPremium != true)
            {
                throw new UserException("Samo premium korisnici mogu kreirati klubove.");
            }

            entity.DatumKreiranja = DateTime.Now;
        }

        public override void AfterInsert(Database.KlubFilmova entity, KlubFilmovaInsertRequest request)
        {
            Context.KlubFilmovaClanovi.Add(new Database.KlubFilmovaClanovi
            {
                KlubId = entity.Id,
                KorisnikId = entity.VlasnikId,
                Uloga = "owner",
                DatumPridruzivanja = DateTime.Now
            });
            Context.SaveChanges();
        }

        public Model.Models.KlubFilmova Join(int klubId, int korisnikId)
        {
            var klub = Context.KlubFilmova.Include(k => k.Clanovi).FirstOrDefault(k => k.Id == klubId);
            if (klub == null)
            {
                throw new UserException("Klub ne postoji.");
            }

            var korisnik = Context.Korisnici.Find(korisnikId);
            if (korisnik == null)
            {
                throw new UserException("Korisnik ne postoji.");
            }

            if (korisnik.IsPremium != true)
            {
                throw new UserException("Samo premium korisnici mogu pristupiti klubovima.");
            }

            if (klub.Clanovi.Any(c => c.KorisnikId == korisnikId))
            {
                throw new UserException("Već ste član ovog kluba.");
            }

            if (klub.MaxClanova.HasValue && klub.Clanovi.Count >= klub.MaxClanova)
            {
                throw new UserException("Klub je popunjen.");
            }

            var existingRequest = Context.Obavijesti.FirstOrDefault(o =>
                o.Tip == "club_join_request" &&
                o.KlubId == klubId &&
                o.PosiljateljId == korisnikId &&
                o.Status == "pending");

            if (existingRequest != null)
            {
                throw new UserException("Već ste poslali zahtjev za pridruživanje. Pričekajte odobrenje vlasnika.");
            }

            var notification = new Database.Obavijesti
            {
                Tip = "club_join_request",
                PosiljateljId = korisnikId,
                PrimateljId = klub.VlasnikId,
                KlubId = klubId,
                Poruka = $"{korisnik.Ime} {korisnik.Prezime} želi se pridružiti vašem klubu '{klub.Naziv}'.",
                Status = "pending",
                Procitano = false,
                DatumKreiranja = DateTime.Now
            };
            Context.Obavijesti.Add(notification);
            Context.SaveChanges();

            notification.Posiljatelj = korisnik;
            notification.Klub = klub;

            _ = _chatNotificationService.NotifyNewNotification(Mapper.Map<Model.Models.Obavijesti>(notification));

            return Mapper.Map<Model.Models.KlubFilmova>(klub);
        }

        public Model.Models.KlubFilmova Leave(int klubId, int korisnikId)
        {
            var klub = Context.KlubFilmova
                .Include(k => k.Clanovi)
                .Include(k => k.Objave)
                .FirstOrDefault(k => k.Id == klubId);
            if (klub == null)
            {
                throw new UserException("Klub ne postoji.");
            }

            var membership = klub.Clanovi.FirstOrDefault(c => c.KorisnikId == korisnikId);
            if (membership == null)
            {
                throw new UserException("Niste član ovog kluba.");
            }

            if (membership.Uloga == "owner" || klub.VlasnikId == korisnikId)
            {
                DeleteClub(klubId, korisnikId);
                return null!;
            }

            Context.KlubFilmovaClanovi.Remove(membership);
            Context.SaveChanges();

            return Mapper.Map<Model.Models.KlubFilmova>(klub);
        }

        public void DeleteClub(int klubId, int korisnikId)
        {
            var klub = Context.KlubFilmova
                .Include(k => k.Clanovi)
                .Include(k => k.Objave).ThenInclude(o => o.Komentari)
                .Include(k => k.Objave).ThenInclude(o => o.Lajkovi)
                .FirstOrDefault(k => k.Id == klubId);

            if (klub == null)
            {
                throw new UserException("Klub ne postoji.");
            }

            if (klub.VlasnikId != korisnikId)
            {
                throw new UserException("Samo vlasnik može obrisati klub.");
            }

            var notifications = Context.Obavijesti.Where(o => o.KlubId == klubId).ToList();
            Context.Obavijesti.RemoveRange(notifications);

            foreach (var post in klub.Objave)
            {
                Context.KlubKomentari.RemoveRange(post.Komentari);
                Context.KlubLajkovi.RemoveRange(post.Lajkovi);
            }

            Context.KlubObjave.RemoveRange(klub.Objave);

            Context.KlubFilmovaClanovi.RemoveRange(klub.Clanovi);

            Context.KlubFilmova.Remove(klub);
            Context.SaveChanges();
        }

        public void KickMember(int klubId, int memberId, int ownerId)
        {
            var klub = Context.KlubFilmova.Include(k => k.Clanovi).FirstOrDefault(k => k.Id == klubId);
            if (klub == null)
            {
                throw new UserException("Klub ne postoji.");
            }

            if (klub.VlasnikId != ownerId)
            {
                throw new UserException("Samo vlasnik može ukloniti članove.");
            }

            if (memberId == ownerId)
            {
                throw new UserException("Ne možete ukloniti sebe. Koristite opciju napusti klub.");
            }

            var membership = klub.Clanovi.FirstOrDefault(c => c.KorisnikId == memberId);
            if (membership == null)
            {
                throw new UserException("Korisnik nije član kluba.");
            }

            Context.KlubFilmovaClanovi.Remove(membership);

            var owner = Context.Korisnici.Find(ownerId);
            var notification = new Database.Obavijesti
            {
                Tip = "club_kicked",
                PosiljateljId = ownerId,
                PrimateljId = memberId,
                KlubId = klubId,
                Poruka = $"Uklonjeni ste iz kluba '{klub.Naziv}'.",
                Status = "info",
                Procitano = false,
                DatumKreiranja = DateTime.Now
            };
            Context.Obavijesti.Add(notification);
            Context.SaveChanges();

            notification.Posiljatelj = owner;
            notification.Klub = klub;

            _ = _chatNotificationService.NotifyNewNotification(Mapper.Map<Model.Models.Obavijesti>(notification));
        }

        public List<Model.Models.KlubFilmovaClanovi> GetMembers(int klubId)
        {
            var members = Context.KlubFilmovaClanovi
                .Include(c => c.Korisnik)
                .Where(c => c.KlubId == klubId)
                .OrderBy(c => c.DatumPridruzivanja)
                .ToList();

            return Mapper.Map<List<Model.Models.KlubFilmovaClanovi>>(members);
        }

        public override Model.Models.KlubFilmova GetById(int id)
        {
            var entity = Context.KlubFilmova
                .Include(k => k.Vlasnik)
                .Include(k => k.Clanovi)
                .ThenInclude(c => c.Korisnik)
                .FirstOrDefault(k => k.Id == id);

            var result = Mapper.Map<Model.Models.KlubFilmova>(entity);
            if (result != null && entity != null)
            {
                result.BrojClanova = entity.Clanovi.Count;
            }
            return result!;
        }
    }
}
