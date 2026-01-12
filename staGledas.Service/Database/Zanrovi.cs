using System.Collections.Generic;

namespace staGledas.Service.Database
{
    public class Zanrovi
    {
        public int Id { get; set; }
        public string? Naziv { get; set; }
        public string? Opis { get; set; }
        public virtual ICollection<FilmoviZanrovi> FilmoviZanrovi { get; set; } = new List<FilmoviZanrovi>();
    }
}
