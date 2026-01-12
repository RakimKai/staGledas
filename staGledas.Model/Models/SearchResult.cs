using System.Collections.Generic;

namespace staGledas.Model.Models
{
    public class CombinedSearchResult
    {
        public List<Filmovi> Filmovi { get; set; } = new List<Filmovi>();
        public List<Recenzije> Recenzije { get; set; } = new List<Recenzije>();
        public List<Korisnici> Korisnici { get; set; } = new List<Korisnici>();
    }
}
