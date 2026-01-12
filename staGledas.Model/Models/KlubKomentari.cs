using System;

namespace staGledas.Model.Models
{
    public class KlubKomentari
    {
        public int Id { get; set; }
        public int ObjavaId { get; set; }
        public int KorisnikId { get; set; }
        public string? Sadrzaj { get; set; }
        public DateTime DatumKreiranja { get; set; }
        public int? ParentKomentarId { get; set; }
        public virtual KlubObjave? Objava { get; set; }
        public virtual Korisnici? Korisnik { get; set; }
        public virtual KlubKomentari? ParentKomentar { get; set; }
    }
}
