using System;

namespace staGledas.Model.Models
{
    public class Recenzije
    {
        public int Id { get; set; }
        public int KorisnikId { get; set; }
        public int FilmId { get; set; }
        public double Ocjena { get; set; }
        public string? Naslov { get; set; }
        public string? Sadrzaj { get; set; }
        public bool ImaSpoiler { get; set; }
        public DateTime DatumKreiranja { get; set; }
        public DateTime? DatumIzmjene { get; set; }
        public bool IsHidden { get; set; }
        public DateTime? DatumSkrivanja { get; set; }
        public virtual Korisnici? Korisnik { get; set; }
        public virtual Filmovi? Film { get; set; }

        public string? Username { get; set; }
        public byte[]? KorisnikSlika { get; set; }
        public string? FilmNaslov { get; set; }
        public string? FilmPosterPath { get; set; }
    }
}
