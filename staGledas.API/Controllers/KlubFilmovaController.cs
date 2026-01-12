using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using staGledas.Model.Models;
using staGledas.Model.Requests;
using staGledas.Model.SearchObject;
using staGledas.Service.Interfaces;
using System.Security.Claims;

namespace staGledas.API.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class KlubFilmovaController : BaseCRUDController<KlubFilmova, KlubFilmovaSearchObject, KlubFilmovaInsertRequest, KlubFilmovaUpdateRequest>
    {
        private readonly IKlubFilmovaService _klubService;

        public KlubFilmovaController(IKlubFilmovaService service) : base(service)
        {
            _klubService = service;
        }

        public override KlubFilmova Insert([FromBody] KlubFilmovaInsertRequest request)
        {
            request.VlasnikId = int.Parse(User.FindFirst(ClaimTypes.NameIdentifier)?.Value ?? "0");
            return base.Insert(request);
        }

        [HttpPost("{klubId}/join")]
        public KlubFilmova Join(int klubId)
        {
            var korisnikId = int.Parse(User.FindFirst(ClaimTypes.NameIdentifier)?.Value ?? "0");
            return _klubService.Join(klubId, korisnikId);
        }

        [HttpPost("{klubId}/leave")]
        public IActionResult Leave(int klubId)
        {
            var korisnikId = int.Parse(User.FindFirst(ClaimTypes.NameIdentifier)?.Value ?? "0");
            var result = _klubService.Leave(klubId, korisnikId);
            if (result == null)
            {
                return Ok(new { deleted = true, message = "Klub je obrisan jer ste vi bili vlasnik." });
            }
            return Ok(result);
        }

        [HttpGet("{klubId}/members")]
        public List<KlubFilmovaClanovi> GetMembers(int klubId)
        {
            return _klubService.GetMembers(klubId);
        }

        public override KlubFilmova Delete(int id)
        {
            var korisnikId = int.Parse(User.FindFirst(ClaimTypes.NameIdentifier)?.Value ?? "0");
            _klubService.DeleteClub(id, korisnikId);
            return null!;
        }

        [HttpPost("{klubId}/kick/{memberId}")]
        public IActionResult KickMember(int klubId, int memberId)
        {
            var ownerId = int.Parse(User.FindFirst(ClaimTypes.NameIdentifier)?.Value ?? "0");
            _klubService.KickMember(klubId, memberId, ownerId);
            return Ok(new { message = "Član uspješno uklonjen." });
        }
    }
}
