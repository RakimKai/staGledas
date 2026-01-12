using System;

namespace staGledas.Service.Database
{
    public class Watchlist
    {
        public int Id { get; set; }
        public int KorisnikId { get; set; }
        public int FilmId { get; set; }
        public DateTime DatumDodavanja { get; set; }
        public bool? Pogledano { get; set; }
        public DateTime? DatumGledanja { get; set; }
        public virtual Korisnici? Korisnik { get; set; }
        public virtual Filmovi? Film { get; set; }
    }
}
