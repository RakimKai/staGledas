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

            modelBuilder.Entity<Recenzije>()
                .HasOne(r => r.Film)
                .WithMany(f => f.Recenzije)
                .HasForeignKey(r => r.FilmId);

            modelBuilder.Entity<Recenzije>()
                .HasOne(r => r.Korisnik)
                .WithMany()
                .HasForeignKey(r => r.KorisnikId);

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
                    IsPremium = false,
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

            modelBuilder.Entity<Filmovi>().HasData(
                new Filmovi
                {
                    Id = 1,
                    TmdbId = 27205,
                    Naslov = "Inception",
                    Opis = "Cobb, a skilled thief who commits corporate espionage by infiltrating the subconscious of his targets is offered a chance to regain his old life as payment for a task considered to be impossible: inception.",
                    GodinaIzdanja = 2010,
                    Trajanje = 148,
                    Reziser = "Christopher Nolan",
                    PosterPath = "/ljsZTbVsrQSqZgWeep2B1QiDKuh.jpg",
                    ProsjecnaOcjena = 4.2,
                    BrojOcjena = 3,
                    BrojPregleda = 500,
                    DatumKreiranja = new DateTime(2025, 1, 1),
                    DatumIzmjene = new DateTime(2025, 1, 1)
                },
                new Filmovi
                {
                    Id = 2,
                    TmdbId = 278,
                    Naslov = "The Shawshank Redemption",
                    Opis = "Imprisoned in the 1940s for the double murder of his wife and her lover, upstanding banker Andy Dufresne begins a new life at the Shawshank prison.",
                    GodinaIzdanja = 1994,
                    Trajanje = 142,
                    Reziser = "Frank Darabont",
                    PosterPath = "/9cqNxx0GxF0bflZmeSMuL5tnGzr.jpg",
                    ProsjecnaOcjena = 4.7,
                    BrojOcjena = 2,
                    BrojPregleda = 450,
                    DatumKreiranja = new DateTime(2025, 1, 1),
                    DatumIzmjene = new DateTime(2025, 1, 1)
                },
                new Filmovi
                {
                    Id = 3,
                    TmdbId = 238,
                    Naslov = "The Godfather",
                    Opis = "Spanning the years 1945 to 1955, a chronicle of the fictional Italian-American Corleone crime family.",
                    GodinaIzdanja = 1972,
                    Trajanje = 175,
                    Reziser = "Francis Ford Coppola",
                    PosterPath = "/3bhkrj58Vtu7enYsRolD1fZdja1.jpg",
                    ProsjecnaOcjena = 4.4,
                    BrojOcjena = 2,
                    BrojPregleda = 400,
                    DatumKreiranja = new DateTime(2025, 1, 1),
                    DatumIzmjene = new DateTime(2025, 1, 1)
                },
                new Filmovi
                {
                    Id = 4,
                    TmdbId = 155,
                    Naslov = "The Dark Knight",
                    Opis = "Batman raises the stakes in his war on crime. With the help of Lt. Jim Gordon and District Attorney Harvey Dent, Batman sets out to dismantle the remaining criminal organizations.",
                    GodinaIzdanja = 2008,
                    Trajanje = 152,
                    Reziser = "Christopher Nolan",
                    PosterPath = "/qJ2tW6WMUDux911r6m7haRef0WH.jpg",
                    ProsjecnaOcjena = 4.3,
                    BrojOcjena = 2,
                    BrojPregleda = 480,
                    DatumKreiranja = new DateTime(2025, 1, 1),
                    DatumIzmjene = new DateTime(2025, 1, 1)
                },
                new Filmovi
                {
                    Id = 5,
                    TmdbId = 680,
                    Naslov = "Pulp Fiction",
                    Opis = "A burger-loving hit man, his philosophical partner, a drug-addled gangster's moll and a washed-up boxer converge in this sprawling, comedic crime caper.",
                    GodinaIzdanja = 1994,
                    Trajanje = 154,
                    Reziser = "Quentin Tarantino",
                    PosterPath = "/d5iIlFn5s0ImszYzBPb8JPIfbXD.jpg",
                    ProsjecnaOcjena = 4.3,
                    BrojOcjena = 1,
                    BrojPregleda = 420,
                    DatumKreiranja = new DateTime(2025, 1, 1),
                    DatumIzmjene = new DateTime(2025, 1, 1)
                },
                new Filmovi
                {
                    Id = 6,
                    TmdbId = 157336,
                    Naslov = "Interstellar",
                    Opis = "The adventures of a group of explorers who make use of a newly discovered wormhole to surpass the limitations on human space travel and conquer the vast distances involved in an interstellar voyage.",
                    GodinaIzdanja = 2014,
                    Trajanje = 169,
                    Reziser = "Christopher Nolan",
                    PosterPath = "/gEU2QniE6E77NI6lCU6MxlNBvIx.jpg",
                    ProsjecnaOcjena = 4.4,
                    BrojOcjena = 0,
                    BrojPregleda = 380,
                    DatumKreiranja = new DateTime(2025, 1, 1),
                    DatumIzmjene = new DateTime(2025, 1, 1)
                },
                new Filmovi
                {
                    Id = 7,
                    TmdbId = 603,
                    Naslov = "The Matrix",
                    Opis = "Set in the 22nd century, The Matrix tells the story of a computer hacker who joins a group of underground insurgents fighting the vast and powerful computers who now rule the earth.",
                    GodinaIzdanja = 1999,
                    Trajanje = 136,
                    Reziser = "Lana Wachowski",
                    PosterPath = "/f89U3ADr1oiB1s9GkdPOEpXUk5H.jpg",
                    ProsjecnaOcjena = 4.3,
                    BrojOcjena = 0,
                    BrojPregleda = 350,
                    DatumKreiranja = new DateTime(2025, 1, 1),
                    DatumIzmjene = new DateTime(2025, 1, 1)
                },
                new Filmovi
                {
                    Id = 8,
                    TmdbId = 550,
                    Naslov = "Fight Club",
                    Opis = "A ticking-Loss time bomb insomniac and a slippery soap salesman channel primal male aggression into a shocking new form of therapy.",
                    GodinaIzdanja = 1999,
                    Trajanje = 139,
                    Reziser = "David Fincher",
                    PosterPath = "/pB8BM7pdSp6B6Ih7QZ4DrQ3PmJK.jpg",
                    ProsjecnaOcjena = 4.4,
                    BrojOcjena = 0,
                    BrojPregleda = 360,
                    DatumKreiranja = new DateTime(2025, 1, 1),
                    DatumIzmjene = new DateTime(2025, 1, 1)
                },
                new Filmovi
                {
                    Id = 9,
                    TmdbId = 13,
                    Naslov = "Forrest Gump",
                    Opis = "A man with a low IQ has accomplished great things in his life and been present during significant historic events—in each case, far exceeding what anyone imagined he could do.",
                    GodinaIzdanja = 1994,
                    Trajanje = 142,
                    Reziser = "Robert Zemeckis",
                    PosterPath = "/arw2vcBveWOVZr6pxd9XTd1TdQa.jpg",
                    ProsjecnaOcjena = 4.5,
                    BrojOcjena = 0,
                    BrojPregleda = 400,
                    DatumKreiranja = new DateTime(2025, 1, 1),
                    DatumIzmjene = new DateTime(2025, 1, 1)
                },
                new Filmovi
                {
                    Id = 10,
                    TmdbId = 497,
                    Naslov = "The Green Mile",
                    Opis = "A supernatural tale set on death row in a Southern prison, where gentle giant John Coffey possesses the mysterious power to heal people's ailments.",
                    GodinaIzdanja = 1999,
                    Trajanje = 189,
                    Reziser = "Frank Darabont",
                    PosterPath = "/velWPhVMQeQKcxggNEU8YmIo52R.jpg",
                    ProsjecnaOcjena = 4.5,
                    BrojOcjena = 0,
                    BrojPregleda = 320,
                    DatumKreiranja = new DateTime(2025, 1, 1),
                    DatumIzmjene = new DateTime(2025, 1, 1)
                }
            );

            modelBuilder.Entity<Novosti>().HasData(
                new Novosti
                {
                    Id = 1,
                    Naslov = "Oscari 2025: Kompletna lista nominacija",
                    Sadrzaj = "Akademija filmskih umjetnosti i nauka objavila je nominacije za 97. dodjelu Oscara. Anora predvodi sa 6 nominacija, a The Brutalist i Emilia Perez prate sa po 10 nominacija. Ceremonija dodjele održat će se 2. marta 2025. u Dolby Theatreu u Los Angelesu.",
                    AutorId = 1,
                    BrojPregleda = 1250,
                    DatumKreiranja = new DateTime(2025, 1, 15)
                },
                new Novosti
                {
                    Id = 2,
                    Naslov = "Christopher Nolan najavio novi film za 2026.",
                    Sadrzaj = "Nakon uspjeha Oppenheimera, Christopher Nolan vraća se sa novim projektom. Film će biti snimljen u IMAX formatu i prema najavama radi se o originalnoj priči. Universal Pictures potvrdio je datum premijere za juli 2026. godine.",
                    AutorId = 1,
                    BrojPregleda = 890,
                    DatumKreiranja = new DateTime(2025, 1, 10)
                },
                new Novosti
                {
                    Id = 3,
                    Naslov = "Martin Scorsese priprema dokumentarac o klasičnom Hollywoodu",
                    Sadrzaj = "Legendarni reditelj Martin Scorsese najavio je novi dokumentarni film koji će istražiti zlatno doba Hollywooda 1940-ih i 1950-ih godina. Projekt će uključivati rijetke arhivske snimke i intervjue sa preživjelim legendama iz tog perioda.",
                    AutorId = 1,
                    BrojPregleda = 567,
                    DatumKreiranja = new DateTime(2025, 1, 8)
                },
                new Novosti
                {
                    Id = 4,
                    Naslov = "Streaming platforme dominiraju box office",
                    Sadrzaj = "Analiza filmske industrije pokazuje da streaming platforme nastavljaju transformirati način na koji gledamo filmove. Netflix, Amazon Prime i Apple TV+ ulažu rekordne budžete u originalne produkcije, dok tradicionalni studiji traže nove strategije za privlačenje publike u kina.",
                    AutorId = 1,
                    BrojPregleda = 432,
                    DatumKreiranja = new DateTime(2025, 1, 5)
                }
            );

            modelBuilder.Entity<Recenzije>().HasData(
                new Recenzije
                {
                    Id = 1,
                    KorisnikId = 1,
                    FilmId = 1,
                    Ocjena = 4.5,
                    Naslov = "Remek djelo modernog filma",
                    Sadrzaj = "Inception je vizualno zapanjujući film koji uspijeva kombinirati akciju sa dubokim filozofskim pitanjima o prirodi stvarnosti i snova. Nolan je stvorio jedinstveno filmsko iskustvo.",
                    ImaSpoiler = false,
                    IsHidden = false,
                    DatumKreiranja = new DateTime(2025, 1, 5)
                },
                new Recenzije
                {
                    Id = 2,
                    KorisnikId = 1,
                    FilmId = 3,
                    Ocjena = 4.0,
                    Naslov = "Filmska historija",
                    Sadrzaj = "The Godfather je više od filma - to je kulturni fenomen koji je utjecao na generacije filmskih stvaralaca. Obavezno gledanje za svakog ljubitelja filma.",
                    ImaSpoiler = false,
                    IsHidden = false,
                    DatumKreiranja = new DateTime(2025, 1, 6)
                },
                new Recenzije
                {
                    Id = 3,
                    KorisnikId = 1,
                    FilmId = 4,
                    Ocjena = 4.5,
                    Naslov = "Najbolji Batman film",
                    Sadrzaj = "Nolan je transformirao Batman franšizu u nešto potpuno novo. Mračan, realističan i napeto režiran od početka do kraja.",
                    ImaSpoiler = false,
                    IsHidden = false,
                    DatumKreiranja = new DateTime(2025, 1, 7)
                },
                new Recenzije
                {
                    Id = 4,
                    KorisnikId = 2,
                    FilmId = 2,
                    Ocjena = 5.0,
                    Naslov = "Najbolji film svih vremena",
                    Sadrzaj = "The Shawshank Redemption je dirljiva priča o nadi i prijateljstvu. Tim Robbins i Morgan Freeman su nevjerovatni u svojim ulogama. Film koji vas nikad neće napustiti.",
                    ImaSpoiler = false,
                    IsHidden = false,
                    DatumKreiranja = new DateTime(2025, 1, 8)
                },
                new Recenzije
                {
                    Id = 5,
                    KorisnikId = 2,
                    FilmId = 5,
                    Ocjena = 4.5,
                    Naslov = "Tarantinov potpis",
                    Sadrzaj = "Pulp Fiction je revolucionirao nezavisni film 90-ih. Dijalozi su briljantni, struktura inovativna, a soundtrack savršen. Film koji zahtijeva višestruka gledanja.",
                    ImaSpoiler = false,
                    IsHidden = false,
                    DatumKreiranja = new DateTime(2025, 1, 9)
                }
            );

            modelBuilder.Entity<Watchlist>().HasData(
                new Watchlist
                {
                    Id = 1,
                    KorisnikId = 1,
                    FilmId = 1,
                    DatumDodavanja = new DateTime(2025, 1, 5),
                    Pogledano = true,
                    DatumGledanja = new DateTime(2025, 1, 6)
                },
                new Watchlist
                {
                    Id = 2,
                    KorisnikId = 1,
                    FilmId = 4,
                    DatumDodavanja = new DateTime(2025, 1, 7),
                    Pogledano = true,
                    DatumGledanja = new DateTime(2025, 1, 8)
                },
                new Watchlist
                {
                    Id = 3,
                    KorisnikId = 1,
                    FilmId = 3,
                    DatumDodavanja = new DateTime(2025, 1, 9),
                    Pogledano = true,
                    DatumGledanja = new DateTime(2025, 1, 10)
                },
                new Watchlist
                {
                    Id = 4,
                    KorisnikId = 1,
                    FilmId = 6,
                    DatumDodavanja = new DateTime(2025, 1, 11),
                    Pogledano = true,
                    DatumGledanja = new DateTime(2025, 1, 12)
                },
                new Watchlist
                {
                    Id = 5,
                    KorisnikId = 1,
                    FilmId = 7,
                    DatumDodavanja = new DateTime(2025, 1, 13),
                    Pogledano = true,
                    DatumGledanja = new DateTime(2025, 1, 14)
                },
                new Watchlist
                {
                    Id = 6,
                    KorisnikId = 2,
                    FilmId = 2,
                    DatumDodavanja = new DateTime(2025, 1, 5),
                    Pogledano = true,
                    DatumGledanja = new DateTime(2025, 1, 6)
                },
                new Watchlist
                {
                    Id = 7,
                    KorisnikId = 2,
                    FilmId = 5,
                    DatumDodavanja = new DateTime(2025, 1, 7),
                    Pogledano = true,
                    DatumGledanja = new DateTime(2025, 1, 8)
                },
                new Watchlist
                {
                    Id = 8,
                    KorisnikId = 2,
                    FilmId = 8,
                    DatumDodavanja = new DateTime(2025, 1, 9),
                    Pogledano = true,
                    DatumGledanja = new DateTime(2025, 1, 10)
                },
                new Watchlist
                {
                    Id = 9,
                    KorisnikId = 2,
                    FilmId = 9,
                    DatumDodavanja = new DateTime(2025, 1, 11),
                    Pogledano = true,
                    DatumGledanja = new DateTime(2025, 1, 12)
                }
            );

            modelBuilder.Entity<FilmoviLajkovi>().HasData(
                new FilmoviLajkovi
                {
                    Id = 1,
                    KorisnikId = 1,
                    FilmId = 1,
                    DatumLajka = new DateTime(2025, 1, 6)
                },
                new FilmoviLajkovi
                {
                    Id = 2,
                    KorisnikId = 1,
                    FilmId = 4,
                    DatumLajka = new DateTime(2025, 1, 8)
                },
                new FilmoviLajkovi
                {
                    Id = 3,
                    KorisnikId = 1,
                    FilmId = 3,
                    DatumLajka = new DateTime(2025, 1, 10)
                },
                new FilmoviLajkovi
                {
                    Id = 4,
                    KorisnikId = 1,
                    FilmId = 6,
                    DatumLajka = new DateTime(2025, 1, 12)
                },
                new FilmoviLajkovi
                {
                    Id = 5,
                    KorisnikId = 1,
                    FilmId = 7,
                    DatumLajka = new DateTime(2025, 1, 14)
                },
                new FilmoviLajkovi
                {
                    Id = 6,
                    KorisnikId = 2,
                    FilmId = 2,
                    DatumLajka = new DateTime(2025, 1, 6)
                },
                new FilmoviLajkovi
                {
                    Id = 7,
                    KorisnikId = 2,
                    FilmId = 5,
                    DatumLajka = new DateTime(2025, 1, 8)
                },
                new FilmoviLajkovi
                {
                    Id = 8,
                    KorisnikId = 2,
                    FilmId = 8,
                    DatumLajka = new DateTime(2025, 1, 10)
                },
                new FilmoviLajkovi
                {
                    Id = 9,
                    KorisnikId = 2,
                    FilmId = 9,
                    DatumLajka = new DateTime(2025, 1, 12)
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
