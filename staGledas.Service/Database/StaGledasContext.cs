using Microsoft.EntityFrameworkCore;
using System.Security.Cryptography;
using System.Text;

namespace staGledas.Service.Database
{
    public class StaGledasContext : DbContext
    {
        public StaGledasContext(DbContextOptions<StaGledasContext> options) : base(options)
        {
        }

        public DbSet<Korisnici> Korisnici { get; set; }
        public DbSet<Uloge> Uloge { get; set; }
        public DbSet<KorisniciUloge> KorisniciUloge { get; set; }
        public DbSet<Filmovi> Filmovi { get; set; }
        public DbSet<Zanrovi> Zanrovi { get; set; }
        public DbSet<FilmoviZanrovi> FilmoviZanrovi { get; set; }

        public DbSet<Recenzije> Recenzije { get; set; }
        public DbSet<Watchlist> Watchlist { get; set; }
        public DbSet<Pratitelji> Pratitelji { get; set; }
        public DbSet<Poruke> Poruke { get; set; }
        public DbSet<Novosti> Novosti { get; set; }

        public DbSet<Zalbe> Zalbe { get; set; }
        public DbSet<KlubFilmova> KlubFilmova { get; set; }
        public DbSet<KlubFilmovaClanovi> KlubFilmovaClanovi { get; set; }
        public DbSet<Pretplate> Pretplate { get; set; }

        public DbSet<Favoriti> Favoriti { get; set; }
        public DbSet<FilmoviLajkovi> FilmoviLajkovi { get; set; }
        public DbSet<KlubObjave> KlubObjave { get; set; }
        public DbSet<KlubKomentari> KlubKomentari { get; set; }
        public DbSet<KlubLajkovi> KlubLajkovi { get; set; }
        public DbSet<Obavijesti> Obavijesti { get; set; }

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            base.OnModelCreating(modelBuilder);

            modelBuilder.Entity<Korisnici>().HasQueryFilter(k => !k.IsDeleted);

            modelBuilder.Entity<Filmovi>()
                .HasIndex(f => f.Naslov);

            modelBuilder.Entity<Korisnici>()
                .HasIndex(k => k.Ime);

            modelBuilder.Entity<Korisnici>()
                .HasIndex(k => k.Prezime);

            modelBuilder.Entity<KorisniciUloge>()
                .HasOne(ku => ku.Korisnik)
                .WithMany(k => k.KorisniciUloge)
                .HasForeignKey(ku => ku.KorisnikId);

            modelBuilder.Entity<KorisniciUloge>()
                .HasOne(ku => ku.Uloga)
                .WithMany(u => u.KorisniciUloge)
                .HasForeignKey(ku => ku.UlogaId);

            modelBuilder.Entity<FilmoviZanrovi>()
                .HasOne(fz => fz.Film)
                .WithMany(f => f.FilmoviZanrovi)
                .HasForeignKey(fz => fz.FilmId);

            modelBuilder.Entity<FilmoviZanrovi>()
                .HasOne(fz => fz.Zanr)
                .WithMany(z => z.FilmoviZanrovi)
                .HasForeignKey(fz => fz.ZanrId);

            modelBuilder.Entity<Recenzije>()
                .HasOne(r => r.Korisnik)
                .WithMany(k => k.Recenzije)
                .HasForeignKey(r => r.KorisnikId)
                .OnDelete(DeleteBehavior.Restrict);

            modelBuilder.Entity<Recenzije>()
                .HasOne(r => r.Film)
                .WithMany(f => f.Recenzije)
                .HasForeignKey(r => r.FilmId)
                .OnDelete(DeleteBehavior.Cascade);

            modelBuilder.Entity<Watchlist>()
                .HasOne(w => w.Korisnik)
                .WithMany(k => k.Watchlist)
                .HasForeignKey(w => w.KorisnikId)
                .OnDelete(DeleteBehavior.Cascade);

            modelBuilder.Entity<Watchlist>()
                .HasOne(w => w.Film)
                .WithMany(f => f.Watchlist)
                .HasForeignKey(w => w.FilmId)
                .OnDelete(DeleteBehavior.Cascade);

            modelBuilder.Entity<Pratitelji>()
                .HasOne(p => p.Korisnik)
                .WithMany(k => k.Pratioci)
                .HasForeignKey(p => p.KorisnikId)
                .OnDelete(DeleteBehavior.Restrict);

            modelBuilder.Entity<Pratitelji>()
                .HasOne(p => p.Pratitelj)
                .WithMany(k => k.Pratim)
                .HasForeignKey(p => p.PratiteljId)
                .OnDelete(DeleteBehavior.Restrict);

            modelBuilder.Entity<Poruke>()
                .HasOne(p => p.Posiljatelj)
                .WithMany(k => k.PoslanePoruke)
                .HasForeignKey(p => p.PosiljateljId)
                .OnDelete(DeleteBehavior.Restrict);

            modelBuilder.Entity<Poruke>()
                .HasOne(p => p.Primatelj)
                .WithMany(k => k.PrimljenePoruke)
                .HasForeignKey(p => p.PrimateljId)
                .OnDelete(DeleteBehavior.Restrict);

            modelBuilder.Entity<Novosti>()
                .HasOne(n => n.Autor)
                .WithMany(k => k.Novosti)
                .HasForeignKey(n => n.AutorId)
                .OnDelete(DeleteBehavior.Restrict);

            modelBuilder.Entity<Zalbe>()
                .HasOne(z => z.Recenzija)
                .WithMany()
                .HasForeignKey(z => z.RecenzijaId)
                .OnDelete(DeleteBehavior.Cascade);

            modelBuilder.Entity<Zalbe>()
                .HasOne(z => z.Korisnik)
                .WithMany()
                .HasForeignKey(z => z.KorisnikId)
                .OnDelete(DeleteBehavior.Restrict);

            modelBuilder.Entity<Zalbe>()
                .HasOne(z => z.ObradioPrijavu)
                .WithMany()
                .HasForeignKey(z => z.ObradioPrijavuId)
                .OnDelete(DeleteBehavior.Restrict);

            modelBuilder.Entity<KlubFilmova>()
                .HasOne(k => k.Vlasnik)
                .WithMany()
                .HasForeignKey(k => k.VlasnikId)
                .OnDelete(DeleteBehavior.Restrict);

            modelBuilder.Entity<KlubFilmovaClanovi>()
                .HasOne(c => c.Klub)
                .WithMany(k => k.Clanovi)
                .HasForeignKey(c => c.KlubId)
                .OnDelete(DeleteBehavior.Cascade);

            modelBuilder.Entity<KlubFilmovaClanovi>()
                .HasOne(c => c.Korisnik)
                .WithMany()
                .HasForeignKey(c => c.KorisnikId)
                .OnDelete(DeleteBehavior.Restrict);

            modelBuilder.Entity<Pretplate>()
                .HasOne(p => p.Korisnik)
                .WithMany()
                .HasForeignKey(p => p.KorisnikId)
                .OnDelete(DeleteBehavior.Cascade);

            modelBuilder.Entity<Favoriti>()
                .HasOne(f => f.Korisnik)
                .WithMany(k => k.Favoriti)
                .HasForeignKey(f => f.KorisnikId)
                .OnDelete(DeleteBehavior.Cascade);

            modelBuilder.Entity<Favoriti>()
                .HasOne(f => f.Film)
                .WithMany(f => f.Favoriti)
                .HasForeignKey(f => f.FilmId)
                .OnDelete(DeleteBehavior.Cascade);

            modelBuilder.Entity<Favoriti>()
                .HasIndex(f => new { f.KorisnikId, f.FilmId })
                .IsUnique();

            modelBuilder.Entity<FilmoviLajkovi>()
                .HasOne(fl => fl.Korisnik)
                .WithMany(k => k.FilmoviLajkovi)
                .HasForeignKey(fl => fl.KorisnikId)
                .OnDelete(DeleteBehavior.Cascade);

            modelBuilder.Entity<FilmoviLajkovi>()
                .HasOne(fl => fl.Film)
                .WithMany(f => f.Lajkovi)
                .HasForeignKey(fl => fl.FilmId)
                .OnDelete(DeleteBehavior.Cascade);

            modelBuilder.Entity<FilmoviLajkovi>()
                .HasIndex(fl => new { fl.KorisnikId, fl.FilmId })
                .IsUnique();

            modelBuilder.Entity<KlubObjave>()
                .HasOne(ko => ko.Klub)
                .WithMany(k => k.Objave)
                .HasForeignKey(ko => ko.KlubId)
                .OnDelete(DeleteBehavior.Cascade);

            modelBuilder.Entity<KlubObjave>()
                .HasOne(ko => ko.Korisnik)
                .WithMany(k => k.KlubObjave)
                .HasForeignKey(ko => ko.KorisnikId)
                .OnDelete(DeleteBehavior.Restrict);

            modelBuilder.Entity<KlubKomentari>()
                .HasOne(kk => kk.Objava)
                .WithMany(o => o.Komentari)
                .HasForeignKey(kk => kk.ObjavaId)
                .OnDelete(DeleteBehavior.Cascade);

            modelBuilder.Entity<KlubKomentari>()
                .HasOne(kk => kk.Korisnik)
                .WithMany(k => k.KlubKomentari)
                .HasForeignKey(kk => kk.KorisnikId)
                .OnDelete(DeleteBehavior.Restrict);

            modelBuilder.Entity<KlubKomentari>()
                .HasOne(kk => kk.ParentKomentar)
                .WithMany()
                .HasForeignKey(kk => kk.ParentKomentarId)
                .OnDelete(DeleteBehavior.Restrict);

            modelBuilder.Entity<KlubLajkovi>()
                .HasOne(kl => kl.Objava)
                .WithMany(o => o.Lajkovi)
                .HasForeignKey(kl => kl.ObjavaId)
                .OnDelete(DeleteBehavior.Cascade);

            modelBuilder.Entity<KlubLajkovi>()
                .HasOne(kl => kl.Korisnik)
                .WithMany(k => k.KlubLajkovi)
                .HasForeignKey(kl => kl.KorisnikId)
                .OnDelete(DeleteBehavior.Restrict);

            modelBuilder.Entity<KlubLajkovi>()
                .HasIndex(kl => new { kl.KorisnikId, kl.ObjavaId })
                .IsUnique();

            modelBuilder.Entity<Obavijesti>()
                .HasOne(o => o.Posiljatelj)
                .WithMany()
                .HasForeignKey(o => o.PosiljateljId)
                .OnDelete(DeleteBehavior.Restrict);

            modelBuilder.Entity<Obavijesti>()
                .HasOne(o => o.Primatelj)
                .WithMany()
                .HasForeignKey(o => o.PrimateljId)
                .OnDelete(DeleteBehavior.Restrict);

            modelBuilder.Entity<Obavijesti>()
                .HasOne(o => o.Klub)
                .WithMany()
                .HasForeignKey(o => o.KlubId)
                .OnDelete(DeleteBehavior.Cascade);

            SeedData(modelBuilder);
        }

        private void SeedData(ModelBuilder modelBuilder)
        {
            modelBuilder.Entity<Uloge>().HasData(
                new Uloge { Id = 1, Naziv = "Administrator", Opis = "Administrator sistema" },
                new Uloge { Id = 2, Naziv = "Korisnik", Opis = "Standardni korisnik" },
                new Uloge { Id = 3, Naziv = "PremiumKorisnik", Opis = "Premium korisnik sa dodatnim privilegijama" }
            );

            var salt = GenerateSalt();
            var hash = GenerateHash(salt, "string");

            modelBuilder.Entity<Korisnici>().HasData(
                new Korisnici
                {
                    Id = 1,
                    Ime = "Admin",
                    Prezime = "Admin",
                    Email = "admin@stagledas.com",
                    KorisnickoIme = "admin",
                    Telefon = "061000000",
                    LozinkaHash = hash,
                    LozinkaSalt = salt,
                    Status = true,
                    IsPremium = false,
                    IsDeleted = false,
                    DatumKreiranja = new DateTime(2025, 1, 1),
                    DatumIzmjene = new DateTime(2025, 1, 1)
                },
                new Korisnici
                {
                    Id = 2,
                    Ime = "Test",
                    Prezime = "User",
                    Email = "test@stagledas.com",
                    KorisnickoIme = "test",
                    Telefon = "062000000",
                    LozinkaHash = hash,
                    LozinkaSalt = salt,
                    Status = true,
                    IsPremium = true,
                    IsDeleted = false,
                    DatumKreiranja = new DateTime(2025, 1, 1),
                    DatumIzmjene = new DateTime(2025, 1, 1)
                }
            );

            modelBuilder.Entity<KorisniciUloge>().HasData(
                new KorisniciUloge { Id = 1, KorisnikId = 1, UlogaId = 1 },
                new KorisniciUloge { Id = 2, KorisnikId = 2, UlogaId = 2 },
                new KorisniciUloge { Id = 3, KorisnikId = 2, UlogaId = 3 }
            );

            modelBuilder.Entity<Zanrovi>().HasData(
                new Zanrovi { Id = 1, Naziv = "Akcija", Opis = "Akcioni filmovi" },
                new Zanrovi { Id = 2, Naziv = "Komedija", Opis = "Komicni filmovi" },
                new Zanrovi { Id = 3, Naziv = "Drama", Opis = "Dramski filmovi" },
                new Zanrovi { Id = 4, Naziv = "Horor", Opis = "Horor filmovi" },
                new Zanrovi { Id = 5, Naziv = "Sci-Fi", Opis = "Naucna fantastika" },
                new Zanrovi { Id = 6, Naziv = "Triler", Opis = "Triler filmovi" },
                new Zanrovi { Id = 7, Naziv = "Romantika", Opis = "Romantični filmovi" },
                new Zanrovi { Id = 8, Naziv = "Animirani", Opis = "Animirani filmovi" }
            );

            modelBuilder.Entity<Filmovi>().HasData(
                new Filmovi
                {
                    Id = 1,
                    Naslov = "Inception",
                    Opis = "A thief who steals corporate secrets through dream-sharing technology.",
                    GodinaIzdanja = 2010,
                    Trajanje = 148,
                    Reziser = "Christopher Nolan",
                    ProsjecnaOcjena = 4.5,
                    BrojOcjena = 100,
                    BrojPregleda = 500,
                    DatumKreiranja = new DateTime(2025, 1, 1),
                    DatumIzmjene = new DateTime(2025, 1, 1)
                },
                new Filmovi
                {
                    Id = 2,
                    Naslov = "The Wolf of Wall Street",
                    Opis = "Based on the true story of Jordan Belfort.",
                    GodinaIzdanja = 2013,
                    Trajanje = 180,
                    Reziser = "Martin Scorsese",
                    ProsjecnaOcjena = 4.2,
                    BrojOcjena = 80,
                    BrojPregleda = 400,
                    DatumKreiranja = new DateTime(2025, 1, 1),
                    DatumIzmjene = new DateTime(2025, 1, 1)
                },
                new Filmovi
                {
                    Id = 3,
                    Naslov = "Once Upon a Time in Hollywood",
                    Opis = "A faded television actor and his stunt double strive to achieve fame.",
                    GodinaIzdanja = 2019,
                    Trajanje = 161,
                    Reziser = "Quentin Tarantino",
                    ProsjecnaOcjena = 4.0,
                    BrojOcjena = 60,
                    BrojPregleda = 300,
                    DatumKreiranja = new DateTime(2025, 1, 1),
                    DatumIzmjene = new DateTime(2025, 1, 1)
                }
            );

            modelBuilder.Entity<FilmoviZanrovi>().HasData(
                new FilmoviZanrovi { Id = 1, FilmId = 1, ZanrId = 1 },
                new FilmoviZanrovi { Id = 2, FilmId = 1, ZanrId = 5 },
                new FilmoviZanrovi { Id = 3, FilmId = 1, ZanrId = 6 },
                new FilmoviZanrovi { Id = 4, FilmId = 2, ZanrId = 2 },
                new FilmoviZanrovi { Id = 5, FilmId = 2, ZanrId = 3 },
                new FilmoviZanrovi { Id = 6, FilmId = 3, ZanrId = 2 },
                new FilmoviZanrovi { Id = 7, FilmId = 3, ZanrId = 3 }
            );

            modelBuilder.Entity<Novosti>().HasData(
                new Novosti
                {
                    Id = 1,
                    Naslov = "Oscars 2025: Najbolji filmovi godine",
                    Sadrzaj = "Pregled nominacija za Oscara 2025. Saznajte koji filmovi su u utrci za najvaznije filmske nagrade.",
                    AutorId = 1,
                    BrojPregleda = 150,
                    DatumKreiranja = new DateTime(2025, 1, 15)
                },
                new Novosti
                {
                    Id = 2,
                    Naslov = "Novi Nolan film najavljljen za 2026",
                    Sadrzaj = "Christopher Nolan najavio je svoj novi projekt koji ce biti objavljen 2026. godine.",
                    AutorId = 1,
                    BrojPregleda = 230,
                    DatumKreiranja = new DateTime(2025, 1, 10)
                }
            );

            modelBuilder.Entity<Recenzije>().HasData(
                new Recenzije
                {
                    Id = 1,
                    KorisnikId = 2,
                    FilmId = 1,
                    Ocjena = 5,
                    Naslov = "Remek djelo!",
                    Sadrzaj = "Inception je jedan od najboljih filmova koje sam ikada gledao. Nolan je genij.",
                    DatumKreiranja = new DateTime(2025, 1, 5)
                },
                new Recenzije
                {
                    Id = 2,
                    KorisnikId = 2,
                    FilmId = 2,
                    Ocjena = 4,
                    Naslov = "Odlicna gluma",
                    Sadrzaj = "DiCaprio je bio nevjerovatan u ulozi Jordan Belforta.",
                    DatumKreiranja = new DateTime(2025, 1, 6)
                }
            );

            modelBuilder.Entity<Zalbe>().HasData(
                new Zalbe
                {
                    Id = 1,
                    RecenzijaId = 1,
                    KorisnikId = 1,
                    Razlog = "Neprimjeren sadržaj",
                    Opis = "Recenzija sadrži uvredljive komentare.",
                    Status = "pending",
                    DatumKreiranja = new DateTime(2025, 1, 7)
                },
                new Zalbe
                {
                    Id = 2,
                    RecenzijaId = 2,
                    KorisnikId = 1,
                    Razlog = "Spoiler bez upozorenja",
                    Opis = "Korisnik je otkrio ključne dijelove radnje bez spoiler upozorenja.",
                    Status = "pending",
                    DatumKreiranja = new DateTime(2025, 1, 8)
                },
                new Zalbe
                {
                    Id = 3,
                    RecenzijaId = 1,
                    KorisnikId = 2,
                    Razlog = "Lažne informacije",
                    Opis = "Recenzija sadrži netočne informacije o filmu.",
                    Status = "approved",
                    DatumKreiranja = new DateTime(2025, 1, 5),
                    DatumObrade = new DateTime(2025, 1, 6),
                    ObradioPrijavuId = 1
                },
                new Zalbe
                {
                    Id = 4,
                    RecenzijaId = 2,
                    KorisnikId = 2,
                    Razlog = "Spam",
                    Opis = "Recenzija je očigledno promotivni sadržaj.",
                    Status = "rejected",
                    DatumKreiranja = new DateTime(2025, 1, 4),
                    DatumObrade = new DateTime(2025, 1, 5),
                    ObradioPrijavuId = 1
                }
            );
        }

        public static string GenerateSalt()
        {
            var provider = new RNGCryptoServiceProvider();
            var byteArray = new byte[16];
            provider.GetBytes(byteArray);
            return Convert.ToBase64String(byteArray);
        }

        public static string GenerateHash(string salt, string password)
        {
            byte[] src = Convert.FromBase64String(salt);
            byte[] bytes = Encoding.Unicode.GetBytes(password);
            byte[] dst = new byte[src.Length + bytes.Length];

            Buffer.BlockCopy(src, 0, dst, 0, src.Length);
            Buffer.BlockCopy(bytes, 0, dst, src.Length, bytes.Length);

            HashAlgorithm algorithm = HashAlgorithm.Create("SHA1")!;
            byte[] inArray = algorithm.ComputeHash(dst);

            return Convert.ToBase64String(inArray);
        }
    }
}
