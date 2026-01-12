using System;
using System.Collections.Generic;

namespace staGledas.Model.Models
{
    public class Korisnici
    {
        public int Id { get; set; }
        public string? Ime { get; set; }
        public string? Prezime { get; set; }
        public string? Email { get; set; }
        public string? KorisnickoIme { get; set; }
        public string? Telefon { get; set; }
        public byte[]? Slika { get; set; }
        public bool? Status { get; set; }
        public bool? IsPremium { get; set; }
        public DateTime? DatumKreiranja { get; set; }
        public DateTime? DatumIzmjene { get; set; }
        public virtual ICollection<Uloge>? Uloge { get; set; }
    }
}
