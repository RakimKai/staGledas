using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace staGledas.Service.Migrations
{
    /// <inheritdoc />
    public partial class AddObavijesti : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.CreateTable(
                name: "Obavijesti",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Tip = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    PosiljateljId = table.Column<int>(type: "int", nullable: false),
                    PrimateljId = table.Column<int>(type: "int", nullable: false),
                    KlubId = table.Column<int>(type: "int", nullable: true),
                    Poruka = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    Status = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    Procitano = table.Column<bool>(type: "bit", nullable: false),
                    DatumKreiranja = table.Column<DateTime>(type: "datetime2", nullable: false),
                    DatumObrade = table.Column<DateTime>(type: "datetime2", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Obavijesti", x => x.Id);
                    table.ForeignKey(
                        name: "FK_Obavijesti_KlubFilmova_KlubId",
                        column: x => x.KlubId,
                        principalTable: "KlubFilmova",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_Obavijesti_Korisnici_PosiljateljId",
                        column: x => x.PosiljateljId,
                        principalTable: "Korisnici",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Restrict);
                    table.ForeignKey(
                        name: "FK_Obavijesti_Korisnici_PrimateljId",
                        column: x => x.PrimateljId,
                        principalTable: "Korisnici",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Restrict);
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

            migrationBuilder.CreateIndex(
                name: "IX_Obavijesti_KlubId",
                table: "Obavijesti",
                column: "KlubId");

            migrationBuilder.CreateIndex(
                name: "IX_Obavijesti_PosiljateljId",
                table: "Obavijesti",
                column: "PosiljateljId");

            migrationBuilder.CreateIndex(
                name: "IX_Obavijesti_PrimateljId",
                table: "Obavijesti",
                column: "PrimateljId");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "Obavijesti");

            migrationBuilder.UpdateData(
                table: "Korisnici",
                keyColumn: "Id",
                keyValue: 1,
                columns: new[] { "LozinkaHash", "LozinkaSalt" },
                values: new object[] { "D5LtiYi0QdrRAcE6N0u1Fl2AAt4=", "Nrm9UyO+4fyifu5gUmaBkA==" });

            migrationBuilder.UpdateData(
                table: "Korisnici",
                keyColumn: "Id",
                keyValue: 2,
                columns: new[] { "LozinkaHash", "LozinkaSalt" },
                values: new object[] { "D5LtiYi0QdrRAcE6N0u1Fl2AAt4=", "Nrm9UyO+4fyifu5gUmaBkA==" });
        }
    }
}
