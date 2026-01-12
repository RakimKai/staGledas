using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

#pragma warning disable CA1814 // Prefer jagged arrays over multidimensional

namespace staGledas.Service.Migrations
{
    /// <inheritdoc />
    public partial class RemoveGlumciAndFilmoviGlumci : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "FilmoviGlumci");

            migrationBuilder.DropTable(
                name: "Glumci");

            migrationBuilder.AlterColumn<string>(
                name: "Prezime",
                table: "Korisnici",
                type: "nvarchar(450)",
                nullable: true,
                oldClrType: typeof(string),
                oldType: "nvarchar(max)",
                oldNullable: true);

            migrationBuilder.AlterColumn<string>(
                name: "Ime",
                table: "Korisnici",
                type: "nvarchar(450)",
                nullable: true,
                oldClrType: typeof(string),
                oldType: "nvarchar(max)",
                oldNullable: true);

            migrationBuilder.AlterColumn<string>(
                name: "Naslov",
                table: "Filmovi",
                type: "nvarchar(450)",
                nullable: true,
                oldClrType: typeof(string),
                oldType: "nvarchar(max)",
                oldNullable: true);

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
                columns: new[] { "LozinkaHash", "LozinkaSalt" },
                values: new object[] { "4Pmoju0s0Pr87xmRVKk8t/Ud5tE=", "S2qN3+HO4dThdWRKBJQphw==" });

            migrationBuilder.CreateIndex(
                name: "IX_Korisnici_Ime",
                table: "Korisnici",
                column: "Ime");

            migrationBuilder.CreateIndex(
                name: "IX_Korisnici_Prezime",
                table: "Korisnici",
                column: "Prezime");

            migrationBuilder.CreateIndex(
                name: "IX_Filmovi_Naslov",
                table: "Filmovi",
                column: "Naslov");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropIndex(
                name: "IX_Korisnici_Ime",
                table: "Korisnici");

            migrationBuilder.DropIndex(
                name: "IX_Korisnici_Prezime",
                table: "Korisnici");

            migrationBuilder.DropIndex(
                name: "IX_Filmovi_Naslov",
                table: "Filmovi");

            migrationBuilder.AlterColumn<string>(
                name: "Prezime",
                table: "Korisnici",
                type: "nvarchar(max)",
                nullable: true,
                oldClrType: typeof(string),
                oldType: "nvarchar(450)",
                oldNullable: true);

            migrationBuilder.AlterColumn<string>(
                name: "Ime",
                table: "Korisnici",
                type: "nvarchar(max)",
                nullable: true,
                oldClrType: typeof(string),
                oldType: "nvarchar(450)",
                oldNullable: true);

            migrationBuilder.AlterColumn<string>(
                name: "Naslov",
                table: "Filmovi",
                type: "nvarchar(max)",
                nullable: true,
                oldClrType: typeof(string),
                oldType: "nvarchar(450)",
                oldNullable: true);

            migrationBuilder.CreateTable(
                name: "Glumci",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Biografija = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    DatumRodjenja = table.Column<DateTime>(type: "datetime2", nullable: true),
                    Ime = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    Prezime = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    SlikaPath = table.Column<string>(type: "nvarchar(max)", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Glumci", x => x.Id);
                });

            migrationBuilder.CreateTable(
                name: "FilmoviGlumci",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    FilmId = table.Column<int>(type: "int", nullable: false),
                    GlumacId = table.Column<int>(type: "int", nullable: false),
                    Uloga = table.Column<string>(type: "nvarchar(max)", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_FilmoviGlumci", x => x.Id);
                    table.ForeignKey(
                        name: "FK_FilmoviGlumci_Filmovi_FilmId",
                        column: x => x.FilmId,
                        principalTable: "Filmovi",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_FilmoviGlumci_Glumci_GlumacId",
                        column: x => x.GlumacId,
                        principalTable: "Glumci",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.InsertData(
                table: "Glumci",
                columns: new[] { "Id", "Biografija", "DatumRodjenja", "Ime", "Prezime", "SlikaPath" },
                values: new object[,]
                {
                    { 1, "Americki glumac", new DateTime(1974, 11, 11, 0, 0, 0, 0, DateTimeKind.Unspecified), "Leonardo", "DiCaprio", null },
                    { 2, "Americki glumac i producent", new DateTime(1963, 12, 18, 0, 0, 0, 0, DateTimeKind.Unspecified), "Brad", "Pitt", null },
                    { 3, "Australska glumica", new DateTime(1990, 7, 2, 0, 0, 0, 0, DateTimeKind.Unspecified), "Margot", "Robbie", null },
                    { 4, "Americka glumica", new DateTime(1984, 11, 22, 0, 0, 0, 0, DateTimeKind.Unspecified), "Scarlett", "Johansson", null },
                    { 5, "Americki glumac", new DateTime(1965, 4, 4, 0, 0, 0, 0, DateTimeKind.Unspecified), "Robert", "Downey Jr.", null }
                });

            migrationBuilder.UpdateData(
                table: "Korisnici",
                keyColumn: "Id",
                keyValue: 1,
                columns: new[] { "LozinkaHash", "LozinkaSalt" },
                values: new object[] { "WDtHjC2Z4g/mIcY4A802bDHxvxA=", "l1PDhwUklbNfwnZELghTHQ==" });

            migrationBuilder.UpdateData(
                table: "Korisnici",
                keyColumn: "Id",
                keyValue: 2,
                columns: new[] { "LozinkaHash", "LozinkaSalt" },
                values: new object[] { "WDtHjC2Z4g/mIcY4A802bDHxvxA=", "l1PDhwUklbNfwnZELghTHQ==" });

            migrationBuilder.InsertData(
                table: "FilmoviGlumci",
                columns: new[] { "Id", "FilmId", "GlumacId", "Uloga" },
                values: new object[,]
                {
                    { 1, 1, 1, "Dom Cobb" },
                    { 2, 2, 1, "Jordan Belfort" },
                    { 3, 2, 3, "Naomi Lapaglia" },
                    { 4, 3, 1, "Rick Dalton" },
                    { 5, 3, 2, "Cliff Booth" },
                    { 6, 3, 3, "Sharon Tate" }
                });

            migrationBuilder.CreateIndex(
                name: "IX_FilmoviGlumci_FilmId",
                table: "FilmoviGlumci",
                column: "FilmId");

            migrationBuilder.CreateIndex(
                name: "IX_FilmoviGlumci_GlumacId",
                table: "FilmoviGlumci",
                column: "GlumacId");
        }
    }
}
