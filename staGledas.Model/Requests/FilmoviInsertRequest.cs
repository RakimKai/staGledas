using System.Collections.Generic;

namespace staGledas.Model.Requests
{
    public class FilmoviInsertRequest
    {
        public string? Naslov { get; set; }
        public string? Opis { get; set; }
        public int? GodinaIzdanja { get; set; }
        public int? Trajanje { get; set; }
        public string? Reziser { get; set; }
        public string? PosterPath { get; set; }
        public List<int>? ZanroviIds { get; set; }
    }
}
