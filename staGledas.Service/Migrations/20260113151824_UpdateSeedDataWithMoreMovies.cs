using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

#pragma warning disable CA1814 // Prefer jagged arrays over multidimensional

namespace staGledas.Service.Migrations
{
    /// <inheritdoc />
    public partial class UpdateSeedDataWithMoreMovies : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
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
                keyValue: 11);

            migrationBuilder.DeleteData(
                table: "Zalbe",
                keyColumn: "Id",
                keyValue: 1);

            migrationBuilder.DeleteData(
                table: "Zalbe",
                keyColumn: "Id",
                keyValue: 2);

            migrationBuilder.DeleteData(
                table: "Zalbe",
                keyColumn: "Id",
                keyValue: 3);

            migrationBuilder.DeleteData(
                table: "Recenzije",
                keyColumn: "Id",
                keyValue: 10);

            migrationBuilder.UpdateData(
                table: "Filmovi",
                keyColumn: "Id",
                keyValue: 5,
                column: "BrojOcjena",
                value: 1);

            migrationBuilder.InsertData(
                table: "Filmovi",
                columns: new[] { "Id", "BrojLajkova", "BrojOcjena", "BrojPregleda", "DatumIzmjene", "DatumKreiranja", "GodinaIzdanja", "Naslov", "Opis", "PosterPath", "ProsjecnaOcjena", "Reziser", "TmdbId", "Trajanje" },
                values: new object[,]
                {
                    { 6, null, 0, 380, new DateTime(2025, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified), new DateTime(2025, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified), 2014, "Interstellar", "The adventures of a group of explorers who make use of a newly discovered wormhole to surpass the limitations on human space travel and conquer the vast distances involved in an interstellar voyage.", "/gEU2QniE6E77NI6lCU6MxlNBvIx.jpg", 4.4000000000000004, "Christopher Nolan", 157336, 169 },
                    { 7, null, 0, 350, new DateTime(2025, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified), new DateTime(2025, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified), 1999, "The Matrix", "Set in the 22nd century, The Matrix tells the story of a computer hacker who joins a group of underground insurgents fighting the vast and powerful computers who now rule the earth.", "/f89U3ADr1oiB1s9GkdPOEpXUk5H.jpg", 4.2999999999999998, "Lana Wachowski", 603, 136 },
                    { 8, null, 0, 360, new DateTime(2025, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified), new DateTime(2025, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified), 1999, "Fight Club", "A ticking-Loss time bomb insomniac and a slippery soap salesman channel primal male aggression into a shocking new form of therapy.", "/pB8BM7pdSp6B6Ih7QZ4DrQ3PmJK.jpg", 4.4000000000000004, "David Fincher", 550, 139 },
                    { 9, null, 0, 400, new DateTime(2025, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified), new DateTime(2025, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified), 1994, "Forrest Gump", "A man with a low IQ has accomplished great things in his life and been present during significant historic events—in each case, far exceeding what anyone imagined he could do.", "/arw2vcBveWOVZr6pxd9XTd1TdQa.jpg", 4.5, "Robert Zemeckis", 13, 142 },
                    { 10, null, 0, 320, new DateTime(2025, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified), new DateTime(2025, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified), 1999, "The Green Mile", "A supernatural tale set on death row in a Southern prison, where gentle giant John Coffey possesses the mysterious power to heal people's ailments.", "/velWPhVMQeQKcxggNEU8YmIo52R.jpg", 4.5, "Frank Darabont", 497, 189 }
                });

            migrationBuilder.InsertData(
                table: "FilmoviLajkovi",
                columns: new[] { "Id", "DatumLajka", "FilmId", "KorisnikId" },
                values: new object[,]
                {
                    { 1, new DateTime(2025, 1, 6, 0, 0, 0, 0, DateTimeKind.Unspecified), 1, 1 },
                    { 2, new DateTime(2025, 1, 8, 0, 0, 0, 0, DateTimeKind.Unspecified), 4, 1 },
                    { 3, new DateTime(2025, 1, 10, 0, 0, 0, 0, DateTimeKind.Unspecified), 3, 1 },
                    { 6, new DateTime(2025, 1, 6, 0, 0, 0, 0, DateTimeKind.Unspecified), 2, 2 },
                    { 7, new DateTime(2025, 1, 8, 0, 0, 0, 0, DateTimeKind.Unspecified), 5, 2 }
                });

            migrationBuilder.UpdateData(
                table: "Korisnici",
                keyColumn: "Id",
                keyValue: 1,
                columns: new[] { "LozinkaHash", "LozinkaSalt" },
                values: new object[] { "x6iIfXwYjHKryuVuAOTpS6tdwWo=", "5kZC5X98zlKn++6LsGcCpg==" });

            migrationBuilder.UpdateData(
                table: "Korisnici",
                keyColumn: "Id",
                keyValue: 2,
                columns: new[] { "LozinkaHash", "LozinkaSalt" },
                values: new object[] { "x6iIfXwYjHKryuVuAOTpS6tdwWo=", "5kZC5X98zlKn++6LsGcCpg==" });

            migrationBuilder.UpdateData(
                table: "Recenzije",
                keyColumn: "Id",
                keyValue: 1,
                columns: new[] { "KorisnikId", "Ocjena" },
                values: new object[] { 1, 4.5 });

            migrationBuilder.UpdateData(
                table: "Recenzije",
                keyColumn: "Id",
                keyValue: 2,
                columns: new[] { "FilmId", "KorisnikId", "Naslov", "Ocjena", "Sadrzaj" },
                values: new object[] { 3, 1, "Filmska historija", 4.0, "The Godfather je više od filma - to je kulturni fenomen koji je utjecao na generacije filmskih stvaralaca. Obavezno gledanje za svakog ljubitelja filma." });

            migrationBuilder.UpdateData(
                table: "Recenzije",
                keyColumn: "Id",
                keyValue: 3,
                columns: new[] { "FilmId", "Naslov", "Sadrzaj" },
                values: new object[] { 4, "Najbolji Batman film", "Nolan je transformirao Batman franšizu u nešto potpuno novo. Mračan, realističan i napeto režiran od početka do kraja." });

            migrationBuilder.UpdateData(
                table: "Recenzije",
                keyColumn: "Id",
                keyValue: 4,
                columns: new[] { "FilmId", "Naslov", "Ocjena", "Sadrzaj" },
                values: new object[] { 2, "Najbolji film svih vremena", 5.0, "The Shawshank Redemption je dirljiva priča o nadi i prijateljstvu. Tim Robbins i Morgan Freeman su nevjerovatni u svojim ulogama. Film koji vas nikad neće napustiti." });

            migrationBuilder.UpdateData(
                table: "Recenzije",
                keyColumn: "Id",
                keyValue: 5,
                columns: new[] { "FilmId", "KorisnikId", "Naslov", "Ocjena", "Sadrzaj" },
                values: new object[] { 5, 2, "Tarantinov potpis", 4.5, "Pulp Fiction je revolucionirao nezavisni film 90-ih. Dijalozi su briljantni, struktura inovativna, a soundtrack savršen. Film koji zahtijeva višestruka gledanja." });

            migrationBuilder.InsertData(
                table: "Watchlist",
                columns: new[] { "Id", "DatumDodavanja", "DatumGledanja", "FilmId", "KorisnikId", "Pogledano" },
                values: new object[,]
                {
                    { 1, new DateTime(2025, 1, 5, 0, 0, 0, 0, DateTimeKind.Unspecified), new DateTime(2025, 1, 6, 0, 0, 0, 0, DateTimeKind.Unspecified), 1, 1, true },
                    { 2, new DateTime(2025, 1, 7, 0, 0, 0, 0, DateTimeKind.Unspecified), new DateTime(2025, 1, 8, 0, 0, 0, 0, DateTimeKind.Unspecified), 4, 1, true },
                    { 3, new DateTime(2025, 1, 9, 0, 0, 0, 0, DateTimeKind.Unspecified), new DateTime(2025, 1, 10, 0, 0, 0, 0, DateTimeKind.Unspecified), 3, 1, true },
                    { 6, new DateTime(2025, 1, 5, 0, 0, 0, 0, DateTimeKind.Unspecified), new DateTime(2025, 1, 6, 0, 0, 0, 0, DateTimeKind.Unspecified), 2, 2, true },
                    { 7, new DateTime(2025, 1, 7, 0, 0, 0, 0, DateTimeKind.Unspecified), new DateTime(2025, 1, 8, 0, 0, 0, 0, DateTimeKind.Unspecified), 5, 2, true }
                });

            migrationBuilder.InsertData(
                table: "FilmoviLajkovi",
                columns: new[] { "Id", "DatumLajka", "FilmId", "KorisnikId" },
                values: new object[,]
                {
                    { 4, new DateTime(2025, 1, 12, 0, 0, 0, 0, DateTimeKind.Unspecified), 6, 1 },
                    { 5, new DateTime(2025, 1, 14, 0, 0, 0, 0, DateTimeKind.Unspecified), 7, 1 },
                    { 8, new DateTime(2025, 1, 10, 0, 0, 0, 0, DateTimeKind.Unspecified), 8, 2 },
                    { 9, new DateTime(2025, 1, 12, 0, 0, 0, 0, DateTimeKind.Unspecified), 9, 2 }
                });

            migrationBuilder.InsertData(
                table: "Watchlist",
                columns: new[] { "Id", "DatumDodavanja", "DatumGledanja", "FilmId", "KorisnikId", "Pogledano" },
                values: new object[,]
                {
                    { 4, new DateTime(2025, 1, 11, 0, 0, 0, 0, DateTimeKind.Unspecified), new DateTime(2025, 1, 12, 0, 0, 0, 0, DateTimeKind.Unspecified), 6, 1, true },
                    { 5, new DateTime(2025, 1, 13, 0, 0, 0, 0, DateTimeKind.Unspecified), new DateTime(2025, 1, 14, 0, 0, 0, 0, DateTimeKind.Unspecified), 7, 1, true },
                    { 8, new DateTime(2025, 1, 9, 0, 0, 0, 0, DateTimeKind.Unspecified), new DateTime(2025, 1, 10, 0, 0, 0, 0, DateTimeKind.Unspecified), 8, 2, true },
                    { 9, new DateTime(2025, 1, 11, 0, 0, 0, 0, DateTimeKind.Unspecified), new DateTime(2025, 1, 12, 0, 0, 0, 0, DateTimeKind.Unspecified), 9, 2, true }
                });
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DeleteData(
                table: "Filmovi",
                keyColumn: "Id",
                keyValue: 10);

            migrationBuilder.DeleteData(
                table: "FilmoviLajkovi",
                keyColumn: "Id",
                keyValue: 1);

            migrationBuilder.DeleteData(
                table: "FilmoviLajkovi",
                keyColumn: "Id",
                keyValue: 2);

            migrationBuilder.DeleteData(
                table: "FilmoviLajkovi",
                keyColumn: "Id",
                keyValue: 3);

            migrationBuilder.DeleteData(
                table: "FilmoviLajkovi",
                keyColumn: "Id",
                keyValue: 4);

            migrationBuilder.DeleteData(
                table: "FilmoviLajkovi",
                keyColumn: "Id",
                keyValue: 5);

            migrationBuilder.DeleteData(
                table: "FilmoviLajkovi",
                keyColumn: "Id",
                keyValue: 6);

            migrationBuilder.DeleteData(
                table: "FilmoviLajkovi",
                keyColumn: "Id",
                keyValue: 7);

            migrationBuilder.DeleteData(
                table: "FilmoviLajkovi",
                keyColumn: "Id",
                keyValue: 8);

            migrationBuilder.DeleteData(
                table: "FilmoviLajkovi",
                keyColumn: "Id",
                keyValue: 9);

            migrationBuilder.DeleteData(
                table: "Watchlist",
                keyColumn: "Id",
                keyValue: 1);

            migrationBuilder.DeleteData(
                table: "Watchlist",
                keyColumn: "Id",
                keyValue: 2);

            migrationBuilder.DeleteData(
                table: "Watchlist",
                keyColumn: "Id",
                keyValue: 3);

            migrationBuilder.DeleteData(
                table: "Watchlist",
                keyColumn: "Id",
                keyValue: 4);

            migrationBuilder.DeleteData(
                table: "Watchlist",
                keyColumn: "Id",
                keyValue: 5);

            migrationBuilder.DeleteData(
                table: "Watchlist",
                keyColumn: "Id",
                keyValue: 6);

            migrationBuilder.DeleteData(
                table: "Watchlist",
                keyColumn: "Id",
                keyValue: 7);

            migrationBuilder.DeleteData(
                table: "Watchlist",
                keyColumn: "Id",
                keyValue: 8);

            migrationBuilder.DeleteData(
                table: "Watchlist",
                keyColumn: "Id",
                keyValue: 9);

            migrationBuilder.DeleteData(
                table: "Filmovi",
                keyColumn: "Id",
                keyValue: 6);

            migrationBuilder.DeleteData(
                table: "Filmovi",
                keyColumn: "Id",
                keyValue: 7);

            migrationBuilder.DeleteData(
                table: "Filmovi",
                keyColumn: "Id",
                keyValue: 8);

            migrationBuilder.DeleteData(
                table: "Filmovi",
                keyColumn: "Id",
                keyValue: 9);

            migrationBuilder.UpdateData(
                table: "Filmovi",
                keyColumn: "Id",
                keyValue: 5,
                column: "BrojOcjena",
                value: 2);

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
                columns: new[] { "LozinkaHash", "LozinkaSalt" },
                values: new object[] { "D2uLCiGXHRiNM+mNAr0cOchH+gQ=", "fStjlRc+0bKc+yId5mDA6Q==" });

            migrationBuilder.UpdateData(
                table: "Recenzije",
                keyColumn: "Id",
                keyValue: 1,
                columns: new[] { "KorisnikId", "Ocjena" },
                values: new object[] { 2, 5.0 });

            migrationBuilder.UpdateData(
                table: "Recenzije",
                keyColumn: "Id",
                keyValue: 2,
                columns: new[] { "FilmId", "KorisnikId", "Naslov", "Ocjena", "Sadrzaj" },
                values: new object[] { 2, 2, "Najbolji film svih vremena", 5.0, "The Shawshank Redemption je dirljiva priča o nadi i prijateljstvu. Tim Robbins i Morgan Freeman su nevjerovatni u svojim ulogama. Film koji vas nikad neće napustiti." });

            migrationBuilder.UpdateData(
                table: "Recenzije",
                keyColumn: "Id",
                keyValue: 3,
                columns: new[] { "FilmId", "Naslov", "Sadrzaj" },
                values: new object[] { 2, "Klasik koji se mora pogledati", "Izvanredna adaptacija Stephen Kingove novele. Film koji demonstrira snagu ljudskog duha i važnost nade čak i u najtežim okolnostima." });

            migrationBuilder.UpdateData(
                table: "Recenzije",
                keyColumn: "Id",
                keyValue: 4,
                columns: new[] { "FilmId", "Naslov", "Ocjena", "Sadrzaj" },
                values: new object[] { 3, "Epska saga o porodici i moći", 4.5, "Marlon Brando je nezaboravan kao Don Vito Corleone. Coppola je stvorio film koji definira žanr gangsterskih filmova. Svaka scena je savršeno režirana." });

            migrationBuilder.UpdateData(
                table: "Recenzije",
                keyColumn: "Id",
                keyValue: 5,
                columns: new[] { "FilmId", "KorisnikId", "Naslov", "Ocjena", "Sadrzaj" },
                values: new object[] { 3, 1, "Filmska historija", 4.0, "The Godfather je više od filma - to je kulturni fenomen koji je utjecao na generacije filmskih stvaralaca. Obavezno gledanje za svakog ljubitelja filma." });

            migrationBuilder.InsertData(
                table: "Recenzije",
                columns: new[] { "Id", "DatumIzmjene", "DatumKreiranja", "DatumSkrivanja", "FilmId", "ImaSpoiler", "IsHidden", "KorisnikId", "Naslov", "Ocjena", "Sadrzaj" },
                values: new object[,]
                {
                    { 6, null, new DateTime(2025, 1, 10, 0, 0, 0, 0, DateTimeKind.Unspecified), null, 4, false, false, 2, "Heath Ledger je genijalan", 4.5, "Ovaj film je dokaz da superherojski filmovi mogu biti ozbiljno umjetničko djelo. Heath Ledger kao Joker je jedna od najimpresivnijih transformacija u historiji filma." },
                    { 7, null, new DateTime(2025, 1, 11, 0, 0, 0, 0, DateTimeKind.Unspecified), null, 4, false, false, 1, "Najbolji Batman film", 4.0, "Nolan je transformirao Batman franšizu u nešto potpuno novo. Mračan, realističan i napeto režiran od početka do kraja." },
                    { 8, null, new DateTime(2025, 1, 12, 0, 0, 0, 0, DateTimeKind.Unspecified), null, 5, false, false, 2, "Tarantinov potpis", 4.5, "Pulp Fiction je revolucionirao nezavisni film 90-ih. Dijalozi su briljantni, struktura inovativna, a soundtrack savršen. Film koji zahtijeva višestruka gledanja." },
                    { 9, null, new DateTime(2025, 1, 13, 0, 0, 0, 0, DateTimeKind.Unspecified), null, 5, false, false, 1, "Kultni klasik", 4.0, "Nelinearna naracija i nezaboravni likovi čine ovaj film posebnim. Samuel L. Jackson i John Travolta su savršeni zajedno." },
                    { 10, null, new DateTime(2025, 1, 14, 0, 0, 0, 0, DateTimeKind.Unspecified), null, 1, true, false, 1, "Vizualno impresivan ali konfuzan", 3.5, "Film je tehnički briljantan ali ponekad previše kompliciran. Završetak ostavlja previše pitanja bez odgovora. Ipak, vrijedi pogledati bar jednom." },
                    { 11, null, new DateTime(2025, 1, 15, 0, 0, 0, 0, DateTimeKind.Unspecified), null, 1, false, false, 2, "Nolan nikad ne razočara", 4.0, "Još jedan dokaz Nolanovog genija. Kompleksna priča koja nagrađuje pažljive gledatelje. Hans Zimmerov soundtrack je fantastičan." }
                });

            migrationBuilder.InsertData(
                table: "Zalbe",
                columns: new[] { "Id", "DatumKreiranja", "DatumObrade", "KorisnikId", "ObradioPrijavuId", "Opis", "Razlog", "RecenzijaId", "Status" },
                values: new object[,]
                {
                    { 2, new DateTime(2025, 1, 14, 0, 0, 0, 0, DateTimeKind.Unspecified), new DateTime(2025, 1, 15, 0, 0, 0, 0, DateTimeKind.Unspecified), 1, 1, "Korisnik navodi pogrešne činjenice o filmu i reditelju.", "Netačne informacije", 4, "rejected" },
                    { 3, new DateTime(2025, 1, 13, 0, 0, 0, 0, DateTimeKind.Unspecified), null, 2, null, "Recenzija sadrži neprimjerene komentare koji nisu vezani za film.", "Neprimjeren sadržaj", 5, "pending" },
                    { 1, new DateTime(2025, 1, 15, 0, 0, 0, 0, DateTimeKind.Unspecified), null, 2, null, "Recenzija otkriva ključne dijelove radnje filma bez označavanja kao spoiler.", "Spoiler bez upozorenja", 10, "pending" }
                });
        }
    }
}
