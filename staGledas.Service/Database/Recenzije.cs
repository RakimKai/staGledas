using System;
using System.Collections.Generic;

namespace staGledas.Service.Database
{
    public class Recenzije
    {
        public int Id { get; set; }
        public int KorisnikId { get; set; }
        public int FilmId { get; set; }
        public double Ocjena { get; set; }
        public string? Naslov { get; set; }
        public string? Sadrzaj { get; set; }
        public bool ImaSpoiler { get; set; } = false;
        public DateTime DatumKreiranja { get; set; }
        public DateTime? DatumIzmjene { get; set; }
        public bool IsHidden { get; set; } = false;
        public DateTime? DatumSkrivanja { get; set; }
        public virtual Korisnici? Korisnik { get; set; }
        public virtual Filmovi? Film { get; set; }
    }
}
