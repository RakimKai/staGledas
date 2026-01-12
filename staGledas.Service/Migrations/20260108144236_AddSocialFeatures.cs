using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

#pragma warning disable CA1814 // Prefer jagged arrays over multidimensional

namespace staGledas.Service.Migrations
{
    /// <inheritdoc />
    public partial class AddSocialFeatures : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.CreateTable(
                name: "Novosti",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Naslov = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    Sadrzaj = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    Kategorija = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    Slika = table.Column<byte[]>(type: "varbinary(max)", nullable: true),
                    AutorId = table.Column<int>(type: "int", nullable: false),
                    BrojPregleda = table.Column<int>(type: "int", nullable: true),
                    DatumKreiranja = table.Column<DateTime>(type: "datetime2", nullable: false),
                    DatumIzmjene = table.Column<DateTime>(type: "datetime2", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Novosti", x => x.Id);
                    table.ForeignKey(
                        name: "FK_Novosti_Korisnici_AutorId",
                        column: x => x.AutorId,
                        principalTable: "Korisnici",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Restrict);
                });

            migrationBuilder.CreateTable(
                name: "Poruke",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    PosiljateljId = table.Column<int>(type: "int", nullable: false),
                    PrimateljId = table.Column<int>(type: "int", nullable: false),
                    Sadrzaj = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    Procitano = table.Column<bool>(type: "bit", nullable: false),
                    DatumSlanja = table.Column<DateTime>(type: "datetime2", nullable: false),
                    DatumCitanja = table.Column<DateTime>(type: "datetime2", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Poruke", x => x.Id);
                    table.ForeignKey(
                        name: "FK_Poruke_Korisnici_PosiljateljId",
                        column: x => x.PosiljateljId,
                        principalTable: "Korisnici",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Restrict);
                    table.ForeignKey(
                        name: "FK_Poruke_Korisnici_PrimateljId",
                        column: x => x.PrimateljId,
                        principalTable: "Korisnici",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Restrict);
                });

            migrationBuilder.CreateTable(
                name: "Pratitelji",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    KorisnikId = table.Column<int>(type: "int", nullable: false),
                    PratiteljId = table.Column<int>(type: "int", nullable: false),
                    DatumPracenja = table.Column<DateTime>(type: "datetime2", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Pratitelji", x => x.Id);
                    table.ForeignKey(
                        name: "FK_Pratitelji_Korisnici_KorisnikId",
                        column: x => x.KorisnikId,
                        principalTable: "Korisnici",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Restrict);
                    table.ForeignKey(
                        name: "FK_Pratitelji_Korisnici_PratiteljId",
                        column: x => x.PratiteljId,
                        principalTable: "Korisnici",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Restrict);
                });

            migrationBuilder.CreateTable(
                name: "Recenzije",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    KorisnikId = table.Column<int>(type: "int", nullable: false),
                    FilmId = table.Column<int>(type: "int", nullable: false),
                    Ocjena = table.Column<int>(type: "int", nullable: false),
                    Naslov = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    Sadrzaj = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    BrojLajkova = table.Column<int>(type: "int", nullable: true),
                    DatumKreiranja = table.Column<DateTime>(type: "datetime2", nullable: false),
                    DatumIzmjene = table.Column<DateTime>(type: "datetime2", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Recenzije", x => x.Id);
                    table.ForeignKey(
                        name: "FK_Recenzije_Filmovi_FilmId",
                        column: x => x.FilmId,
                        principalTable: "Filmovi",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_Recenzije_Korisnici_KorisnikId",
                        column: x => x.KorisnikId,
                        principalTable: "Korisnici",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Restrict);
                });

            migrationBuilder.CreateTable(
                name: "Watchlist",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    KorisnikId = table.Column<int>(type: "int", nullable: false),
                    FilmId = table.Column<int>(type: "int", nullable: false),
                    DatumDodavanja = table.Column<DateTime>(type: "datetime2", nullable: false),
                    Pogledano = table.Column<bool>(type: "bit", nullable: true),
                    DatumGledanja = table.Column<DateTime>(type: "datetime2", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Watchlist", x => x.Id);
                    table.ForeignKey(
                        name: "FK_Watchlist_Filmovi_FilmId",
                        column: x => x.FilmId,
                        principalTable: "Filmovi",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_Watchlist_Korisnici_KorisnikId",
                        column: x => x.KorisnikId,
                        principalTable: "Korisnici",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.UpdateData(
                table: "Korisnici",
                keyColumn: "Id",
                keyValue: 1,
                columns: new[] { "LozinkaHash", "LozinkaSalt" },
                values: new object[] { "VB88j05MfuZp35J7s5Bg4EQDhuQ=", "8WoCDOly1cn6Ff/mS83mMA==" });

            migrationBuilder.UpdateData(
                table: "Korisnici",
                keyColumn: "Id",
                keyValue: 2,
                columns: new[] { "LozinkaHash", "LozinkaSalt" },
                values: new object[] { "VB88j05MfuZp35J7s5Bg4EQDhuQ=", "8WoCDOly1cn6Ff/mS83mMA==" });

            migrationBuilder.InsertData(
                table: "Novosti",
                columns: new[] { "Id", "AutorId", "BrojPregleda", "DatumIzmjene", "DatumKreiranja", "Kategorija", "Naslov", "Sadrzaj", "Slika" },
                values: new object[,]
                {
                    { 1, 1, 150, null, new DateTime(2025, 1, 15, 0, 0, 0, 0, DateTimeKind.Unspecified), "Oscars", "Oscars 2025: Najbolji filmovi godine", "Pregled nominacija za Oscara 2025. Saznajte koji filmovi su u utrci za najvaznije filmske nagrade.", null },
                    { 2, 1, 230, null, new DateTime(2025, 1, 10, 0, 0, 0, 0, DateTimeKind.Unspecified), "Vijesti", "Novi Nolan film najavljljen za 2026", "Christopher Nolan najavio je svoj novi projekt koji ce biti objavljen 2026. godine.", null }
                });

            migrationBuilder.InsertData(
                table: "Recenzije",
                columns: new[] { "Id", "BrojLajkova", "DatumIzmjene", "DatumKreiranja", "FilmId", "KorisnikId", "Naslov", "Ocjena", "Sadrzaj" },
                values: new object[,]
                {
                    { 1, 25, null, new DateTime(2025, 1, 5, 0, 0, 0, 0, DateTimeKind.Unspecified), 1, 2, "Remek djelo!", 5, "Inception je jedan od najboljih filmova koje sam ikada gledao. Nolan je genij." },
                    { 2, 18, null, new DateTime(2025, 1, 6, 0, 0, 0, 0, DateTimeKind.Unspecified), 2, 2, "Odlicna gluma", 4, "DiCaprio je bio nevjerovatan u ulozi Jordan Belforta." }
                });

            migrationBuilder.CreateIndex(
                name: "IX_Novosti_AutorId",
                table: "Novosti",
                column: "AutorId");

            migrationBuilder.CreateIndex(
                name: "IX_Poruke_PosiljateljId",
                table: "Poruke",
                column: "PosiljateljId");

            migrationBuilder.CreateIndex(
                name: "IX_Poruke_PrimateljId",
                table: "Poruke",
                column: "PrimateljId");

            migrationBuilder.CreateIndex(
                name: "IX_Pratitelji_KorisnikId",
                table: "Pratitelji",
                column: "KorisnikId");

            migrationBuilder.CreateIndex(
                name: "IX_Pratitelji_PratiteljId",
                table: "Pratitelji",
                column: "PratiteljId");

            migrationBuilder.CreateIndex(
                name: "IX_Recenzije_FilmId",
                table: "Recenzije",
                column: "FilmId");

            migrationBuilder.CreateIndex(
                name: "IX_Recenzije_KorisnikId",
                table: "Recenzije",
                column: "KorisnikId");

            migrationBuilder.CreateIndex(
                name: "IX_Watchlist_FilmId",
                table: "Watchlist",
                column: "FilmId");

            migrationBuilder.CreateIndex(
                name: "IX_Watchlist_KorisnikId",
                table: "Watchlist",
                column: "KorisnikId");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "Novosti");

            migrationBuilder.DropTable(
                name: "Poruke");

            migrationBuilder.DropTable(
                name: "Pratitelji");

            migrationBuilder.DropTable(
                name: "Recenzije");

            migrationBuilder.DropTable(
                name: "Watchlist");

            migrationBuilder.UpdateData(
                table: "Korisnici",
                keyColumn: "Id",
                keyValue: 1,
                columns: new[] { "LozinkaHash", "LozinkaSalt" },
                values: new object[] { "kRbnt3DawgxSAtDyVNOVc3DfSEk=", "PK1joKVv57QVYQUHvQeoFw==" });

            migrationBuilder.UpdateData(
                table: "Korisnici",
                keyColumn: "Id",
                keyValue: 2,
                columns: new[] { "LozinkaHash", "LozinkaSalt" },
                values: new object[] { "kRbnt3DawgxSAtDyVNOVc3DfSEk=", "PK1joKVv57QVYQUHvQeoFw==" });
        }
    }
}
