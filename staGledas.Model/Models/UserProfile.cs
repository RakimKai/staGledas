using System;
using System.Collections.Generic;

namespace staGledas.Model.Models
{
    public class UserProfile
    {
        public int Id { get; set; }
        public string? Ime { get; set; }
        public string? Prezime { get; set; }
        public string? KorisnickoIme { get; set; }
        public string? Email { get; set; }
        public byte[]? Slika { get; set; }
        public bool? IsPremium { get; set; }
        public DateTime? DatumKreiranja { get; set; }

        public int BrojRecenzija { get; set; }
        public int BrojFilmova { get; set; }
        public int BrojPratioca { get; set; }
        public int BrojPratim { get; set; }
        public int BrojFavorita { get; set; }
        public int BrojLajkova { get; set; }

        public List<Recenzije>? NedavneRecenzije { get; set; }
        public List<Filmovi>? NedavnoPogledano { get; set; }
        public List<Filmovi>? OmiljeniFilmovi { get; set; }
    }

    public class UserStatistics
    {
        public int BrojRecenzija { get; set; }
        public int BrojPogledanihFilmova { get; set; }
        public int BrojPratioca { get; set; }
        public int BrojPratim { get; set; }
        public int BrojFavorita { get; set; }
        public int BrojLajkovanihFilmova { get; set; }
        public double ProsjecnaOcjena { get; set; }
    }
}
