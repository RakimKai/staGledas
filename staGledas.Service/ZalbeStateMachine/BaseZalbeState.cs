using MapsterMapper;
using Microsoft.Extensions.DependencyInjection;
using staGledas.Model.Exceptions;
using staGledas.Model.Requests;
using staGledas.Service.Database;

namespace staGledas.Service.ZalbeStateMachine
{
    public class BaseZalbeState
    {
        public StaGledasContext Context { get; set; }
        public IMapper Mapper { get; set; }
        public IServiceProvider ServiceProvider { get; set; }

        public BaseZalbeState(StaGledasContext dbContext, IMapper mapper, IServiceProvider serviceProvider)
        {
            Context = dbContext;
            Mapper = mapper;
            ServiceProvider = serviceProvider;
        }

        public virtual Model.Models.Zalbe Insert(ZalbeInsertRequest request, int korisnikId)
        {
            throw new UserException("Akcija nije dozvoljena u trenutnom stanju.");
        }

        public virtual Model.Models.Zalbe Approve(int id, int adminId)
        {
            throw new UserException("Akcija nije dozvoljena u trenutnom stanju.");
        }

        public virtual Model.Models.Zalbe Reject(int id, int adminId)
        {
            throw new UserException("Akcija nije dozvoljena u trenutnom stanju.");
        }

        public virtual List<string> AllowedActions(Database.Zalbe? entity)
        {
            return new List<string>();
        }

        public BaseZalbeState CreateState(string stateName)
        {
            return stateName switch
            {
                "initial" => ServiceProvider.GetRequiredService<InitialZalbeState>(),
                "pending" => ServiceProvider.GetRequiredService<PendingZalbeState>(),
                "approved" => ServiceProvider.GetRequiredService<ApprovedZalbeState>(),
                "rejected" => ServiceProvider.GetRequiredService<RejectedZalbeState>(),
                _ => throw new UserException($"Nepoznato stanje: {stateName}")
            };
        }
    }
}
