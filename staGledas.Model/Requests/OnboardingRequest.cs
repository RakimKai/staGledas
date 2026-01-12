using System.Collections.Generic;

namespace staGledas.Model.Requests
{
    public class OnboardingRequest
    {
        public List<int> WatchedTmdbIds { get; set; } = new List<int>();
        public List<int> LikedTmdbIds { get; set; } = new List<int>();
        public List<OnboardingRating> Ratings { get; set; } = new List<OnboardingRating>();
    }

    public class OnboardingRating
    {
        public int TmdbId { get; set; }
        public int Ocjena { get; set; }
    }
}
