using System;

namespace staGledas.Model.Models
{
    public class KlubLajkovi
    {
        public int Id { get; set; }
        public int ObjavaId { get; set; }
        public int KorisnikId { get; set; }
        public DateTime DatumLajka { get; set; }
        public virtual KlubObjave? Objava { get; set; }
        public virtual Korisnici? Korisnik { get; set; }
    }
}
