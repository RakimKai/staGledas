using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace staGledas.Service.Migrations
{
    /// <inheritdoc />
    public partial class ChangeOcjenaToDouble : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "RecenzijeLajkovi");

            migrationBuilder.DropColumn(
                name: "BrojLajkova",
                table: "Recenzije");

            migrationBuilder.AlterColumn<double>(
                name: "Ocjena",
                table: "Recenzije",
                type: "float",
                nullable: false,
                oldClrType: typeof(int),
                oldType: "int");

            migrationBuilder.UpdateData(
                table: "Korisnici",
                keyColumn: "Id",
                keyValue: 1,
                columns: new[] { "LozinkaHash", "LozinkaSalt" },
                values: new object[] { "nhTP4pnrmrmSwxy9q6NHLi2OATA=", "DFzSYJIVSCHU2EAlvmbMbg==" });

            migrationBuilder.UpdateData(
                table: "Korisnici",
                keyColumn: "Id",
                keyValue: 2,
                columns: new[] { "LozinkaHash", "LozinkaSalt" },
                values: new object[] { "nhTP4pnrmrmSwxy9q6NHLi2OATA=", "DFzSYJIVSCHU2EAlvmbMbg==" });

            migrationBuilder.UpdateData(
                table: "Recenzije",
                keyColumn: "Id",
                keyValue: 1,
                column: "Ocjena",
                value: 5.0);

            migrationBuilder.UpdateData(
                table: "Recenzije",
                keyColumn: "Id",
                keyValue: 2,
                column: "Ocjena",
                value: 4.0);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AlterColumn<int>(
                name: "Ocjena",
                table: "Recenzije",
                type: "int",
                nullable: false,
                oldClrType: typeof(double),
                oldType: "float");

            migrationBuilder.AddColumn<int>(
                name: "BrojLajkova",
                table: "Recenzije",
                type: "int",
                nullable: true);

            migrationBuilder.CreateTable(
                name: "RecenzijeLajkovi",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    KorisnikId = table.Column<int>(type: "int", nullable: false),
                    RecenzijaId = table.Column<int>(type: "int", nullable: false),
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
                columns: new[] { "BrojLajkova", "Ocjena" },
                values: new object[] { 25, 5 });

            migrationBuilder.UpdateData(
                table: "Recenzije",
                keyColumn: "Id",
                keyValue: 2,
                columns: new[] { "BrojLajkova", "Ocjena" },
                values: new object[] { 18, 4 });

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
    }
}
