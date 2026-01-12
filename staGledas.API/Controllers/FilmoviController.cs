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
    public class FilmoviController : BaseCRUDController<Filmovi, FilmoviSearchObject, FilmoviInsertRequest, FilmoviUpdateRequest>
    {
        private readonly IRecommenderService _recommenderService;

        public FilmoviController(IFilmoviService service, IRecommenderService recommenderService) : base(service)
        {
            _recommenderService = recommenderService;
        }

        [HttpGet("preporuke/{korisnikId}")]
        [Authorize]
        public IActionResult GetRecommendationsForUser(int korisnikId)
        {
            var localRecs = _recommenderService.GetLocalRecommendationsForUser(korisnikId, 12);
            return Ok(localRecs);
        }

        [HttpGet("{filmId}/slicni")]
        public async Task<IActionResult> GetSimilarMovies(int filmId)
        {
            try
            {
                var similar = await _recommenderService.GetSimilarMoviesAsync(filmId, 6);
                return Ok(similar);
            }
            catch
            {
                var localSimilar = _recommenderService.GetLocalSimilarMovies(filmId, 6);
                return Ok(localSimilar);
            }
        }
    }
}
