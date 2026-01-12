using MapsterMapper;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Logging;
using staGledas.Model.Exceptions;
using staGledas.Service.Database;

namespace staGledas.Service.ZalbeStateMachine
{
    public class PendingZalbeState : BaseZalbeState
    {
        private readonly ILogger<PendingZalbeState> _logger;

        public PendingZalbeState(
            StaGledasContext dbContext,
            IMapper mapper,
            IServiceProvider serviceProvider,
            ILogger<PendingZalbeState> logger) : base(dbContext, mapper, serviceProvider)
        {
            _logger = logger;
        }

        public override Model.Models.Zalbe Approve(int id, int adminId)
        {
            var entity = Context.Zalbe.Include(z => z.Recenzija).FirstOrDefault(z => z.Id == id);
            if (entity == null)
            {
                throw new UserException("Zalba ne postoji.");
            }

            entity.Status = "approved";
            entity.DatumObrade = DateTime.Now;
            entity.ObradioPrijavuId = adminId;

            if (entity.Recenzija != null)
            {
                entity.Recenzija.IsHidden = true;
                entity.Recenzija.DatumSkrivanja = DateTime.Now;
            }

            Context.SaveChanges();

            _logger.LogInformation($"[+] Zalba ID: {entity.Id} odobrena od admina ID: {adminId} | Recenzija skrivena");

            return Mapper.Map<Model.Models.Zalbe>(entity);
        }

        public override Model.Models.Zalbe Reject(int id, int adminId)
        {
            var entity = Context.Zalbe.Find(id);
            if (entity == null)
            {
                throw new UserException("Zalba ne postoji.");
            }

            entity.Status = "rejected";
            entity.DatumObrade = DateTime.Now;
            entity.ObradioPrijavuId = adminId;

            Context.SaveChanges();

            _logger.LogInformation($"[-] Zalba ID: {entity.Id} odbijena od admina ID: {adminId}");

            return Mapper.Map<Model.Models.Zalbe>(entity);
        }

        public override List<string> AllowedActions(Database.Zalbe? entity)
        {
            return new List<string> { nameof(Approve), nameof(Reject) };
        }
    }
}
