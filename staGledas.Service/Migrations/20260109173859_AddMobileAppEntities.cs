using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace staGledas.Service.Migrations
{
    /// <inheritdoc />
    public partial class AddMobileAppEntities : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<bool>(
                name: "ImaSpoiler",
                table: "Recenzije",
                type: "bit",
                nullable: false,
                defaultValue: false);

            migrationBuilder.AddColumn<int>(
                name: "BrojLajkova",
                table: "Filmovi",
                type: "int",
                nullable: true);

            migrationBuilder.CreateTable(
                name: "Favoriti",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    KorisnikId = table.Column<int>(type: "int", nullable: false),
                    FilmId = table.Column<int>(type: "int", nullable: false),
                    DatumDodavanja = table.Column<DateTime>(type: "datetime2", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Favoriti", x => x.Id);
                    table.ForeignKey(
                        name: "FK_Favoriti_Filmovi_FilmId",
                        column: x => x.FilmId,
                        principalTable: "Filmovi",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_Favoriti_Korisnici_KorisnikId",
                        column: x => x.KorisnikId,
                        principalTable: "Korisnici",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "FilmoviLajkovi",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    KorisnikId = table.Column<int>(type: "int", nullable: false),
                    FilmId = table.Column<int>(type: "int", nullable: false),
                    DatumLajka = table.Column<DateTime>(type: "datetime2", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_FilmoviLajkovi", x => x.Id);
                    table.ForeignKey(
                        name: "FK_FilmoviLajkovi_Filmovi_FilmId",
                        column: x => x.FilmId,
                        principalTable: "Filmovi",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_FilmoviLajkovi_Korisnici_KorisnikId",
                        column: x => x.KorisnikId,
                        principalTable: "Korisnici",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "KlubObjave",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    KlubId = table.Column<int>(type: "int", nullable: false),
                    KorisnikId = table.Column<int>(type: "int", nullable: false),
                    Sadrzaj = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    DatumKreiranja = table.Column<DateTime>(type: "datetime2", nullable: false),
                    DatumIzmjene = table.Column<DateTime>(type: "datetime2", nullable: true),
                    IsDeleted = table.Column<bool>(type: "bit", nullable: false),
                    DatumBrisanja = table.Column<DateTime>(type: "datetime2", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_KlubObjave", x => x.Id);
                    table.ForeignKey(
                        name: "FK_KlubObjave_KlubFilmova_KlubId",
                        column: x => x.KlubId,
                        principalTable: "KlubFilmova",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_KlubObjave_Korisnici_KorisnikId",
                        column: x => x.KorisnikId,
                        principalTable: "Korisnici",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Restrict);
                });

            migrationBuilder.CreateTable(
                name: "RecenzijeLajkovi",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    RecenzijaId = table.Column<int>(type: "int", nullable: false),
                    KorisnikId = table.Column<int>(type: "int", nullable: false),
                    DatumLajka = table.Column<DateTime>(type: "datetime2", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_RecenzijeLajkovi", x => x.Id);
                    table.ForeignKey(
                        name: "FK_RecenzijeLajkovi_Korisnici_KorisnikId",
                        column: x => x.KorisnikId,
                        principalTable: "Korisnici",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_RecenzijeLajkovi_Recenzije_RecenzijaId",
                        column: x => x.RecenzijaId,
                        principalTable: "Recenzije",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "KlubKomentari",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    ObjavaId = table.Column<int>(type: "int", nullable: false),
                    KorisnikId = table.Column<int>(type: "int", nullable: false),
                    Sadrzaj = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    DatumKreiranja = table.Column<DateTime>(type: "datetime2", nullable: false),
                    ParentKomentarId = table.Column<int>(type: "int", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_KlubKomentari", x => x.Id);
                    table.ForeignKey(
                        name: "FK_KlubKomentari_KlubKomentari_ParentKomentarId",
                        column: x => x.ParentKomentarId,
                        principalTable: "KlubKomentari",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Restrict);
                    table.ForeignKey(
                        name: "FK_KlubKomentari_KlubObjave_ObjavaId",
                        column: x => x.ObjavaId,
                        principalTable: "KlubObjave",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_KlubKomentari_Korisnici_KorisnikId",
                        column: x => x.KorisnikId,
                        principalTable: "Korisnici",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Restrict);
                });

            migrationBuilder.CreateTable(
                name: "KlubLajkovi",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    ObjavaId = table.Column<int>(type: "int", nullable: false),
                    KorisnikId = table.Column<int>(type: "int", nullable: false),
                    DatumLajka = table.Column<DateTime>(type: "datetime2", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_KlubLajkovi", x => x.Id);
                    table.ForeignKey(
                        name: "FK_KlubLajkovi_KlubObjave_ObjavaId",
                        column: x => x.ObjavaId,
                        principalTable: "KlubObjave",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_KlubLajkovi_Korisnici_KorisnikId",
                        column: x => x.KorisnikId,
                        principalTable: "Korisnici",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Restrict);
                });

            migrationBuilder.UpdateData(
                table: "Filmovi",
                keyColumn: "Id",
                keyValue: 1,
                column: "BrojLajkova",
                value: null);

            migrationBuilder.UpdateData(
                table: "Filmovi",
                keyColumn: "Id",
                keyValue: 2,
                column: "BrojLajkova",
                value: null);

            migrationBuilder.UpdateData(
                table: "Filmovi",
                keyColumn: "Id",
                keyValue: 3,
                column: "BrojLajkova",
                value: null);

            migrationBuilder.UpdateData(
                table: "Korisnici",
                keyColumn: "Id",
                keyValue: 1,
                columns: new[] { "LozinkaHash", "LozinkaSalt" },
                values: new object[] { "5nzFwUzQDw0z9GM3l74vzOByvj4=", "5Cg35CIvLYHojzBgbp+BUw==" });

            migrationBuilder.UpdateData(
                table: "Korisnici",
                keyColumn: "Id",
                keyValue: 2,
                columns: new[] { "LozinkaHash", "LozinkaSalt" },
                values: new object[] { "5nzFwUzQDw0z9GM3l74vzOByvj4=", "5Cg35CIvLYHojzBgbp+BUw==" });

            migrationBuilder.UpdateData(
                table: "Recenzije",
                keyColumn: "Id",
                keyValue: 1,
                column: "ImaSpoiler",
                value: false);

            migrationBuilder.UpdateData(
                table: "Recenzije",
                keyColumn: "Id",
                keyValue: 2,
                column: "ImaSpoiler",
                value: false);

            migrationBuilder.CreateIndex(
                name: "IX_Favoriti_FilmId",
                table: "Favoriti",
                column: "FilmId");

            migrationBuilder.CreateIndex(
                name: "IX_Favoriti_KorisnikId_FilmId",
                table: "Favoriti",
                columns: new[] { "KorisnikId", "FilmId" },
                unique: true);

            migrationBuilder.CreateIndex(
                name: "IX_FilmoviLajkovi_FilmId",
                table: "FilmoviLajkovi",
                column: "FilmId");

            migrationBuilder.CreateIndex(
                name: "IX_FilmoviLajkovi_KorisnikId_FilmId",
                table: "FilmoviLajkovi",
                columns: new[] { "KorisnikId", "FilmId" },
                unique: true);

            migrationBuilder.CreateIndex(
                name: "IX_KlubKomentari_KorisnikId",
                table: "KlubKomentari",
                column: "KorisnikId");

            migrationBuilder.CreateIndex(
                name: "IX_KlubKomentari_ObjavaId",
                table: "KlubKomentari",
                column: "ObjavaId");

            migrationBuilder.CreateIndex(
                name: "IX_KlubKomentari_ParentKomentarId",
                table: "KlubKomentari",
                column: "ParentKomentarId");

            migrationBuilder.CreateIndex(
                name: "IX_KlubLajkovi_KorisnikId_ObjavaId",
                table: "KlubLajkovi",
                columns: new[] { "KorisnikId", "ObjavaId" },
                unique: true);

            migrationBuilder.CreateIndex(
                name: "IX_KlubLajkovi_ObjavaId",
                table: "KlubLajkovi",
                column: "ObjavaId");

            migrationBuilder.CreateIndex(
                name: "IX_KlubObjave_KlubId",
                table: "KlubObjave",
                column: "KlubId");

            migrationBuilder.CreateIndex(
                name: "IX_KlubObjave_KorisnikId",
                table: "KlubObjave",
                column: "KorisnikId");

            migrationBuilder.CreateIndex(
                name: "IX_RecenzijeLajkovi_KorisnikId_RecenzijaId",
                table: "RecenzijeLajkovi",
                columns: new[] { "KorisnikId", "RecenzijaId" },
                unique: true);

            migrationBuilder.CreateIndex(
                name: "IX_RecenzijeLajkovi_RecenzijaId",
                table: "RecenzijeLajkovi",
                column: "RecenzijaId");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "Favoriti");

            migrationBuilder.DropTable(
                name: "FilmoviLajkovi");

            migrationBuilder.DropTable(
                name: "KlubKomentari");

            migrationBuilder.DropTable(
                name: "KlubLajkovi");

            migrationBuilder.DropTable(
                name: "RecenzijeLajkovi");

            migrationBuilder.DropTable(
                name: "KlubObjave");

            migrationBuilder.DropColumn(
                name: "ImaSpoiler",
                table: "Recenzije");

            migrationBuilder.DropColumn(
                name: "BrojLajkova",
                table: "Filmovi");

            migrationBuilder.UpdateData(
                table: "Korisnici",
                keyColumn: "Id",
                keyValue: 1,
                columns: new[] { "LozinkaHash", "LozinkaSalt" },
                values: new object[] { "DOKqbZ7wlT6BcZmHDTBI3JM3FAE=", "VNRK/e9PM5DYHbCl8jaXPw==" });

            migrationBuilder.UpdateData(
                table: "Korisnici",
                keyColumn: "Id",
                keyValue: 2,
                columns: new[] { "LozinkaHash", "LozinkaSalt" },
                values: new object[] { "DOKqbZ7wlT6BcZmHDTBI3JM3FAE=", "VNRK/e9PM5DYHbCl8jaXPw==" });
        }
    }
}
