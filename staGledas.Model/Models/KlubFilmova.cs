using System;
using System.Collections.Generic;

namespace staGledas.Model.Models
{
    public class KlubFilmova
    {
        public int Id { get; set; }
        public string? Naziv { get; set; }
        public string? Opis { get; set; }
        public byte[]? Slika { get; set; }
        public int VlasnikId { get; set; }
        public bool IsPrivate { get; set; }
        public int? MaxClanova { get; set; }
        public DateTime DatumKreiranja { get; set; }
        public int BrojClanova { get; set; }
        public virtual Korisnici? Vlasnik { get; set; }
        public virtual ICollection<KlubFilmovaClanovi>? Clanovi { get; set; }
    }
}
