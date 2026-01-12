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
    public class ObavijestiService : BaseService<Model.Models.Obavijesti, ObavijestiSearchObject, Database.Obavijesti>, IObavijestiService
    {
        private readonly IChatNotificationService _chatNotificationService;

        public ObavijestiService(StaGledasContext dbContext, IMapper mapper, IChatNotificationService chatNotificationService) : base(dbContext, mapper)
        {
            _chatNotificationService = chatNotificationService;
        }

        public override IQueryable<Database.Obavijesti> AddFilter(ObavijestiSearchObject searchObject, IQueryable<Database.Obavijesti> query)
        {
            var filteredQuery = base.AddFilter(searchObject, query);

            if (searchObject?.PrimateljId.HasValue == true)
            {
                filteredQuery = filteredQuery.Where(x => x.PrimateljId == searchObject.PrimateljId);
            }

            if (searchObject?.PosiljateljId.HasValue == true)
            {
                filteredQuery = filteredQuery.Where(x => x.PosiljateljId == searchObject.PosiljateljId);
            }

            if (!string.IsNullOrWhiteSpace(searchObject?.Tip))
            {
                filteredQuery = filteredQuery.Where(x => x.Tip == searchObject.Tip);
            }

            if (!string.IsNullOrWhiteSpace(searchObject?.Status))
            {
                filteredQuery = filteredQuery.Where(x => x.Status == searchObject.Status);
            }

            if (searchObject?.Procitano.HasValue == true)
            {
                filteredQuery = filteredQuery.Where(x => x.Procitano == searchObject.Procitano);
            }

            if (searchObject?.KlubId.HasValue == true)
            {
                filteredQuery = filteredQuery.Where(x => x.KlubId == searchObject.KlubId);
            }

            if (searchObject?.IsPosiljateljIncluded == true)
            {
                filteredQuery = filteredQuery.Include(x => x.Posiljatelj);
            }

            if (searchObject?.IsKlubIncluded == true)
            {
                filteredQuery = filteredQuery.Include(x => x.Klub);
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

        public Model.Models.Obavijesti Insert(ObavijestiInsertRequest request)
        {
            var entity = new Database.Obavijesti
            {
                Tip = request.Tip,
                PosiljateljId = request.PosiljateljId,
                PrimateljId = request.PrimateljId,
                KlubId = request.KlubId,
                Poruka = request.Poruka,
                Status = "pending",
                Procitano = false,
                DatumKreiranja = DateTime.Now
            };

            Context.Obavijesti.Add(entity);
            Context.SaveChanges();

            return Mapper.Map<Model.Models.Obavijesti>(entity);
        }

        public Model.Models.Obavijesti Approve(int id, int approvedById)
        {
            var entity = Context.Obavijesti
                .Include(o => o.Klub)
                .FirstOrDefault(o => o.Id == id);

            if (entity == null)
            {
                throw new UserException("Obavijest ne postoji.");
            }

            if (entity.Status != "pending")
            {
                throw new UserException("Zahtjev je već obrađen.");
            }

            if (entity.Tip == "club_join_request" && entity.KlubId.HasValue)
            {
                var klub = Context.KlubFilmova.Include(k => k.Clanovi).FirstOrDefault(k => k.Id == entity.KlubId);
                if (klub == null)
                {
                    throw new UserException("Klub ne postoji.");
                }

                if (klub.VlasnikId != approvedById)
                {
                    throw new UserException("Samo vlasnik kluba može odobriti zahtjev.");
                }

                if (!klub.Clanovi.Any(c => c.KorisnikId == entity.PosiljateljId))
                {
                    Context.KlubFilmovaClanovi.Add(new Database.KlubFilmovaClanovi
                    {
                        KlubId = entity.KlubId.Value,
                        KorisnikId = entity.PosiljateljId,
                        Uloga = "member",
                        DatumPridruzivanja = DateTime.Now
                    });
                }

                var approver = Context.Korisnici.Find(approvedById);
                var approvedNotification = new Database.Obavijesti
                {
                    Tip = "club_join_approved",
                    PosiljateljId = approvedById,
                    PrimateljId = entity.PosiljateljId,
                    KlubId = entity.KlubId,
                    Poruka = $"Vaš zahtjev za pridruživanje klubu '{klub.Naziv}' je odobren!",
                    Status = "info",
                    Procitano = false,
                    DatumKreiranja = DateTime.Now
                };
                Context.Obavijesti.Add(approvedNotification);

                entity.Status = "approved";
                entity.DatumObrade = DateTime.Now;
                Context.SaveChanges();

                approvedNotification.Posiljatelj = approver;
                approvedNotification.Klub = klub;

                _ = _chatNotificationService.NotifyNewNotification(Mapper.Map<Model.Models.Obavijesti>(approvedNotification));
            }

            return Mapper.Map<Model.Models.Obavijesti>(entity);
        }

        public Model.Models.Obavijesti Reject(int id, int rejectedById)
        {
            var entity = Context.Obavijesti
                .Include(o => o.Klub)
                .FirstOrDefault(o => o.Id == id);

            if (entity == null)
            {
                throw new UserException("Obavijest ne postoji.");
            }

            if (entity.Status != "pending")
            {
                throw new UserException("Zahtjev je već obrađen.");
            }

            if (entity.Tip == "club_join_request" && entity.KlubId.HasValue)
            {
                var klub = Context.KlubFilmova.FirstOrDefault(k => k.Id == entity.KlubId);
                if (klub != null)
                {
                    if (klub.VlasnikId != rejectedById)
                    {
                        throw new UserException("Samo vlasnik kluba može odbiti zahtjev.");
                    }

                    var rejector = Context.Korisnici.Find(rejectedById);
                    var rejectedNotification = new Database.Obavijesti
                    {
                        Tip = "club_join_rejected",
                        PosiljateljId = rejectedById,
                        PrimateljId = entity.PosiljateljId,
                        KlubId = entity.KlubId,
                        Poruka = $"Vaš zahtjev za pridruživanje klubu '{klub.Naziv}' je odbijen.",
                        Status = "info",
                        Procitano = false,
                        DatumKreiranja = DateTime.Now
                    };
                    Context.Obavijesti.Add(rejectedNotification);

                    entity.Status = "rejected";
                    entity.DatumObrade = DateTime.Now;
                    Context.SaveChanges();

                    rejectedNotification.Posiljatelj = rejector;
                    rejectedNotification.Klub = klub;

                    _ = _chatNotificationService.NotifyNewNotification(Mapper.Map<Model.Models.Obavijesti>(rejectedNotification));

                    return Mapper.Map<Model.Models.Obavijesti>(entity);
                }
            }

            entity.Status = "rejected";
            entity.DatumObrade = DateTime.Now;
            Context.SaveChanges();

            return Mapper.Map<Model.Models.Obavijesti>(entity);
        }

        public Model.Models.Obavijesti MarkAsRead(int id)
        {
            var entity = Context.Obavijesti.Find(id);
            if (entity == null)
            {
                throw new UserException("Obavijest ne postoji.");
            }

            entity.Procitano = true;
            Context.SaveChanges();

            return Mapper.Map<Model.Models.Obavijesti>(entity);
        }

        public int GetUnreadCount(int korisnikId)
        {
            return Context.Obavijesti.Count(o => o.PrimateljId == korisnikId && !o.Procitano);
        }
    }
}
