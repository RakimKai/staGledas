using System;

namespace staGledas.Service.Database
{
    public class KlubFilmovaClanovi
    {
        public int Id { get; set; }
        public int KlubId { get; set; }
        public int KorisnikId { get; set; }
        public string Uloga { get; set; } = "member"; // owner, admin, member
        public DateTime DatumPridruzivanja { get; set; }
        public virtual KlubFilmova? Klub { get; set; }
        public virtual Korisnici? Korisnik { get; set; }
    }
}
