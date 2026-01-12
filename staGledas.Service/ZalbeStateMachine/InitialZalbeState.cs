using MapsterMapper;
using Microsoft.Extensions.Logging;
using staGledas.Model.Exceptions;
using staGledas.Model.Requests;
using staGledas.Service.Database;

namespace staGledas.Service.ZalbeStateMachine
{
    public class InitialZalbeState : BaseZalbeState
    {
        private readonly ILogger<InitialZalbeState> _logger;

        public InitialZalbeState(
            StaGledasContext dbContext,
            IMapper mapper,
            IServiceProvider serviceProvider,
            ILogger<InitialZalbeState> logger) : base(dbContext, mapper, serviceProvider)
        {
            _logger = logger;
        }

        public override Model.Models.Zalbe Insert(ZalbeInsertRequest request, int korisnikId)
        {
            var recenzija = Context.Recenzije.Find(request.RecenzijaId);
            if (recenzija == null)
            {
                throw new UserException("Recenzija ne postoji.");
            }

            if (string.IsNullOrWhiteSpace(request.Razlog))
            {
                throw new UserException("Razlog prijave je obavezan.");
            }

            var existingReport = Context.Zalbe.FirstOrDefault(z => z.RecenzijaId == request.RecenzijaId && z.KorisnikId == korisnikId);
            if (existingReport != null)
            {
                throw new UserException("Već ste prijavili ovu recenziju.");
            }

            var entity = new Database.Zalbe
            {
                RecenzijaId = request.RecenzijaId,
                KorisnikId = korisnikId,
                Razlog = request.Razlog,
                Opis = request.Opis,
                Status = "pending",
                DatumKreiranja = DateTime.Now
            };

            Context.Zalbe.Add(entity);
            Context.SaveChanges();

            _logger.LogInformation($"[+] Kreirana nova zalba ID: {entity.Id} | Korisnik ID: {korisnikId} | Recenzija ID: {request.RecenzijaId}");

            return Mapper.Map<Model.Models.Zalbe>(entity);
        }

        public override List<string> AllowedActions(Database.Zalbe? entity)
        {
            return new List<string> { nameof(Insert) };
        }
    }
}
