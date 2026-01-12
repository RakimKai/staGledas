using System.Collections.Generic;
using System.Text.Json.Serialization;

namespace staGledas.Model.DTOs.TMDb
{
    public class TMDbMovieSearchResponse
    {
        [JsonPropertyName("page")]
        public int Page { get; set; }

        [JsonPropertyName("results")]
        public List<TMDbMovie> Results { get; set; } = new List<TMDbMovie>();

        [JsonPropertyName("total_pages")]
        public int TotalPages { get; set; }

        [JsonPropertyName("total_results")]
        public int TotalResults { get; set; }
    }

    public class TMDbMovie
    {
        [JsonPropertyName("id")]
        public int Id { get; set; }

        [JsonPropertyName("title")]
        public string? Title { get; set; }

        [JsonPropertyName("original_title")]
        public string? OriginalTitle { get; set; }

        [JsonPropertyName("overview")]
        public string? Overview { get; set; }

        [JsonPropertyName("release_date")]
        public string? ReleaseDate { get; set; }

        [JsonPropertyName("poster_path")]
        public string? PosterPath { get; set; }

        [JsonPropertyName("backdrop_path")]
        public string? BackdropPath { get; set; }

        [JsonPropertyName("vote_average")]
        public double VoteAverage { get; set; }

        [JsonPropertyName("vote_count")]
        public int VoteCount { get; set; }

        [JsonPropertyName("popularity")]
        public double Popularity { get; set; }

        [JsonPropertyName("genre_ids")]
        public List<int> GenreIds { get; set; } = new List<int>();

        [JsonPropertyName("adult")]
        public bool Adult { get; set; }

        [JsonPropertyName("original_language")]
        public string? OriginalLanguage { get; set; }
    }

    public class TMDbMovieDetails : TMDbMovie
    {
        [JsonPropertyName("runtime")]
        public int? Runtime { get; set; }

        [JsonPropertyName("genres")]
        public List<TMDbGenre> Genres { get; set; } = new List<TMDbGenre>();

        [JsonPropertyName("credits")]
        public TMDbCredits? Credits { get; set; }
    }

    public class TMDbGenre
    {
        [JsonPropertyName("id")]
        public int Id { get; set; }

        [JsonPropertyName("name")]
        public string? Name { get; set; }
    }

    public class TMDbCredits
    {
        [JsonPropertyName("cast")]
        public List<TMDbCastMember> Cast { get; set; } = new List<TMDbCastMember>();

        [JsonPropertyName("crew")]
        public List<TMDbCrewMember> Crew { get; set; } = new List<TMDbCrewMember>();
    }

    public class TMDbCastMember
    {
        [JsonPropertyName("id")]
        public int Id { get; set; }

        [JsonPropertyName("name")]
        public string? Name { get; set; }

        [JsonPropertyName("character")]
        public string? Character { get; set; }

        [JsonPropertyName("profile_path")]
        public string? ProfilePath { get; set; }

        [JsonPropertyName("order")]
        public int Order { get; set; }
    }

    public class TMDbCrewMember
    {
        [JsonPropertyName("id")]
        public int Id { get; set; }

        [JsonPropertyName("name")]
        public string? Name { get; set; }

        [JsonPropertyName("job")]
        public string? Job { get; set; }

        [JsonPropertyName("department")]
        public string? Department { get; set; }

        [JsonPropertyName("profile_path")]
        public string? ProfilePath { get; set; }
    }
}
