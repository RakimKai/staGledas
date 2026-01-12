using System;
using System.Collections.Generic;

namespace staGledas.Service.Database
{
    public class KlubObjave
    {
        public int Id { get; set; }
        public int KlubId { get; set; }
        public int KorisnikId { get; set; }
        public string? Sadrzaj { get; set; }
        public DateTime DatumKreiranja { get; set; }
        public DateTime? DatumIzmjene { get; set; }
        public bool IsDeleted { get; set; } = false;
        public DateTime? DatumBrisanja { get; set; }
        public virtual KlubFilmova? Klub { get; set; }
        public virtual Korisnici? Korisnik { get; set; }
        public virtual ICollection<KlubKomentari> Komentari { get; set; } = new List<KlubKomentari>();
        public virtual ICollection<KlubLajkovi> Lajkovi { get; set; } = new List<KlubLajkovi>();
    }
}
