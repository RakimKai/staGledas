using System;
using System.Collections.Generic;

namespace staGledas.Service.Database
{
    public class Korisnici
    {
        public int Id { get; set; }
        public string? Ime { get; set; }
        public string? Prezime { get; set; }
        public string? Email { get; set; }
        public string? KorisnickoIme { get; set; }
        public string? Telefon { get; set; }
        public byte[]? Slika { get; set; }
        public string? LozinkaHash { get; set; }
        public string? LozinkaSalt { get; set; }
        public bool? Status { get; set; }
        public bool? IsPremium { get; set; }
        public DateTime? DatumKreiranja { get; set; }
        public DateTime? DatumIzmjene { get; set; }
        public bool IsDeleted { get; set; } = false;
        public DateTime? DatumBrisanja { get; set; }
        public virtual ICollection<KorisniciUloge> KorisniciUloge { get; set; } = new List<KorisniciUloge>();
        public virtual ICollection<Recenzije> Recenzije { get; set; } = new List<Recenzije>();
        public virtual ICollection<Watchlist> Watchlist { get; set; } = new List<Watchlist>();
        public virtual ICollection<Pratitelji> Pratim { get; set; } = new List<Pratitelji>();
        public virtual ICollection<Pratitelji> Pratioci { get; set; } = new List<Pratitelji>();
        public virtual ICollection<Poruke> PoslanePoruke { get; set; } = new List<Poruke>();
        public virtual ICollection<Poruke> PrimljenePoruke { get; set; } = new List<Poruke>();
        public virtual ICollection<Novosti> Novosti { get; set; } = new List<Novosti>();
        public virtual ICollection<Favoriti> Favoriti { get; set; } = new List<Favoriti>();
        public virtual ICollection<FilmoviLajkovi> FilmoviLajkovi { get; set; } = new List<FilmoviLajkovi>();
        public virtual ICollection<KlubObjave> KlubObjave { get; set; } = new List<KlubObjave>();
        public virtual ICollection<KlubKomentari> KlubKomentari { get; set; } = new List<KlubKomentari>();
        public virtual ICollection<KlubLajkovi> KlubLajkovi { get; set; } = new List<KlubLajkovi>();
    }
}
