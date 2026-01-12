using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using staGledas.Model.DTOs.TMDb;
using staGledas.Model.Models;
using staGledas.Service.Interfaces;

namespace staGledas.API.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    [Authorize]
    public class RecommenderController : ControllerBase
    {
        private readonly IRecommenderService _recommenderService;

        public RecommenderController(IRecommenderService recommenderService)
        {
            _recommenderService = recommenderService;
        }

        [HttpGet("feed/{korisnikId}")]
        public async Task<PersonalizedFeed> GetPersonalizedFeed(int korisnikId)
        {
            return await _recommenderService.GetPersonalizedFeedAsync(korisnikId);
        }

        [HttpGet("user/{korisnikId}")]
        public async Task<List<TMDbMovie>> GetRecommendationsForUser(int korisnikId, [FromQuery] int count = 10)
        {
            return await _recommenderService.GetRecommendationsForUserAsync(korisnikId, count);
        }

        [HttpGet("similar/{filmId}")]
        public async Task<List<TMDbMovie>> GetSimilarMovies(int filmId, [FromQuery] int count = 10)
        {
            return await _recommenderService.GetSimilarMoviesAsync(filmId, count);
        }

        [HttpGet("similar-local/{filmId}")]
        public List<Filmovi> GetLocalSimilarMovies(int filmId, [FromQuery] int count = 4)
        {
            return _recommenderService.GetLocalSimilarMovies(filmId, count);
        }

        [HttpGet("user-local/{korisnikId}")]
        public List<Filmovi> GetLocalRecommendationsForUser(int korisnikId, [FromQuery] int count = 10)
        {
            return _recommenderService.GetLocalRecommendationsForUser(korisnikId, count);
        }

        [HttpPost("train")]
        public IActionResult TrainModel()
        {
            _recommenderService.TrainModel();
            return Ok(new { message = "Model training completed successfully." });
        }
    }
}
