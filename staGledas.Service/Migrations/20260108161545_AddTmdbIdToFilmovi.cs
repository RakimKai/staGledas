using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace staGledas.Service.Migrations
{
    /// <inheritdoc />
    public partial class AddTmdbIdToFilmovi : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<int>(
                name: "TmdbId",
                table: "Filmovi",
                type: "int",
                nullable: true);

            migrationBuilder.UpdateData(
                table: "Filmovi",
                keyColumn: "Id",
                keyValue: 1,
                column: "TmdbId",
                value: null);

            migrationBuilder.UpdateData(
                table: "Filmovi",
                keyColumn: "Id",
                keyValue: 2,
                column: "TmdbId",
                value: null);

            migrationBuilder.UpdateData(
                table: "Filmovi",
                keyColumn: "Id",
                keyValue: 3,
                column: "TmdbId",
                value: null);

            migrationBuilder.UpdateData(
                table: "Korisnici",
                keyColumn: "Id",
                keyValue: 1,
                columns: new[] { "LozinkaHash", "LozinkaSalt" },
                values: new object[] { "DiPVj6SUEZxq2lHgApvFdbZoIk4=", "ypogyqv9nORCe8uLqpwL9Q==" });

            migrationBuilder.UpdateData(
                table: "Korisnici",
                keyColumn: "Id",
                keyValue: 2,
                columns: new[] { "LozinkaHash", "LozinkaSalt" },
                values: new object[] { "DiPVj6SUEZxq2lHgApvFdbZoIk4=", "ypogyqv9nORCe8uLqpwL9Q==" });
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "TmdbId",
                table: "Filmovi");

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
        }
    }
}
