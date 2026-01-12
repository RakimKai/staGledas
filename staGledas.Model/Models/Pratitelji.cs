using System;

namespace staGledas.Model.Models
{
    public class Pratitelji
    {
        public int Id { get; set; }
        public int KorisnikId { get; set; }
        public int PratiteljId { get; set; }
        public DateTime DatumPracenja { get; set; }
        public virtual Korisnici? Korisnik { get; set; }
        public virtual Korisnici? Pratitelj { get; set; }
    }
}
