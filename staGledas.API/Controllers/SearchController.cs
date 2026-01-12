using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using MapsterMapper;
using staGledas.Model.Models;
using staGledas.Service.Database;

namespace staGledas.API.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class SearchController : ControllerBase
    {
        private readonly StaGledasContext _context;
        private readonly IMapper _mapper;

        public SearchController(StaGledasContext context, IMapper mapper)
        {
            _context = context;
            _mapper = mapper;
        }

        [HttpGet]
        [AllowAnonymous]
        public async Task<CombinedSearchResult> Search([FromQuery] string query, [FromQuery] int limit = 5)
        {
            if (string.IsNullOrWhiteSpace(query))
            {
                return new CombinedSearchResult();
            }

            var searchTerm = query.ToLower();
            limit = Math.Clamp(limit, 1, 20);

            var result = new CombinedSearchResult
            {
                Filmovi = _mapper.Map<List<Model.Models.Filmovi>>(
                    await _context.Filmovi
                        .Where(f => f.Naslov != null && f.Naslov.ToLower().Contains(searchTerm))
                        .OrderByDescending(f => f.ProsjecnaOcjena)
                        .Take(limit)
                        .ToListAsync()),

                Recenzije = _mapper.Map<List<Model.Models.Recenzije>>(
                    await _context.Recenzije
                        .Include(r => r.Korisnik)
                        .Include(r => r.Film)
                        .Where(r => !r.IsHidden &&
                            ((r.Naslov != null && r.Naslov.ToLower().Contains(searchTerm)) ||
                             (r.Sadrzaj != null && r.Sadrzaj.ToLower().Contains(searchTerm))))
                        .Take(limit)
                        .ToListAsync()),

                Korisnici = _mapper.Map<List<Model.Models.Korisnici>>(
                    await _context.Korisnici
                        .Where(k =>
                            (k.Ime != null && k.Ime.ToLower().Contains(searchTerm)) ||
                            (k.Prezime != null && k.Prezime.ToLower().Contains(searchTerm)) ||
                            (k.KorisnickoIme != null && k.KorisnickoIme.ToLower().Contains(searchTerm)))
                        .Take(limit)
                        .ToListAsync())
            };

            return result;
        }

        [HttpGet("filmovi")]
        [AllowAnonymous]
        public async Task<List<Model.Models.Filmovi>> SearchFilmovi([FromQuery] string query, [FromQuery] int limit = 20)
        {
            if (string.IsNullOrWhiteSpace(query))
            {
                return new List<Model.Models.Filmovi>();
            }

            var searchTerm = query.ToLower();
            limit = Math.Clamp(limit, 1, 50);

            var filmovi = await _context.Filmovi
                .Where(f => f.Naslov != null && f.Naslov.ToLower().Contains(searchTerm))
                .OrderByDescending(f => f.ProsjecnaOcjena)
                .Take(limit)
                .ToListAsync();

            return _mapper.Map<List<Model.Models.Filmovi>>(filmovi);
        }

        [HttpGet("korisnici")]
        public async Task<List<Model.Models.Korisnici>> SearchKorisnici([FromQuery] string query, [FromQuery] int limit = 20)
        {
            if (string.IsNullOrWhiteSpace(query))
            {
                return new List<Model.Models.Korisnici>();
            }

            var searchTerm = query.ToLower();
            limit = Math.Clamp(limit, 1, 50);

            var korisnici = await _context.Korisnici
                .Where(k =>
                    (k.Ime != null && k.Ime.ToLower().Contains(searchTerm)) ||
                    (k.Prezime != null && k.Prezime.ToLower().Contains(searchTerm)) ||
                    (k.KorisnickoIme != null && k.KorisnickoIme.ToLower().Contains(searchTerm)))
                .Take(limit)
                .ToListAsync();

            return _mapper.Map<List<Model.Models.Korisnici>>(korisnici);
        }
    }
}
