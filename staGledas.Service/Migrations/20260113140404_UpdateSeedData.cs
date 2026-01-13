using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

#pragma warning disable CA1814 // Prefer jagged arrays over multidimensional

namespace staGledas.Service.Migrations
{
    /// <inheritdoc />
    public partial class UpdateSeedData : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DeleteData(
                table: "FilmoviZanrovi",
                keyColumn: "Id",
                keyValue: 1);

            migrationBuilder.DeleteData(
                table: "FilmoviZanrovi",
                keyColumn: "Id",
                keyValue: 2);

            migrationBuilder.DeleteData(
                table: "FilmoviZanrovi",
                keyColumn: "Id",
                keyValue: 3);

            migrationBuilder.DeleteData(
                table: "FilmoviZanrovi",
                keyColumn: "Id",
                keyValue: 4);

            migrationBuilder.DeleteData(
                table: "FilmoviZanrovi",
                keyColumn: "Id",
                keyValue: 5);

            migrationBuilder.DeleteData(
                table: "FilmoviZanrovi",
                keyColumn: "Id",
                keyValue: 6);

            migrationBuilder.DeleteData(
                table: "FilmoviZanrovi",
                keyColumn: "Id",
                keyValue: 7);

            migrationBuilder.DeleteData(
                table: "Zalbe",
                keyColumn: "Id",
                keyValue: 4);

            migrationBuilder.DeleteData(
                table: "Zanrovi",
                keyColumn: "Id",
                keyValue: 4);

            migrationBuilder.DeleteData(
                table: "Zanrovi",
                keyColumn: "Id",
                keyValue: 7);

            migrationBuilder.DeleteData(
                table: "Zanrovi",
                keyColumn: "Id",
                keyValue: 8);

            migrationBuilder.DeleteData(
                table: "Zanrovi",
                keyColumn: "Id",
                keyValue: 1);

            migrationBuilder.DeleteData(
                table: "Zanrovi",
                keyColumn: "Id",
                keyValue: 2);

            migrationBuilder.DeleteData(
                table: "Zanrovi",
                keyColumn: "Id",
                keyValue: 3);

            migrationBuilder.DeleteData(
                table: "Zanrovi",
                keyColumn: "Id",
                keyValue: 5);

            migrationBuilder.DeleteData(
                table: "Zanrovi",
                keyColumn: "Id",
                keyValue: 6);

            migrationBuilder.UpdateData(
                table: "Filmovi",
                keyColumn: "Id",
                keyValue: 1,
                columns: new[] { "BrojOcjena", "Opis", "PosterPath", "ProsjecnaOcjena", "TmdbId" },
                values: new object[] { 3, "Cobb, a skilled thief who commits corporate espionage by infiltrating the subconscious of his targets is offered a chance to regain his old life as payment for a task considered to be impossible: inception.", "/ljsZTbVsrQSqZgWeep2B1QiDKuh.jpg", 4.2000000000000002, 27205 });

            migrationBuilder.UpdateData(
                table: "Filmovi",
                keyColumn: "Id",
                keyValue: 2,
                columns: new[] { "BrojOcjena", "BrojPregleda", "GodinaIzdanja", "Naslov", "Opis", "PosterPath", "ProsjecnaOcjena", "Reziser", "TmdbId", "Trajanje" },
                values: new object[] { 2, 450, 1994, "The Shawshank Redemption", "Imprisoned in the 1940s for the double murder of his wife and her lover, upstanding banker Andy Dufresne begins a new life at the Shawshank prison.", "/9cqNxx0GxF0bflZmeSMuL5tnGzr.jpg", 4.7000000000000002, "Frank Darabont", 278, 142 });

            migrationBuilder.UpdateData(
                table: "Filmovi",
                keyColumn: "Id",
                keyValue: 3,
                columns: new[] { "BrojOcjena", "BrojPregleda", "GodinaIzdanja", "Naslov", "Opis", "PosterPath", "ProsjecnaOcjena", "Reziser", "TmdbId", "Trajanje" },
                values: new object[] { 2, 400, 1972, "The Godfather", "Spanning the years 1945 to 1955, a chronicle of the fictional Italian-American Corleone crime family.", "/3bhkrj58Vtu7enYsRolD1fZdja1.jpg", 4.4000000000000004, "Francis Ford Coppola", 238, 175 });

            migrationBuilder.InsertData(
                table: "Filmovi",
                columns: new[] { "Id", "BrojLajkova", "BrojOcjena", "BrojPregleda", "DatumIzmjene", "DatumKreiranja", "GodinaIzdanja", "Naslov", "Opis", "PosterPath", "ProsjecnaOcjena", "Reziser", "TmdbId", "Trajanje" },
                values: new object[,]
                {
                    { 4, null, 2, 480, new DateTime(2025, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified), new DateTime(2025, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified), 2008, "The Dark Knight", "Batman raises the stakes in his war on crime. With the help of Lt. Jim Gordon and District Attorney Harvey Dent, Batman sets out to dismantle the remaining criminal organizations.", "/qJ2tW6WMUDux911r6m7haRef0WH.jpg", 4.2999999999999998, "Christopher Nolan", 155, 152 },
                    { 5, null, 2, 420, new DateTime(2025, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified), new DateTime(2025, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified), 1994, "Pulp Fiction", "A burger-loving hit man, his philosophical partner, a drug-addled gangster's moll and a washed-up boxer converge in this sprawling, comedic crime caper.", "/d5iIlFn5s0ImszYzBPb8JPIfbXD.jpg", 4.2999999999999998, "Quentin Tarantino", 680, 154 }
                });

            migrationBuilder.UpdateData(
                table: "Korisnici",
                keyColumn: "Id",
                keyValue: 1,
                columns: new[] { "LozinkaHash", "LozinkaSalt" },
                values: new object[] { "D2uLCiGXHRiNM+mNAr0cOchH+gQ=", "fStjlRc+0bKc+yId5mDA6Q==" });

            migrationBuilder.UpdateData(
                table: "Korisnici",
                keyColumn: "Id",
                keyValue: 2,
                columns: new[] { "IsPremium", "LozinkaHash", "LozinkaSalt" },
                values: new object[] { false, "D2uLCiGXHRiNM+mNAr0cOchH+gQ=", "fStjlRc+0bKc+yId5mDA6Q==" });

            migrationBuilder.UpdateData(
                table: "Novosti",
                keyColumn: "Id",
                keyValue: 1,
                columns: new[] { "BrojPregleda", "Naslov", "Sadrzaj" },
                values: new object[] { 1250, "Oscari 2025: Kompletna lista nominacija", "Akademija filmskih umjetnosti i nauka objavila je nominacije za 97. dodjelu Oscara. Anora predvodi sa 6 nominacija, a The Brutalist i Emilia Perez prate sa po 10 nominacija. Ceremonija dodjele održat će se 2. marta 2025. u Dolby Theatreu u Los Angelesu." });

            migrationBuilder.UpdateData(
                table: "Novosti",
                keyColumn: "Id",
                keyValue: 2,
                columns: new[] { "BrojPregleda", "Naslov", "Sadrzaj" },
                values: new object[] { 890, "Christopher Nolan najavio novi film za 2026.", "Nakon uspjeha Oppenheimera, Christopher Nolan vraća se sa novim projektom. Film će biti snimljen u IMAX formatu i prema najavama radi se o originalnoj priči. Universal Pictures potvrdio je datum premijere za juli 2026. godine." });

            migrationBuilder.InsertData(
                table: "Novosti",
                columns: new[] { "Id", "AutorId", "BrojPregleda", "DatumIzmjene", "DatumKreiranja", "Naslov", "Sadrzaj", "Slika" },
                values: new object[,]
                {
                    { 3, 1, 567, null, new DateTime(2025, 1, 8, 0, 0, 0, 0, DateTimeKind.Unspecified), "Martin Scorsese priprema dokumentarac o klasičnom Hollywoodu", "Legendarni reditelj Martin Scorsese najavio je novi dokumentarni film koji će istražiti zlatno doba Hollywooda 1940-ih i 1950-ih godina. Projekt će uključivati rijetke arhivske snimke i intervjue sa preživjelim legendama iz tog perioda.", null },
                    { 4, 1, 432, null, new DateTime(2025, 1, 5, 0, 0, 0, 0, DateTimeKind.Unspecified), "Streaming platforme dominiraju box office", "Analiza filmske industrije pokazuje da streaming platforme nastavljaju transformirati način na koji gledamo filmove. Netflix, Amazon Prime i Apple TV+ ulažu rekordne budžete u originalne produkcije, dok tradicionalni studiji traže nove strategije za privlačenje publike u kina.", null }
                });

            migrationBuilder.UpdateData(
                table: "Recenzije",
                keyColumn: "Id",
                keyValue: 1,
                columns: new[] { "Naslov", "Sadrzaj" },
                values: new object[] { "Remek djelo modernog filma", "Inception je vizualno zapanjujući film koji uspijeva kombinirati akciju sa dubokim filozofskim pitanjima o prirodi stvarnosti i snova. Nolan je stvorio jedinstveno filmsko iskustvo." });

            migrationBuilder.UpdateData(
                table: "Recenzije",
                keyColumn: "Id",
                keyValue: 2,
                columns: new[] { "Naslov", "Ocjena", "Sadrzaj" },
                values: new object[] { "Najbolji film svih vremena", 5.0, "The Shawshank Redemption je dirljiva priča o nadi i prijateljstvu. Tim Robbins i Morgan Freeman su nevjerovatni u svojim ulogama. Film koji vas nikad neće napustiti." });

            migrationBuilder.InsertData(
                table: "Recenzije",
                columns: new[] { "Id", "DatumIzmjene", "DatumKreiranja", "DatumSkrivanja", "FilmId", "ImaSpoiler", "IsHidden", "KorisnikId", "Naslov", "Ocjena", "Sadrzaj" },
                values: new object[,]
                {
                    { 3, null, new DateTime(2025, 1, 7, 0, 0, 0, 0, DateTimeKind.Unspecified), null, 2, false, false, 1, "Klasik koji se mora pogledati", 4.5, "Izvanredna adaptacija Stephen Kingove novele. Film koji demonstrira snagu ljudskog duha i važnost nade čak i u najtežim okolnostima." },
                    { 4, null, new DateTime(2025, 1, 8, 0, 0, 0, 0, DateTimeKind.Unspecified), null, 3, false, false, 2, "Epska saga o porodici i moći", 4.5, "Marlon Brando je nezaboravan kao Don Vito Corleone. Coppola je stvorio film koji definira žanr gangsterskih filmova. Svaka scena je savršeno režirana." },
                    { 5, null, new DateTime(2025, 1, 9, 0, 0, 0, 0, DateTimeKind.Unspecified), null, 3, false, false, 1, "Filmska historija", 4.0, "The Godfather je više od filma - to je kulturni fenomen koji je utjecao na generacije filmskih stvaralaca. Obavezno gledanje za svakog ljubitelja filma." },
                    { 10, null, new DateTime(2025, 1, 14, 0, 0, 0, 0, DateTimeKind.Unspecified), null, 1, true, false, 1, "Vizualno impresivan ali konfuzan", 3.5, "Film je tehnički briljantan ali ponekad previše kompliciran. Završetak ostavlja previše pitanja bez odgovora. Ipak, vrijedi pogledati bar jednom." },
                    { 11, null, new DateTime(2025, 1, 15, 0, 0, 0, 0, DateTimeKind.Unspecified), null, 1, false, false, 2, "Nolan nikad ne razočara", 4.0, "Još jedan dokaz Nolanovog genija. Kompleksna priča koja nagrađuje pažljive gledatelje. Hans Zimmerov soundtrack je fantastičan." }
                });

            migrationBuilder.UpdateData(
                table: "Zalbe",
                keyColumn: "Id",
                keyValue: 1,
                columns: new[] { "DatumKreiranja", "KorisnikId", "Opis", "Razlog", "RecenzijaId" },
                values: new object[] { new DateTime(2025, 1, 15, 0, 0, 0, 0, DateTimeKind.Unspecified), 2, "Recenzija otkriva ključne dijelove radnje filma bez označavanja kao spoiler.", "Spoiler bez upozorenja", 10 });

            migrationBuilder.UpdateData(
                table: "Zalbe",
                keyColumn: "Id",
                keyValue: 2,
                columns: new[] { "DatumKreiranja", "DatumObrade", "ObradioPrijavuId", "Opis", "Razlog", "RecenzijaId", "Status" },
                values: new object[] { new DateTime(2025, 1, 14, 0, 0, 0, 0, DateTimeKind.Unspecified), new DateTime(2025, 1, 15, 0, 0, 0, 0, DateTimeKind.Unspecified), 1, "Korisnik navodi pogrešne činjenice o filmu i reditelju.", "Netačne informacije", 4, "rejected" });

            migrationBuilder.UpdateData(
                table: "Zalbe",
                keyColumn: "Id",
                keyValue: 3,
                columns: new[] { "DatumKreiranja", "DatumObrade", "ObradioPrijavuId", "Opis", "Razlog", "RecenzijaId", "Status" },
                values: new object[] { new DateTime(2025, 1, 13, 0, 0, 0, 0, DateTimeKind.Unspecified), null, null, "Recenzija sadrži neprimjerene komentare koji nisu vezani za film.", "Neprimjeren sadržaj", 5, "pending" });

            migrationBuilder.InsertData(
                table: "Recenzije",
                columns: new[] { "Id", "DatumIzmjene", "DatumKreiranja", "DatumSkrivanja", "FilmId", "ImaSpoiler", "IsHidden", "KorisnikId", "Naslov", "Ocjena", "Sadrzaj" },
                values: new object[,]
                {
                    { 6, null, new DateTime(2025, 1, 10, 0, 0, 0, 0, DateTimeKind.Unspecified), null, 4, false, false, 2, "Heath Ledger je genijalan", 4.5, "Ovaj film je dokaz da superherojski filmovi mogu biti ozbiljno umjetničko djelo. Heath Ledger kao Joker je jedna od najimpresivnijih transformacija u historiji filma." },
                    { 7, null, new DateTime(2025, 1, 11, 0, 0, 0, 0, DateTimeKind.Unspecified), null, 4, false, false, 1, "Najbolji Batman film", 4.0, "Nolan je transformirao Batman franšizu u nešto potpuno novo. Mračan, realističan i napeto režiran od početka do kraja." },
                    { 8, null, new DateTime(2025, 1, 12, 0, 0, 0, 0, DateTimeKind.Unspecified), null, 5, false, false, 2, "Tarantinov potpis", 4.5, "Pulp Fiction je revolucionirao nezavisni film 90-ih. Dijalozi su briljantni, struktura inovativna, a soundtrack savršen. Film koji zahtijeva višestruka gledanja." },
                    { 9, null, new DateTime(2025, 1, 13, 0, 0, 0, 0, DateTimeKind.Unspecified), null, 5, false, false, 1, "Kultni klasik", 4.0, "Nelinearna naracija i nezaboravni likovi čine ovaj film posebnim. Samuel L. Jackson i John Travolta su savršeni zajedno." }
                });
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DeleteData(
                table: "Novosti",
                keyColumn: "Id",
                keyValue: 3);

            migrationBuilder.DeleteData(
                table: "Novosti",
                keyColumn: "Id",
                keyValue: 4);

            migrationBuilder.DeleteData(
                table: "Recenzije",
                keyColumn: "Id",
                keyValue: 3);

            migrationBuilder.DeleteData(
                table: "Recenzije",
                keyColumn: "Id",
                keyValue: 4);

            migrationBuilder.DeleteData(
                table: "Recenzije",
                keyColumn: "Id",
                keyValue: 5);

            migrationBuilder.DeleteData(
                table: "Recenzije",
                keyColumn: "Id",
                keyValue: 6);

            migrationBuilder.DeleteData(
                table: "Recenzije",
                keyColumn: "Id",
                keyValue: 7);

            migrationBuilder.DeleteData(
                table: "Recenzije",
                keyColumn: "Id",
                keyValue: 8);

            migrationBuilder.DeleteData(
                table: "Recenzije",
                keyColumn: "Id",
                keyValue: 9);

            migrationBuilder.DeleteData(
                table: "Recenzije",
                keyColumn: "Id",
                keyValue: 10);

            migrationBuilder.DeleteData(
                table: "Recenzije",
                keyColumn: "Id",
                keyValue: 11);

            migrationBuilder.DeleteData(
                table: "Filmovi",
                keyColumn: "Id",
                keyValue: 4);

            migrationBuilder.DeleteData(
                table: "Filmovi",
                keyColumn: "Id",
                keyValue: 5);

            migrationBuilder.UpdateData(
                table: "Filmovi",
                keyColumn: "Id",
                keyValue: 1,
                columns: new[] { "BrojOcjena", "Opis", "PosterPath", "ProsjecnaOcjena", "TmdbId" },
                values: new object[] { 100, "A thief who steals corporate secrets through dream-sharing technology.", null, 4.5, null });

            migrationBuilder.UpdateData(
                table: "Filmovi",
                keyColumn: "Id",
                keyValue: 2,
                columns: new[] { "BrojOcjena", "BrojPregleda", "GodinaIzdanja", "Naslov", "Opis", "PosterPath", "ProsjecnaOcjena", "Reziser", "TmdbId", "Trajanje" },
                values: new object[] { 80, 400, 2013, "The Wolf of Wall Street", "Based on the true story of Jordan Belfort.", null, 4.2000000000000002, "Martin Scorsese", null, 180 });

            migrationBuilder.UpdateData(
                table: "Filmovi",
                keyColumn: "Id",
                keyValue: 3,
                columns: new[] { "BrojOcjena", "BrojPregleda", "GodinaIzdanja", "Naslov", "Opis", "PosterPath", "ProsjecnaOcjena", "Reziser", "TmdbId", "Trajanje" },
                values: new object[] { 60, 300, 2019, "Once Upon a Time in Hollywood", "A faded television actor and his stunt double strive to achieve fame.", null, 4.0, "Quentin Tarantino", null, 161 });

            migrationBuilder.UpdateData(
                table: "Korisnici",
                keyColumn: "Id",
                keyValue: 1,
                columns: new[] { "LozinkaHash", "LozinkaSalt" },
                values: new object[] { "4Pmoju0s0Pr87xmRVKk8t/Ud5tE=", "S2qN3+HO4dThdWRKBJQphw==" });

            migrationBuilder.UpdateData(
                table: "Korisnici",
                keyColumn: "Id",
                keyValue: 2,
                columns: new[] { "IsPremium", "LozinkaHash", "LozinkaSalt" },
                values: new object[] { true, "4Pmoju0s0Pr87xmRVKk8t/Ud5tE=", "S2qN3+HO4dThdWRKBJQphw==" });

            migrationBuilder.UpdateData(
                table: "Novosti",
                keyColumn: "Id",
                keyValue: 1,
                columns: new[] { "BrojPregleda", "Naslov", "Sadrzaj" },
                values: new object[] { 150, "Oscars 2025: Najbolji filmovi godine", "Pregled nominacija za Oscara 2025. Saznajte koji filmovi su u utrci za najvaznije filmske nagrade." });

            migrationBuilder.UpdateData(
                table: "Novosti",
                keyColumn: "Id",
                keyValue: 2,
                columns: new[] { "BrojPregleda", "Naslov", "Sadrzaj" },
                values: new object[] { 230, "Novi Nolan film najavljljen za 2026", "Christopher Nolan najavio je svoj novi projekt koji ce biti objavljen 2026. godine." });

            migrationBuilder.UpdateData(
                table: "Recenzije",
                keyColumn: "Id",
                keyValue: 1,
                columns: new[] { "Naslov", "Sadrzaj" },
                values: new object[] { "Remek djelo!", "Inception je jedan od najboljih filmova koje sam ikada gledao. Nolan je genij." });

            migrationBuilder.UpdateData(
                table: "Recenzije",
                keyColumn: "Id",
                keyValue: 2,
                columns: new[] { "Naslov", "Ocjena", "Sadrzaj" },
                values: new object[] { "Odlicna gluma", 4.0, "DiCaprio je bio nevjerovatan u ulozi Jordan Belforta." });

            migrationBuilder.UpdateData(
                table: "Zalbe",
                keyColumn: "Id",
                keyValue: 1,
                columns: new[] { "DatumKreiranja", "KorisnikId", "Opis", "Razlog", "RecenzijaId" },
                values: new object[] { new DateTime(2025, 1, 7, 0, 0, 0, 0, DateTimeKind.Unspecified), 1, "Recenzija sadrži uvredljive komentare.", "Neprimjeren sadržaj", 1 });

            migrationBuilder.UpdateData(
                table: "Zalbe",
                keyColumn: "Id",
                keyValue: 2,
                columns: new[] { "DatumKreiranja", "DatumObrade", "ObradioPrijavuId", "Opis", "Razlog", "RecenzijaId", "Status" },
                values: new object[] { new DateTime(2025, 1, 8, 0, 0, 0, 0, DateTimeKind.Unspecified), null, null, "Korisnik je otkrio ključne dijelove radnje bez spoiler upozorenja.", "Spoiler bez upozorenja", 2, "pending" });

            migrationBuilder.UpdateData(
                table: "Zalbe",
                keyColumn: "Id",
                keyValue: 3,
                columns: new[] { "DatumKreiranja", "DatumObrade", "ObradioPrijavuId", "Opis", "Razlog", "RecenzijaId", "Status" },
                values: new object[] { new DateTime(2025, 1, 5, 0, 0, 0, 0, DateTimeKind.Unspecified), new DateTime(2025, 1, 6, 0, 0, 0, 0, DateTimeKind.Unspecified), 1, "Recenzija sadrži netočne informacije o filmu.", "Lažne informacije", 1, "approved" });

            migrationBuilder.InsertData(
                table: "Zalbe",
                columns: new[] { "Id", "DatumKreiranja", "DatumObrade", "KorisnikId", "ObradioPrijavuId", "Opis", "Razlog", "RecenzijaId", "Status" },
                values: new object[] { 4, new DateTime(2025, 1, 4, 0, 0, 0, 0, DateTimeKind.Unspecified), new DateTime(2025, 1, 5, 0, 0, 0, 0, DateTimeKind.Unspecified), 2, 1, "Recenzija je očigledno promotivni sadržaj.", "Spam", 2, "rejected" });

            migrationBuilder.InsertData(
                table: "Zanrovi",
                columns: new[] { "Id", "Naziv", "Opis" },
                values: new object[,]
                {
                    { 1, "Akcija", "Akcioni filmovi" },
                    { 2, "Komedija", "Komicni filmovi" },
                    { 3, "Drama", "Dramski filmovi" },
                    { 4, "Horor", "Horor filmovi" },
                    { 5, "Sci-Fi", "Naucna fantastika" },
                    { 6, "Triler", "Triler filmovi" },
                    { 7, "Romantika", "Romantični filmovi" },
                    { 8, "Animirani", "Animirani filmovi" }
                });

            migrationBuilder.InsertData(
                table: "FilmoviZanrovi",
                columns: new[] { "Id", "FilmId", "ZanrId" },
                values: new object[,]
                {
                    { 1, 1, 1 },
                    { 2, 1, 5 },
                    { 3, 1, 6 },
                    { 4, 2, 2 },
                    { 5, 2, 3 },
                    { 6, 3, 2 },
                    { 7, 3, 3 }
                });
        }
    }
}
