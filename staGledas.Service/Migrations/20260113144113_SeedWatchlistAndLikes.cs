using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

#pragma warning disable CA1814 // Prefer jagged arrays over multidimensional

namespace staGledas.Service.Migrations
{
    /// <inheritdoc />
    public partial class SeedWatchlistAndLikes : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.InsertData(
                table: "FilmoviLajkovi",
                columns: new[] { "Id", "DatumLajka", "FilmId", "KorisnikId" },
                values: new object[,]
                {
                    { 1, new DateTime(2025, 1, 6, 0, 0, 0, 0, DateTimeKind.Unspecified), 1, 1 },
                    { 2, new DateTime(2025, 1, 8, 0, 0, 0, 0, DateTimeKind.Unspecified), 4, 1 },
                    { 3, new DateTime(2025, 1, 10, 0, 0, 0, 0, DateTimeKind.Unspecified), 3, 1 },
                    { 4, new DateTime(2025, 1, 6, 0, 0, 0, 0, DateTimeKind.Unspecified), 2, 2 },
                    { 5, new DateTime(2025, 1, 8, 0, 0, 0, 0, DateTimeKind.Unspecified), 5, 2 }
                });

            migrationBuilder.UpdateData(
                table: "Korisnici",
                keyColumn: "Id",
                keyValue: 1,
                columns: new[] { "LozinkaHash", "LozinkaSalt" },
                values: new object[] { "KEFpDBGX5olqB/Il/E4L+NZTJho=", "roRoTWsfSUN6KVqJr9QjiA==" });

            migrationBuilder.UpdateData(
                table: "Korisnici",
                keyColumn: "Id",
                keyValue: 2,
                columns: new[] { "LozinkaHash", "LozinkaSalt" },
                values: new object[] { "KEFpDBGX5olqB/Il/E4L+NZTJho=", "roRoTWsfSUN6KVqJr9QjiA==" });

            migrationBuilder.InsertData(
                table: "Watchlist",
                columns: new[] { "Id", "DatumDodavanja", "DatumGledanja", "FilmId", "KorisnikId", "Pogledano" },
                values: new object[,]
                {
                    { 1, new DateTime(2025, 1, 5, 0, 0, 0, 0, DateTimeKind.Unspecified), new DateTime(2025, 1, 6, 0, 0, 0, 0, DateTimeKind.Unspecified), 1, 1, true },
                    { 2, new DateTime(2025, 1, 7, 0, 0, 0, 0, DateTimeKind.Unspecified), new DateTime(2025, 1, 8, 0, 0, 0, 0, DateTimeKind.Unspecified), 4, 1, true },
                    { 3, new DateTime(2025, 1, 9, 0, 0, 0, 0, DateTimeKind.Unspecified), new DateTime(2025, 1, 10, 0, 0, 0, 0, DateTimeKind.Unspecified), 3, 1, true },
                    { 4, new DateTime(2025, 1, 5, 0, 0, 0, 0, DateTimeKind.Unspecified), new DateTime(2025, 1, 6, 0, 0, 0, 0, DateTimeKind.Unspecified), 2, 2, true },
                    { 5, new DateTime(2025, 1, 7, 0, 0, 0, 0, DateTimeKind.Unspecified), new DateTime(2025, 1, 8, 0, 0, 0, 0, DateTimeKind.Unspecified), 5, 2, true }
                });
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
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
        }
    }
}
