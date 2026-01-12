using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using staGledas.Model.Models;
using staGledas.Model.SearchObject;
using staGledas.Service.Interfaces;
using System.Security.Claims;

namespace staGledas.API.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    [Authorize]
    public class ObavijestiController : BaseController<Obavijesti, ObavijestiSearchObject>
    {
        private readonly IObavijestiService _obavijestiService;

        public ObavijestiController(IObavijestiService service) : base(service)
        {
            _obavijestiService = service;
        }

        [HttpPost("{id}/approve")]
        public Obavijesti Approve(int id)
        {
            var korisnikId = int.Parse(User.FindFirst(ClaimTypes.NameIdentifier)?.Value ?? "0");
            return _obavijestiService.Approve(id, korisnikId);
        }

        [HttpPost("{id}/reject")]
        public Obavijesti Reject(int id)
        {
            var korisnikId = int.Parse(User.FindFirst(ClaimTypes.NameIdentifier)?.Value ?? "0");
            return _obavijestiService.Reject(id, korisnikId);
        }

        [HttpPost("{id}/read")]
        public Obavijesti MarkAsRead(int id)
        {
            return _obavijestiService.MarkAsRead(id);
        }

        [HttpGet("unread-count")]
        public int GetUnreadCount()
        {
            var korisnikId = int.Parse(User.FindFirst(ClaimTypes.NameIdentifier)?.Value ?? "0");
            return _obavijestiService.GetUnreadCount(korisnikId);
        }
    }
}
