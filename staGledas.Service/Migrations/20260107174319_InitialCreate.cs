using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

#pragma warning disable CA1814 // Prefer jagged arrays over multidimensional

namespace staGledas.Service.Migrations
{
    /// <inheritdoc />
    public partial class InitialCreate : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.CreateTable(
                name: "Filmovi",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Naslov = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    Opis = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    GodinaIzdanja = table.Column<int>(type: "int", nullable: true),
                    Trajanje = table.Column<int>(type: "int", nullable: true),
                    Reziser = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    Poster = table.Column<byte[]>(type: "varbinary(max)", nullable: true),
                    ProsjecnaOcjena = table.Column<double>(type: "float", nullable: true),
                    BrojOcjena = table.Column<int>(type: "int", nullable: true),
                    BrojPregleda = table.Column<int>(type: "int", nullable: true),
                    DatumKreiranja = table.Column<DateTime>(type: "datetime2", nullable: true),
                    DatumIzmjene = table.Column<DateTime>(type: "datetime2", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Filmovi", x => x.Id);
                });

            migrationBuilder.CreateTable(
                name: "Glumci",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Ime = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    Prezime = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    Biografija = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    DatumRodjenja = table.Column<DateTime>(type: "datetime2", nullable: true),
                    Slika = table.Column<byte[]>(type: "varbinary(max)", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Glumci", x => x.Id);
                });

            migrationBuilder.CreateTable(
                name: "Korisnici",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Ime = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    Prezime = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    Email = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    KorisnickoIme = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    Telefon = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    Slika = table.Column<byte[]>(type: "varbinary(max)", nullable: true),
                    LozinkaHash = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    LozinkaSalt = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    Status = table.Column<bool>(type: "bit", nullable: true),
                    IsPremium = table.Column<bool>(type: "bit", nullable: true),
                    DatumKreiranja = table.Column<DateTime>(type: "datetime2", nullable: true),
                    DatumIzmjene = table.Column<DateTime>(type: "datetime2", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Korisnici", x => x.Id);
                });

            migrationBuilder.CreateTable(
                name: "Uloge",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Naziv = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    Opis = table.Column<string>(type: "nvarchar(max)", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Uloge", x => x.Id);
                });

            migrationBuilder.CreateTable(
                name: "Zanrovi",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Naziv = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    Opis = table.Column<string>(type: "nvarchar(max)", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Zanrovi", x => x.Id);
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

            migrationBuilder.CreateTable(
                name: "KorisniciUloge",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    KorisnikId = table.Column<int>(type: "int", nullable: false),
                    UlogaId = table.Column<int>(type: "int", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_KorisniciUloge", x => x.Id);
                    table.ForeignKey(
                        name: "FK_KorisniciUloge_Korisnici_KorisnikId",
                        column: x => x.KorisnikId,
                        principalTable: "Korisnici",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_KorisniciUloge_Uloge_UlogaId",
                        column: x => x.UlogaId,
                        principalTable: "Uloge",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "FilmoviZanrovi",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    FilmId = table.Column<int>(type: "int", nullable: false),
                    ZanrId = table.Column<int>(type: "int", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_FilmoviZanrovi", x => x.Id);
                    table.ForeignKey(
                        name: "FK_FilmoviZanrovi_Filmovi_FilmId",
                        column: x => x.FilmId,
                        principalTable: "Filmovi",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_FilmoviZanrovi_Zanrovi_ZanrId",
                        column: x => x.ZanrId,
                        principalTable: "Zanrovi",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.InsertData(
                table: "Filmovi",
                columns: new[] { "Id", "BrojOcjena", "BrojPregleda", "DatumIzmjene", "DatumKreiranja", "GodinaIzdanja", "Naslov", "Opis", "Poster", "ProsjecnaOcjena", "Reziser", "Trajanje" },
                values: new object[,]
                {
                    { 1, 100, 500, new DateTime(2025, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified), new DateTime(2025, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified), 2010, "Inception", "A thief who steals corporate secrets through dream-sharing technology.", null, 4.5, "Christopher Nolan", 148 },
                    { 2, 80, 400, new DateTime(2025, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified), new DateTime(2025, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified), 2013, "The Wolf of Wall Street", "Based on the true story of Jordan Belfort.", null, 4.2000000000000002, "Martin Scorsese", 180 },
                    { 3, 60, 300, new DateTime(2025, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified), new DateTime(2025, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified), 2019, "Once Upon a Time in Hollywood", "A faded television actor and his stunt double strive to achieve fame.", null, 4.0, "Quentin Tarantino", 161 }
                });

            migrationBuilder.InsertData(
                table: "Glumci",
                columns: new[] { "Id", "Biografija", "DatumRodjenja", "Ime", "Prezime", "Slika" },
                values: new object[,]
                {
                    { 1, "Americki glumac", new DateTime(1974, 11, 11, 0, 0, 0, 0, DateTimeKind.Unspecified), "Leonardo", "DiCaprio", null },
                    { 2, "Americki glumac i producent", new DateTime(1963, 12, 18, 0, 0, 0, 0, DateTimeKind.Unspecified), "Brad", "Pitt", null },
                    { 3, "Australska glumica", new DateTime(1990, 7, 2, 0, 0, 0, 0, DateTimeKind.Unspecified), "Margot", "Robbie", null },
                    { 4, "Americka glumica", new DateTime(1984, 11, 22, 0, 0, 0, 0, DateTimeKind.Unspecified), "Scarlett", "Johansson", null },
                    { 5, "Americki glumac", new DateTime(1965, 4, 4, 0, 0, 0, 0, DateTimeKind.Unspecified), "Robert", "Downey Jr.", null }
                });

            migrationBuilder.InsertData(
                table: "Korisnici",
                columns: new[] { "Id", "DatumIzmjene", "DatumKreiranja", "Email", "Ime", "IsPremium", "KorisnickoIme", "LozinkaHash", "LozinkaSalt", "Prezime", "Slika", "Status", "Telefon" },
                values: new object[,]
                {
                    { 1, new DateTime(2025, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified), new DateTime(2025, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified), "admin@stagledas.com", "Admin", false, "admin", "kRbnt3DawgxSAtDyVNOVc3DfSEk=", "PK1joKVv57QVYQUHvQeoFw==", "Admin", null, true, "061000000" },
                    { 2, new DateTime(2025, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified), new DateTime(2025, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified), "test@stagledas.com", "Test", true, "test", "kRbnt3DawgxSAtDyVNOVc3DfSEk=", "PK1joKVv57QVYQUHvQeoFw==", "User", null, true, "062000000" }
                });

            migrationBuilder.InsertData(
                table: "Uloge",
                columns: new[] { "Id", "Naziv", "Opis" },
                values: new object[,]
                {
                    { 1, "Administrator", "Administrator sistema" },
                    { 2, "Korisnik", "Standardni korisnik" },
                    { 3, "PremiumKorisnik", "Premium korisnik sa dodatnim privilegijama" }
                });

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

            migrationBuilder.InsertData(
                table: "KorisniciUloge",
                columns: new[] { "Id", "KorisnikId", "UlogaId" },
                values: new object[,]
                {
                    { 1, 1, 1 },
                    { 2, 2, 2 },
                    { 3, 2, 3 }
                });

            migrationBuilder.CreateIndex(
                name: "IX_FilmoviGlumci_FilmId",
                table: "FilmoviGlumci",
                column: "FilmId");

            migrationBuilder.CreateIndex(
                name: "IX_FilmoviGlumci_GlumacId",
                table: "FilmoviGlumci",
                column: "GlumacId");

            migrationBuilder.CreateIndex(
                name: "IX_FilmoviZanrovi_FilmId",
                table: "FilmoviZanrovi",
                column: "FilmId");

            migrationBuilder.CreateIndex(
                name: "IX_FilmoviZanrovi_ZanrId",
                table: "FilmoviZanrovi",
                column: "ZanrId");

            migrationBuilder.CreateIndex(
                name: "IX_KorisniciUloge_KorisnikId",
                table: "KorisniciUloge",
                column: "KorisnikId");

            migrationBuilder.CreateIndex(
                name: "IX_KorisniciUloge_UlogaId",
                table: "KorisniciUloge",
                column: "UlogaId");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "FilmoviGlumci");

            migrationBuilder.DropTable(
                name: "FilmoviZanrovi");

            migrationBuilder.DropTable(
                name: "KorisniciUloge");

            migrationBuilder.DropTable(
                name: "Glumci");

            migrationBuilder.DropTable(
                name: "Filmovi");

            migrationBuilder.DropTable(
                name: "Zanrovi");

            migrationBuilder.DropTable(
                name: "Korisnici");

            migrationBuilder.DropTable(
                name: "Uloge");
        }
    }
}
