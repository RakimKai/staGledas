using MapsterMapper;
using Microsoft.Extensions.Logging;
using staGledas.Service.Database;

namespace staGledas.Service.ZalbeStateMachine
{
    public class RejectedZalbeState : BaseZalbeState
    {
        private readonly ILogger<RejectedZalbeState> _logger;

        public RejectedZalbeState(
            StaGledasContext dbContext,
            IMapper mapper,
            IServiceProvider serviceProvider,
            ILogger<RejectedZalbeState> logger) : base(dbContext, mapper, serviceProvider)
        {
            _logger = logger;
        }

        public override List<string> AllowedActions(Database.Zalbe? entity)
        {
            return new List<string>();
        }
    }
}
