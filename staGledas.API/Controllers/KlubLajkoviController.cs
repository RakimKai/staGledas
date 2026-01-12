using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using staGledas.Model.Models;
using staGledas.Model.SearchObject;
using staGledas.Service.Interfaces;

namespace staGledas.API.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    [Authorize]
    public class KlubLajkoviController : BaseController<KlubLajkovi, KlubLajkoviSearchObject>
    {
        private readonly IKlubLajkoviService _klubLajkoviService;

        public KlubLajkoviController(IKlubLajkoviService service) : base(service)
        {
            _klubLajkoviService = service;
        }

        [HttpPost("toggle/{objavaId}")]
        public async Task<IActionResult> ToggleLike(int objavaId)
        {
            var korisnikId = GetCurrentUserId();
            if (!korisnikId.HasValue) return Unauthorized();
            var isLiked = await _klubLajkoviService.ToggleLike(korisnikId.Value, objavaId);
            var count = await _klubLajkoviService.GetLikeCount(objavaId);
            return Ok(new { IsLiked = isLiked, LikeCount = count });
        }

        [HttpGet("check/{objavaId}")]
        public async Task<IActionResult> IsLiked(int objavaId)
        {
            var korisnikId = GetCurrentUserId();
            if (!korisnikId.HasValue) return Unauthorized();
            var isLiked = await _klubLajkoviService.IsLiked(korisnikId.Value, objavaId);
            return Ok(new { IsLiked = isLiked });
        }

        [HttpGet("count/{objavaId}")]
        public async Task<IActionResult> GetLikeCount(int objavaId)
        {
            var count = await _klubLajkoviService.GetLikeCount(objavaId);
            return Ok(new { LikeCount = count });
        }
    }
}
