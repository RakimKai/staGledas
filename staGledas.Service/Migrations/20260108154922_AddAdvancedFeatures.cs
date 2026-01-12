using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace staGledas.Service.Migrations
{
    /// <inheritdoc />
    public partial class AddAdvancedFeatures : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.CreateTable(
                name: "KlubFilmova",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Naziv = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    Opis = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    Slika = table.Column<byte[]>(type: "varbinary(max)", nullable: true),
                    VlasnikId = table.Column<int>(type: "int", nullable: false),
                    IsPrivate = table.Column<bool>(type: "bit", nullable: false),
                    MaxClanova = table.Column<int>(type: "int", nullable: true),
                    DatumKreiranja = table.Column<DateTime>(type: "datetime2", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_KlubFilmova", x => x.Id);
                    table.ForeignKey(
                        name: "FK_KlubFilmova_Korisnici_VlasnikId",
                        column: x => x.VlasnikId,
                        principalTable: "Korisnici",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Restrict);
                });

            migrationBuilder.CreateTable(
                name: "Pretplate",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    KorisnikId = table.Column<int>(type: "int", nullable: false),
                    StripeCustomerId = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    StripeSubscriptionId = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    StripePriceId = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    Status = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    DatumPocetka = table.Column<DateTime>(type: "datetime2", nullable: true),
                    DatumIsteka = table.Column<DateTime>(type: "datetime2", nullable: true),
                    DatumKreiranja = table.Column<DateTime>(type: "datetime2", nullable: false),
                    DatumIzmjene = table.Column<DateTime>(type: "datetime2", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Pretplate", x => x.Id);
                    table.ForeignKey(
                        name: "FK_Pretplate_Korisnici_KorisnikId",
                        column: x => x.KorisnikId,
                        principalTable: "Korisnici",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "Zalbe",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    RecenzijaId = table.Column<int>(type: "int", nullable: false),
                    KorisnikId = table.Column<int>(type: "int", nullable: false),
                    Razlog = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    Opis = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    Status = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    DatumKreiranja = table.Column<DateTime>(type: "datetime2", nullable: false),
                    DatumObrade = table.Column<DateTime>(type: "datetime2", nullable: true),
                    ObradioPrijavuId = table.Column<int>(type: "int", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Zalbe", x => x.Id);
                    table.ForeignKey(
                        name: "FK_Zalbe_Korisnici_KorisnikId",
                        column: x => x.KorisnikId,
                        principalTable: "Korisnici",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Restrict);
                    table.ForeignKey(
                        name: "FK_Zalbe_Korisnici_ObradioPrijavuId",
                        column: x => x.ObradioPrijavuId,
                        principalTable: "Korisnici",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Restrict);
                    table.ForeignKey(
                        name: "FK_Zalbe_Recenzije_RecenzijaId",
                        column: x => x.RecenzijaId,
                        principalTable: "Recenzije",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "KlubFilmovaClanovi",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    KlubId = table.Column<int>(type: "int", nullable: false),
                    KorisnikId = table.Column<int>(type: "int", nullable: false),
                    Uloga = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    DatumPridruzivanja = table.Column<DateTime>(type: "datetime2", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_KlubFilmovaClanovi", x => x.Id);
                    table.ForeignKey(
                        name: "FK_KlubFilmovaClanovi_KlubFilmova_KlubId",
                        column: x => x.KlubId,
                        principalTable: "KlubFilmova",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_KlubFilmovaClanovi_Korisnici_KorisnikId",
                        column: x => x.KorisnikId,
                        principalTable: "Korisnici",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Restrict);
                });

            migrationBuilder.UpdateData(
                table: "Korisnici",
                keyColumn: "Id",
                keyValue: 1,
                columns: new[] { "LozinkaHash", "LozinkaSalt" },
                values: new object[] { "5lhkx/DqQma55DM1jVuZE19PjKQ=", "A0WDv0rvtPuO0biqThB6Pw==" });

            migrationBuilder.UpdateData(
                table: "Korisnici",
                keyColumn: "Id",
                keyValue: 2,
                columns: new[] { "LozinkaHash", "LozinkaSalt" },
                values: new object[] { "5lhkx/DqQma55DM1jVuZE19PjKQ=", "A0WDv0rvtPuO0biqThB6Pw==" });

            migrationBuilder.CreateIndex(
                name: "IX_KlubFilmova_VlasnikId",
                table: "KlubFilmova",
                column: "VlasnikId");

            migrationBuilder.CreateIndex(
                name: "IX_KlubFilmovaClanovi_KlubId",
                table: "KlubFilmovaClanovi",
                column: "KlubId");

            migrationBuilder.CreateIndex(
                name: "IX_KlubFilmovaClanovi_KorisnikId",
                table: "KlubFilmovaClanovi",
                column: "KorisnikId");

            migrationBuilder.CreateIndex(
                name: "IX_Pretplate_KorisnikId",
                table: "Pretplate",
                column: "KorisnikId");

            migrationBuilder.CreateIndex(
                name: "IX_Zalbe_KorisnikId",
                table: "Zalbe",
                column: "KorisnikId");

            migrationBuilder.CreateIndex(
                name: "IX_Zalbe_ObradioPrijavuId",
                table: "Zalbe",
                column: "ObradioPrijavuId");

            migrationBuilder.CreateIndex(
                name: "IX_Zalbe_RecenzijaId",
                table: "Zalbe",
                column: "RecenzijaId");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "KlubFilmovaClanovi");

            migrationBuilder.DropTable(
                name: "Pretplate");

            migrationBuilder.DropTable(
                name: "Zalbe");

            migrationBuilder.DropTable(
                name: "KlubFilmova");

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
        }
    }
}
