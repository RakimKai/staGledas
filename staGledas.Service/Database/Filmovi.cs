using System;
using System.Collections.Generic;

namespace staGledas.Service.Database
{
    public class Filmovi
    {
        public int Id { get; set; }
        public int? TmdbId { get; set; }
        public string? Naslov { get; set; }
        public string? Opis { get; set; }
        public int? GodinaIzdanja { get; set; }
        public int? Trajanje { get; set; }
        public string? Reziser { get; set; }
        public string? PosterPath { get; set; }
        public double? ProsjecnaOcjena { get; set; }
        public int? BrojOcjena { get; set; }
        public int? BrojPregleda { get; set; }
        public int? BrojLajkova { get; set; }
        public DateTime? DatumKreiranja { get; set; }
        public DateTime? DatumIzmjene { get; set; }
        public virtual ICollection<FilmoviZanrovi> FilmoviZanrovi { get; set; } = new List<FilmoviZanrovi>();
        public virtual ICollection<Recenzije> Recenzije { get; set; } = new List<Recenzije>();
        public virtual ICollection<Watchlist> Watchlist { get; set; } = new List<Watchlist>();
        public virtual ICollection<Favoriti> Favoriti { get; set; } = new List<Favoriti>();
        public virtual ICollection<FilmoviLajkovi> Lajkovi { get; set; } = new List<FilmoviLajkovi>();
    }
}
