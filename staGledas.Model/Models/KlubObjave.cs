using System;

namespace staGledas.Model.Models
{
    public class KlubObjave
    {
        public int Id { get; set; }
        public int KlubId { get; set; }
        public int KorisnikId { get; set; }
        public string? Sadrzaj { get; set; }
        public DateTime DatumKreiranja { get; set; }
        public DateTime? DatumIzmjene { get; set; }
        public bool IsDeleted { get; set; }
        public DateTime? DatumBrisanja { get; set; }
        public int BrojKomentara { get; set; }
        public int BrojLajkova { get; set; }
        public virtual KlubFilmova? Klub { get; set; }
        public virtual Korisnici? Korisnik { get; set; }
    }
}
