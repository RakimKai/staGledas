using System;
using System.Text.Json.Serialization;

namespace staGledas.Model.Models
{
    public class KlubFilmovaClanovi
    {
        public int Id { get; set; }
        public int KlubId { get; set; }
        public int KorisnikId { get; set; }
        public string? Uloga { get; set; }
        public DateTime DatumPridruzivanja { get; set; }
        [JsonIgnore]
        public virtual KlubFilmova? Klub { get; set; }
        public virtual Korisnici? Korisnik { get; set; }
    }
}
