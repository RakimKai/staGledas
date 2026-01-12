using System;

namespace staGledas.Model.Models
{
    public class Favoriti
    {
        public int Id { get; set; }
        public int KorisnikId { get; set; }
        public int FilmId { get; set; }
        public DateTime DatumDodavanja { get; set; }
        public virtual Korisnici? Korisnik { get; set; }
        public virtual Filmovi? Film { get; set; }
    }
}
