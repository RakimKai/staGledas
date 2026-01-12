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
    public class WatchlistController : BaseCRUDController<Watchlist, WatchlistSearchObject, WatchlistUpsertRequest, WatchlistUpsertRequest>
    {
        private readonly IWatchlistService _watchlistService;

        public WatchlistController(IWatchlistService service) : base(service)
        {
            _watchlistService = service;
        }

        [HttpPost("toggle/{filmId}")]
        public async Task<IActionResult> ToggleWatchlist(int filmId)
        {
            var korisnikId = GetCurrentUserId();
            if (!korisnikId.HasValue) return Unauthorized();
            var isInWatchlist = await _watchlistService.ToggleWatchlist(korisnikId.Value, filmId);
            return Ok(new { IsInWatchlist = isInWatchlist });
        }

        [HttpGet("check/{filmId}")]
        public async Task<IActionResult> IsInWatchlist(int filmId)
        {
            var korisnikId = GetCurrentUserId();
            if (!korisnikId.HasValue) return Unauthorized();
            var isInWatchlist = await _watchlistService.IsInWatchlist(korisnikId.Value, filmId);
            return Ok(new { IsInWatchlist = isInWatchlist });
        }

        [HttpPost("markWatched/{filmId}")]
        public async Task<IActionResult> MarkAsWatched(int filmId)
        {
            var korisnikId = GetCurrentUserId();
            if (!korisnikId.HasValue) return Unauthorized();
            var isWatched = await _watchlistService.MarkAsWatched(korisnikId.Value, filmId);
            return Ok(new { IsWatched = isWatched });
        }

        [HttpGet("isWatched/{filmId}")]
        public async Task<IActionResult> IsWatched(int filmId)
        {
            var korisnikId = GetCurrentUserId();
            if (!korisnikId.HasValue) return Unauthorized();
            var isWatched = await _watchlistService.IsWatched(korisnikId.Value, filmId);
            return Ok(new { IsWatched = isWatched });
        }
    }
}
