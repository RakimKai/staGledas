using Microsoft.AspNetCore.Mvc;
using staGledas.Model.Models;
using staGledas.Model.Requests;
using staGledas.Model.SearchObject;
using staGledas.Service.Interfaces;

namespace staGledas.API.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class PorukeController : BaseCRUDController<Poruke, PorukeSearchObject, PorukeInsertRequest, PorukeInsertRequest>
    {
        private readonly IPorukeService _porukeService;

        public PorukeController(IPorukeService service) : base(service)
        {
            _porukeService = service;
        }

        [HttpPost]
        public override Poruke Insert([FromBody] PorukeInsertRequest request)
        {
            var currentUserId = GetCurrentUserId();
            if (currentUserId == null)
            {
                throw new UnauthorizedAccessException("User not authenticated");
            }

            return _porukeService.Insert(request, currentUserId.Value);
        }

        [HttpPut("{id}/procitaj")]
        public Poruke MarkAsRead(int id)
        {
            return _porukeService.MarkAsRead(id);
        }
    }
}
