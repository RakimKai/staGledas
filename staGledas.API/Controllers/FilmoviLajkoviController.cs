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
    public class FilmoviLajkoviController : BaseController<FilmoviLajkovi, FilmoviLajkoviSearchObject>
    {
        private readonly IFilmoviLajkoviService _filmoviLajkoviService;

        public FilmoviLajkoviController(IFilmoviLajkoviService service) : base(service)
        {
            _filmoviLajkoviService = service;
        }

        [HttpPost("toggle/{filmId}")]
        public async Task<IActionResult> ToggleLike(int filmId)
        {
            var korisnikId = GetCurrentUserId();
            if (!korisnikId.HasValue) return Unauthorized();
            var isLiked = await _filmoviLajkoviService.ToggleLike(korisnikId.Value, filmId);
            var count = await _filmoviLajkoviService.GetLikeCount(filmId);
            return Ok(new { IsLiked = isLiked, LikeCount = count });
        }

        [HttpGet("check/{filmId}")]
        public async Task<IActionResult> IsLiked(int filmId)
        {
            var korisnikId = GetCurrentUserId();
            if (!korisnikId.HasValue) return Unauthorized();
            var isLiked = await _filmoviLajkoviService.IsLiked(korisnikId.Value, filmId);
            return Ok(new { IsLiked = isLiked });
        }

        [HttpGet("count/{filmId}")]
        [AllowAnonymous]
        public async Task<IActionResult> GetLikeCount(int filmId)
        {
            var count = await _filmoviLajkoviService.GetLikeCount(filmId);
            return Ok(new { LikeCount = count });
        }
    }
}
