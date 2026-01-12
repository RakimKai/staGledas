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
    public class PorukeService : BaseCRUDService<Model.Models.Poruke, PorukeSearchObject, Database.Poruke, PorukeInsertRequest, PorukeInsertRequest>, IPorukeService
    {
        private readonly IChatNotificationService? _chatNotification;

        public PorukeService(StaGledasContext dbContext, IMapper mapper, IChatNotificationService? chatNotification = null) : base(dbContext, mapper)
        {
            _chatNotification = chatNotification;
        }

        public override IQueryable<Database.Poruke> AddFilter(PorukeSearchObject searchObject, IQueryable<Database.Poruke> query)
        {
            var filteredQuery = base.AddFilter(searchObject, query);

            if (searchObject?.PosiljateljId.HasValue == true)
            {
                filteredQuery = filteredQuery.Where(x => x.PosiljateljId == searchObject.PosiljateljId);
            }

            if (searchObject?.PrimateljId.HasValue == true)
            {
                filteredQuery = filteredQuery.Where(x => x.PrimateljId == searchObject.PrimateljId);
            }

            if (searchObject?.Procitano.HasValue == true)
            {
                filteredQuery = filteredQuery.Where(x => x.Procitano == searchObject.Procitano);
            }

            if (searchObject?.IsPosiljateljIncluded == true)
            {
                filteredQuery = filteredQuery.Include(x => x.Posiljatelj);
            }

            if (searchObject?.IsPrimateljIncluded == true)
            {
                filteredQuery = filteredQuery.Include(x => x.Primatelj);
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
                filteredQuery = filteredQuery.OrderByDescending(x => x.DatumSlanja);
            }

            return filteredQuery;
        }

        public Model.Models.Poruke Insert(PorukeInsertRequest request, int posiljateljId)
        {
            var primatelj = Context.Korisnici.Find(request.PrimateljId);
            if (primatelj == null)
            {
                throw new UserException("Primatelj ne postoji.");
            }

            if (string.IsNullOrWhiteSpace(request.Sadrzaj))
            {
                throw new UserException("Poruka ne može biti prazna.");
            }

            var senderFollowsRecipient = Context.Pratitelji
                .Any(p => p.PratiteljId == posiljateljId && p.KorisnikId == request.PrimateljId);
            var recipientFollowsSender = Context.Pratitelji
                .Any(p => p.PratiteljId == request.PrimateljId && p.KorisnikId == posiljateljId);

            if (!senderFollowsRecipient || !recipientFollowsSender)
            {
                throw new UserException("Možete slati poruke samo međusobnim pratiocima.");
            }

            var entity = new Database.Poruke
            {
                PosiljateljId = posiljateljId,
                PrimateljId = request.PrimateljId,
                Sadrzaj = request.Sadrzaj,
                DatumSlanja = DateTime.Now,
                Procitano = false
            };

            Context.Poruke.Add(entity);
            Context.SaveChanges();

            var result = Mapper.Map<Model.Models.Poruke>(entity);

            if (_chatNotification != null)
            {
                _ = _chatNotification.NotifyNewMessage(result);
            }

            return result;
        }

        public override void BeforeInsert(PorukeInsertRequest request, Database.Poruke entity)
        {
            throw new UserException("Use Insert(request, posiljateljId) method instead.");
        }

        public Model.Models.Poruke MarkAsRead(int id)
        {
            var entity = Context.Poruke.Find(id);
            if (entity == null)
            {
                throw new UserException("Poruka ne postoji.");
            }

            entity.Procitano = true;
            entity.DatumCitanja = DateTime.Now;
            Context.SaveChanges();

            if (_chatNotification != null)
            {
                _ = _chatNotification.NotifyMessagesRead(entity.PosiljateljId, entity.PrimateljId);
            }

            return Mapper.Map<Model.Models.Poruke>(entity);
        }
    }
}
