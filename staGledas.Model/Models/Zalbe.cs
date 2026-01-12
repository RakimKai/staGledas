using System;

namespace staGledas.Model.Models
{
    public class Zalbe
    {
        public int Id { get; set; }
        public int RecenzijaId { get; set; }
        public int KorisnikId { get; set; }
        public string? Razlog { get; set; }
        public string? Opis { get; set; }
        public string? Status { get; set; }
        public DateTime DatumKreiranja { get; set; }
        public DateTime? DatumObrade { get; set; }
        public int? ObradioPrijavuId { get; set; }
        public virtual Recenzije? Recenzija { get; set; }
        public virtual Korisnici? Korisnik { get; set; }
        public virtual Korisnici? ObradioPrijavu { get; set; }
    }
}
