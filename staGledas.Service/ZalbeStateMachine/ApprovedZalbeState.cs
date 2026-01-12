using MapsterMapper;
using Microsoft.Extensions.Logging;
using staGledas.Service.Database;

namespace staGledas.Service.ZalbeStateMachine
{
    public class ApprovedZalbeState : BaseZalbeState
    {
        private readonly ILogger<ApprovedZalbeState> _logger;

        public ApprovedZalbeState(
            StaGledasContext dbContext,
            IMapper mapper,
            IServiceProvider serviceProvider,
            ILogger<ApprovedZalbeState> logger) : base(dbContext, mapper, serviceProvider)
        {
            _logger = logger;
        }

        public override List<string> AllowedActions(Database.Zalbe? entity)
        {
            return new List<string>();
        }
    }
}
