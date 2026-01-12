using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using staGledas.Model.Models;
using staGledas.Model.Requests;
using staGledas.Model.SearchObject;
using staGledas.Service.Interfaces;

namespace staGledas.API.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    [Authorize]
    public class FavoritiController : BaseCRUDController<Favoriti, FavoritiSearchObject, FavoritiUpsertRequest, FavoritiUpsertRequest>
    {
        private readonly IFavoritiService _favoritiService;

        public FavoritiController(IFavoritiService service) : base(service)
        {
            _favoritiService = service;
        }

        [HttpPost("toggle/{filmId}")]
        public async Task<IActionResult> ToggleFavorit(int filmId)
        {
            var korisnikId = GetCurrentUserId();
            if (!korisnikId.HasValue) return Unauthorized();
            var isFavorit = await _favoritiService.ToggleFavorit(korisnikId.Value, filmId);
            return Ok(new { IsFavorit = isFavorit });
        }

        [HttpGet("check/{filmId}")]
        public async Task<IActionResult> IsFavorit(int filmId)
        {
            var korisnikId = GetCurrentUserId();
            if (!korisnikId.HasValue) return Unauthorized();
            var isFavorit = await _favoritiService.IsFavorit(korisnikId.Value, filmId);
            return Ok(new { IsFavorit = isFavorit });
        }
    }
}
