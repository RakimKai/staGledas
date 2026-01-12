using System;

namespace staGledas.Model.Models
{
    public class Novosti
    {
        public int Id { get; set; }
        public string? Naslov { get; set; }
        public string? Sadrzaj { get; set; }
        public byte[]? Slika { get; set; }
        public int AutorId { get; set; }
        public int? BrojPregleda { get; set; }
        public DateTime DatumKreiranja { get; set; }
        public DateTime? DatumIzmjene { get; set; }
        public virtual Korisnici? Autor { get; set; }
    }
}
