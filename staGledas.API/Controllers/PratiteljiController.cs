using Microsoft.AspNetCore.Mvc;
using staGledas.Model.Models;
using staGledas.Model.Requests;
using staGledas.Model.SearchObject;
using staGledas.Service.Interfaces;

namespace staGledas.API.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class PratiteljiController : BaseCRUDController<Pratitelji, PratiteljiSearchObject, PratiteljiInsertRequest, PratiteljiInsertRequest>
    {
        private readonly IPratiteljiService _pratiteljiService;

        public PratiteljiController(IPratiteljiService service) : base(service)
        {
            _pratiteljiService = service;
        }

        [HttpPost]
        public override Pratitelji Insert([FromBody] PratiteljiInsertRequest request)
        {
            var currentUserId = GetCurrentUserId();
            if (currentUserId == null)
            {
                throw new UnauthorizedAccessException("User not authenticated");
            }

            return _pratiteljiService.Insert(request, currentUserId.Value);
        }
    }
}
