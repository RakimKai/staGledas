using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

#pragma warning disable CA1814 // Prefer jagged arrays over multidimensional

namespace staGledas.Service.Migrations
{
    /// <inheritdoc />
    public partial class SeedZalbe : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.UpdateData(
                table: "Korisnici",
                keyColumn: "Id",
                keyValue: 1,
                columns: new[] { "LozinkaHash", "LozinkaSalt" },
                values: new object[] { "oYswjVKvdXGkX5eKuhwAIo15t94=", "s+7g5bmKHp78/j6N1AQScQ==" });

            migrationBuilder.UpdateData(
                table: "Korisnici",
                keyColumn: "Id",
                keyValue: 2,
                columns: new[] { "LozinkaHash", "LozinkaSalt" },
                values: new object[] { "oYswjVKvdXGkX5eKuhwAIo15t94=", "s+7g5bmKHp78/j6N1AQScQ==" });

            // Re-insert Filmovi (deleted from DB during testing)
            migrationBuilder.Sql(@"
                SET IDENTITY_INSERT [Filmovi] ON;
                IF NOT EXISTS (SELECT 1 FROM [Filmovi] WHERE Id = 1)
                    INSERT INTO [Filmovi] ([Id], [Naslov], [Opis], [GodinaIzdanja], [Trajanje], [Reziser], [ProsjecnaOcjena], [BrojOcjena], [BrojPregleda], [DatumKreiranja], [DatumIzmjene])
                    VALUES (1, N'Inception', N'A thief who steals corporate secrets through dream-sharing technology.', 2010, 148, N'Christopher Nolan', 4.5, 100, 500, '2025-01-01', '2025-01-01');
                IF NOT EXISTS (SELECT 1 FROM [Filmovi] WHERE Id = 2)
                    INSERT INTO [Filmovi] ([Id], [Naslov], [Opis], [GodinaIzdanja], [Trajanje], [Reziser], [ProsjecnaOcjena], [BrojOcjena], [BrojPregleda], [DatumKreiranja], [DatumIzmjene])
                    VALUES (2, N'The Wolf of Wall Street', N'Based on the true story of Jordan Belfort.', 2013, 180, N'Martin Scorsese', 4.2, 80, 400, '2025-01-01', '2025-01-01');
                SET IDENTITY_INSERT [Filmovi] OFF;
            ");

            // Re-insert Recenzije (deleted from DB during testing)
            migrationBuilder.Sql(@"
                SET IDENTITY_INSERT [Recenzije] ON;
                IF NOT EXISTS (SELECT 1 FROM [Recenzije] WHERE Id = 1)
                    INSERT INTO [Recenzije] ([Id], [KorisnikId], [FilmId], [Ocjena], [Naslov], [Sadrzaj], [BrojLajkova], [DatumKreiranja])
                    VALUES (1, 2, 1, 5, N'Remek djelo!', N'Inception je jedan od najboljih filmova koje sam ikada gledao. Nolan je genij.', 25, '2025-01-05');
                IF NOT EXISTS (SELECT 1 FROM [Recenzije] WHERE Id = 2)
                    INSERT INTO [Recenzije] ([Id], [KorisnikId], [FilmId], [Ocjena], [Naslov], [Sadrzaj], [BrojLajkova], [DatumKreiranja])
                    VALUES (2, 2, 2, 4, N'Odlicna gluma', N'DiCaprio je bio nevjerovatan u ulozi Jordan Belforta.', 18, '2025-01-06');
                SET IDENTITY_INSERT [Recenzije] OFF;
            ");

            migrationBuilder.InsertData(
                table: "Zalbe",
                columns: new[] { "Id", "DatumKreiranja", "DatumObrade", "KorisnikId", "ObradioPrijavuId", "Opis", "Razlog", "RecenzijaId", "Status" },
                values: new object[,]
                {
                    { 1, new DateTime(2025, 1, 7, 0, 0, 0, 0, DateTimeKind.Unspecified), null, 1, null, "Recenzija sadrži uvredljive komentare.", "Neprimjeren sadržaj", 1, "pending" },
                    { 2, new DateTime(2025, 1, 8, 0, 0, 0, 0, DateTimeKind.Unspecified), null, 1, null, "Korisnik je otkrio ključne dijelove radnje bez spoiler upozorenja.", "Spoiler bez upozorenja", 2, "pending" },
                    { 3, new DateTime(2025, 1, 5, 0, 0, 0, 0, DateTimeKind.Unspecified), new DateTime(2025, 1, 6, 0, 0, 0, 0, DateTimeKind.Unspecified), 2, 1, "Recenzija sadrži netočne informacije o filmu.", "Lažne informacije", 1, "approved" },
                    { 4, new DateTime(2025, 1, 4, 0, 0, 0, 0, DateTimeKind.Unspecified), new DateTime(2025, 1, 5, 0, 0, 0, 0, DateTimeKind.Unspecified), 2, 1, "Recenzija je očigledno promotivni sadržaj.", "Spam", 2, "rejected" }
                });
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
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
                table: "Zalbe",
                keyColumn: "Id",
                keyValue: 4);

            migrationBuilder.UpdateData(
                table: "Korisnici",
                keyColumn: "Id",
                keyValue: 1,
                columns: new[] { "LozinkaHash", "LozinkaSalt" },
                values: new object[] { "AKBIcol+ojwbE+pFZjZ1WCVU5tw=", "MM0moa3+w9Gyqs2LvMX6Qw==" });

            migrationBuilder.UpdateData(
                table: "Korisnici",
                keyColumn: "Id",
                keyValue: 2,
                columns: new[] { "LozinkaHash", "LozinkaSalt" },
                values: new object[] { "AKBIcol+ojwbE+pFZjZ1WCVU5tw=", "MM0moa3+w9Gyqs2LvMX6Qw==" });
        }
    }
}
