using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using staGledas.Model.DTOs.TMDb;
using staGledas.Model.Models;
using staGledas.Model.Requests;
using staGledas.Model.SearchObject;
using staGledas.Service.Interfaces;

namespace staGledas.API.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class KorisniciController : BaseCRUDController<Korisnici, KorisniciSearchObject, KorisniciInsertRequest, KorisniciUpdateRequest>
    {
        private readonly IKorisniciService _korisniciService;
        private readonly ITMDbService _tmdbService;

        public KorisniciController(IKorisniciService service, ITMDbService tmdbService) : base(service)
        {
            _korisniciService = service;
            _tmdbService = tmdbService;
        }

        [HttpPost("login")]
        [AllowAnonymous]
        public Korisnici Login([FromBody] LoginRequest request)
        {
            return _korisniciService.Login(request.Username, request.Password);
        }

        [HttpPost("register")]
        [AllowAnonymous]
        public Korisnici Register(KorisniciInsertRequest request)
        {
            request.UlogaId = null;
            return _service.Insert(request);
        }

        public override Korisnici Insert(KorisniciInsertRequest request)
        {
            if (request.UlogaId == 1)
            {
                var isAdmin = User.IsInRole("Administrator");
                if (!isAdmin)
                {
                    throw new Model.Exceptions.UserException("Samo administratori mogu kreirati nove administratore.");
                }
            }
            return base.Insert(request);
        }

        [HttpGet("{id}/profil")]
        public async Task<UserProfile> GetProfile(int id)
        {
            return await _korisniciService.GetProfile(id);
        }

        [HttpGet("{id}/statistike")]
        public async Task<UserStatistics> GetStatistics(int id)
        {
            return await _korisniciService.GetStatistics(id);
        }

        [HttpGet("{id}/favoriti")]
        public async Task<List<Filmovi>> GetFavoriti(int id)
        {
            return await _korisniciService.GetFavoriti(id);
        }

        [HttpGet("{id}/lajkovi")]
        public async Task<List<Filmovi>> GetLajkovi(int id)
        {
            return await _korisniciService.GetLajkovi(id);
        }

        [HttpGet("{id}/nedavno-pogledani")]
        public async Task<List<Filmovi>> GetNedavnoPogledano(int id)
        {
            return await _korisniciService.GetNedavnoPogledano(id);
        }

        [HttpGet("onboarding/movies")]
        [AllowAnonymous]
        public async Task<List<TMDbMovie>> GetOnboardingMovies()
        {
            return await _tmdbService.GetTop100PopularMoviesAsync();
        }

        [HttpPost("{id}/onboarding")]
        public async Task<OnboardingResponse> ProcessOnboarding(int id, [FromBody] OnboardingRequest request)
        {
            return await _korisniciService.ProcessOnboarding(id, request);
        }

        [HttpPost("{id}/change-password")]
        [Authorize]
        public async Task<IActionResult> ChangePassword(int id, [FromBody] ChangePasswordRequest request)
        {
            await _korisniciService.ChangePassword(id, request);
            return Ok(new { message = "Lozinka uspješno promijenjena." });
        }

        [HttpPost("{id}/delete-account")]
        [Authorize]
        public async Task<IActionResult> DeleteAccount(int id, [FromBody] DeleteAccountRequest request)
        {
            await _korisniciService.DeleteAccount(id, request.Password);
            return Ok(new { message = "Račun uspješno obrisan." });
        }
    }
}
