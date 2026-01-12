using System;
using System.Collections.Generic;

namespace staGledas.Model.DTOs.Reports
{
    public class DashboardStats
    {
        public int BrojKorisnika { get; set; }
        public int BrojPremiumKorisnika { get; set; }
        public int BrojFilmova { get; set; }
        public int BrojNovosti { get; set; }
        public int BrojFlagiranogSadrzaja { get; set; }
    }

    public class YearlyReport
    {
        public int Godina { get; set; }
        public int BrojKorisnika { get; set; }
        public int BrojPremiumKorisnika { get; set; }
        public int BrojKreiranihRecenzija { get; set; }
        public decimal UkupniPrihodi { get; set; }
        public int BrojAdministratora { get; set; }
    }

    public class MonthlyUserStats
    {
        public int Mjesec { get; set; }
        public string? NazivMjeseca { get; set; }
        public int BrojStandardnihKorisnika { get; set; }
        public int BrojPremiumKorisnika { get; set; }
    }

    public class AnalyticsReport
    {
        public int Godina { get; set; }
        public int BrojKorisnika { get; set; }
        public int BrojPremiumKorisnika { get; set; }
        public double PostotakPremiumKorisnika { get; set; }
        public decimal UkupniPrihodi { get; set; }
        public int BrojObrisanihRacuna { get; set; }
        public double RastUOdnosuNaProslodisnjuGodinu { get; set; }
        public int BrojKreiranihRecenzija { get; set; }
        public int BrojAdministratora { get; set; }
        public List<MonthlyUserStats> MjesecnaStatistika { get; set; } = new List<MonthlyUserStats>();
    }

    public class MovieStats
    {
        public int FilmId { get; set; }
        public string? Naslov { get; set; }
        public DateTime? DatumIzlaska { get; set; }
        public int BrojRecenzija { get; set; }
        public double ProsjecnaOcjena { get; set; }
    }

    public class UserTypeDistribution
    {
        public int StandardniKorisnici { get; set; }
        public int PremiumKorisnici { get; set; }
        public double PostotakPremium { get; set; }
    }
}
