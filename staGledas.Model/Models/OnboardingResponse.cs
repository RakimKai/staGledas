namespace staGledas.Model.Models
{
    public class OnboardingResponse
    {
        public int MoviesWatched { get; set; }
        public int MoviesLiked { get; set; }
        public int ReviewsCreated { get; set; }
        public bool Success { get; set; }
        public string? Message { get; set; }
    }
}
