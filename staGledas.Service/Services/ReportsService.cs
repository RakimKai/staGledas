using Microsoft.EntityFrameworkCore;
using staGledas.Model.DTOs.Reports;
using staGledas.Service.Database;
using staGledas.Service.Interfaces;

namespace staGledas.Service.Services
{
    public class ReportsService : IReportsService
    {
        private readonly StaGledasContext _context;
        private const decimal PREMIUM_PRICE = 4.99m;

        public ReportsService(StaGledasContext context)
        {
            _context = context;
        }

        public DashboardStats GetDashboardStats()
        {
            return new DashboardStats
            {
                BrojKorisnika = _context.Korisnici.Count(),
                BrojPremiumKorisnika = _context.Korisnici.Count(k => k.IsPremium == true),
                BrojFilmova = _context.Filmovi.Count(),
                BrojNovosti = _context.Novosti.Count(),
                BrojFlagiranogSadrzaja = _context.Zalbe.Count(z => z.Status == "pending")
            };
        }

        public AnalyticsReport GetAnalyticsReport(int godina)
        {
            var startOfYear = new DateTime(godina, 1, 1);
            var endOfYear = new DateTime(godina, 12, 31, 23, 59, 59);
            var startOfPreviousYear = new DateTime(godina - 1, 1, 1);
            var endOfPreviousYear = new DateTime(godina - 1, 12, 31, 23, 59, 59);

            var usersThisYear = _context.Korisnici
                .Count(k => k.DatumKreiranja >= startOfYear && k.DatumKreiranja <= endOfYear);

            var usersPreviousYear = _context.Korisnici
                .Count(k => k.DatumKreiranja >= startOfPreviousYear && k.DatumKreiranja <= endOfPreviousYear);

            var premiumUsers = _context.Korisnici
                .Count(k => k.IsPremium == true && k.DatumKreiranja <= endOfYear);

            var totalUsers = _context.Korisnici
                .Count(k => k.DatumKreiranja <= endOfYear);

            var reviewsThisYear = _context.Recenzije
                .Count(r => r.DatumKreiranja >= startOfYear && r.DatumKreiranja <= endOfYear);

            var adminCount = _context.KorisniciUloge
                .Where(ku => ku.UlogaId == 1)
                .Count(ku => ku.Korisnik.DatumKreiranja <= endOfYear);

            var activePremiumSubscriptions = _context.Pretplate
                .Count(p => p.Status == "active" && p.DatumPocetka <= endOfYear);
            var monthsElapsed = godina == DateTime.Now.Year ? DateTime.Now.Month : 12;
            var estimatedRevenue = activePremiumSubscriptions * PREMIUM_PRICE * monthsElapsed;

            var deletedAccounts = _context.Korisnici
                .IgnoreQueryFilters()
                .Count(k => k.IsDeleted == true && k.DatumBrisanja >= startOfYear && k.DatumBrisanja <= endOfYear);

            double growthRate = usersPreviousYear > 0
                ? ((double)(usersThisYear - usersPreviousYear) / usersPreviousYear) * 100
                : 0;

            var monthlyStats = new List<MonthlyUserStats>();
            var months = new[] { "", "Januar", "Februar", "Mart", "April", "Maj", "Juni", "Juli", "August", "Septembar", "Oktobar", "Novembar", "Decembar" };

            for (int month = 1; month <= 12; month++)
            {
                var monthStart = new DateTime(godina, month, 1);
                var monthEnd = monthStart.AddMonths(1).AddDays(-1);

                var standardUsers = _context.Korisnici
                    .Count(k => k.DatumKreiranja >= monthStart && k.DatumKreiranja <= monthEnd && k.IsPremium != true);

                var premiumUsersMonth = _context.Korisnici
                    .Count(k => k.DatumKreiranja >= monthStart && k.DatumKreiranja <= monthEnd && k.IsPremium == true);

                monthlyStats.Add(new MonthlyUserStats
                {
                    Mjesec = month,
                    NazivMjeseca = months[month],
                    BrojStandardnihKorisnika = standardUsers,
                    BrojPremiumKorisnika = premiumUsersMonth
                });
            }

            return new AnalyticsReport
            {
                Godina = godina,
                BrojKorisnika = totalUsers,
                BrojPremiumKorisnika = premiumUsers,
                PostotakPremiumKorisnika = totalUsers > 0 ? Math.Round((double)premiumUsers / totalUsers * 100, 1) : 0,
                UkupniPrihodi = estimatedRevenue,
                BrojObrisanihRacuna = deletedAccounts,
                RastUOdnosuNaProslodisnjuGodinu = Math.Round(growthRate, 1),
                BrojKreiranihRecenzija = reviewsThisYear,
                BrojAdministratora = adminCount,
                MjesecnaStatistika = monthlyStats
            };
        }

        public List<YearlyReport> GetYearlyComparison(int odGodine, int doGodine)
        {
            var reports = new List<YearlyReport>();

            for (int year = odGodine; year <= doGodine; year++)
            {
                var startOfYear = new DateTime(year, 1, 1);
                var endOfYear = new DateTime(year, 12, 31, 23, 59, 59);

                var usersThisYear = _context.Korisnici
                    .Count(k => k.DatumKreiranja <= endOfYear);

                var premiumUsers = _context.Korisnici
                    .Count(k => k.IsPremium == true && k.DatumKreiranja <= endOfYear);

                var reviews = _context.Recenzije
                    .Count(r => r.DatumKreiranja >= startOfYear && r.DatumKreiranja <= endOfYear);

                var adminCount = _context.KorisniciUloge
                    .Where(ku => ku.UlogaId == 1)
                    .Count(ku => ku.Korisnik.DatumKreiranja <= endOfYear);

                var activePremiumSubscriptions = _context.Pretplate
                    .Count(p => p.Status == "active" && p.DatumPocetka <= endOfYear);
                var monthsElapsed = year == DateTime.Now.Year ? DateTime.Now.Month : 12;

                reports.Add(new YearlyReport
                {
                    Godina = year,
                    BrojKorisnika = usersThisYear,
                    BrojPremiumKorisnika = premiumUsers,
                    BrojKreiranihRecenzija = reviews,
                    UkupniPrihodi = activePremiumSubscriptions * PREMIUM_PRICE * monthsElapsed,
                    BrojAdministratora = adminCount
                });
            }

            return reports;
        }

        public List<MovieStats> GetTopMovies(int count = 10)
        {
            return _context.Filmovi
                .Select(f => new MovieStats
                {
                    FilmId = f.Id,
                    Naslov = f.Naslov,
                    DatumIzlaska = f.DatumKreiranja,
                    BrojRecenzija = f.BrojOcjena ?? 0,
                    ProsjecnaOcjena = f.ProsjecnaOcjena ?? 0
                })
                .OrderByDescending(m => m.BrojRecenzija)
                .Take(count)
                .ToList();
        }

        public UserTypeDistribution GetUserTypeDistribution()
        {
            var total = _context.Korisnici.Count();
            var premium = _context.Korisnici.Count(k => k.IsPremium == true);
            var standard = total - premium;

            return new UserTypeDistribution
            {
                StandardniKorisnici = standard,
                PremiumKorisnici = premium,
                PostotakPremium = total > 0 ? Math.Round((double)premium / total * 100, 1) : 0
            };
        }
    }
}
