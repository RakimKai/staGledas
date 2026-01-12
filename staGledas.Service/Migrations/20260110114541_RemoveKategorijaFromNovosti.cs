using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace staGledas.Service.Migrations
{
    /// <inheritdoc />
    public partial class RemoveKategorijaFromNovosti : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "Kategorija",
                table: "Novosti");

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

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<string>(
                name: "Kategorija",
                table: "Novosti",
                type: "nvarchar(max)",
                nullable: true);

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
                table: "Novosti",
                keyColumn: "Id",
                keyValue: 1,
                column: "Kategorija",
                value: "Oscars");

            migrationBuilder.UpdateData(
                table: "Novosti",
                keyColumn: "Id",
                keyValue: 2,
                column: "Kategorija",
                value: "Vijesti");
        }
    }
}
