using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace staGledas.Service.Migrations
{
    /// <inheritdoc />
    public partial class ImagePosterPath : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "Slika",
                table: "Glumci");

            migrationBuilder.DropColumn(
                name: "Poster",
                table: "Filmovi");

            migrationBuilder.AddColumn<string>(
                name: "SlikaPath",
                table: "Glumci",
                type: "nvarchar(max)",
                nullable: true);

            migrationBuilder.AddColumn<string>(
                name: "PosterPath",
                table: "Filmovi",
                type: "nvarchar(max)",
                nullable: true);

            migrationBuilder.UpdateData(
                table: "Filmovi",
                keyColumn: "Id",
                keyValue: 1,
                column: "PosterPath",
                value: null);

            migrationBuilder.UpdateData(
                table: "Filmovi",
                keyColumn: "Id",
                keyValue: 2,
                column: "PosterPath",
                value: null);

            migrationBuilder.UpdateData(
                table: "Filmovi",
                keyColumn: "Id",
                keyValue: 3,
                column: "PosterPath",
                value: null);

            migrationBuilder.UpdateData(
                table: "Glumci",
                keyColumn: "Id",
                keyValue: 1,
                column: "SlikaPath",
                value: null);

            migrationBuilder.UpdateData(
                table: "Glumci",
                keyColumn: "Id",
                keyValue: 2,
                column: "SlikaPath",
                value: null);

            migrationBuilder.UpdateData(
                table: "Glumci",
                keyColumn: "Id",
                keyValue: 3,
                column: "SlikaPath",
                value: null);

            migrationBuilder.UpdateData(
                table: "Glumci",
                keyColumn: "Id",
                keyValue: 4,
                column: "SlikaPath",
                value: null);

            migrationBuilder.UpdateData(
                table: "Glumci",
                keyColumn: "Id",
                keyValue: 5,
                column: "SlikaPath",
                value: null);

            migrationBuilder.UpdateData(
                table: "Korisnici",
                keyColumn: "Id",
                keyValue: 1,
                columns: new[] { "LozinkaHash", "LozinkaSalt" },
                values: new object[] { "mPCIPlMI25RH65o919hAHUxVsVE=", "vLaB3CmzJZfiFR0WDxD+0A==" });

            migrationBuilder.UpdateData(
                table: "Korisnici",
                keyColumn: "Id",
                keyValue: 2,
                columns: new[] { "LozinkaHash", "LozinkaSalt" },
                values: new object[] { "mPCIPlMI25RH65o919hAHUxVsVE=", "vLaB3CmzJZfiFR0WDxD+0A==" });
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "SlikaPath",
                table: "Glumci");

            migrationBuilder.DropColumn(
                name: "PosterPath",
                table: "Filmovi");

            migrationBuilder.AddColumn<byte[]>(
                name: "Slika",
                table: "Glumci",
                type: "varbinary(max)",
                nullable: true);

            migrationBuilder.AddColumn<byte[]>(
                name: "Poster",
                table: "Filmovi",
                type: "varbinary(max)",
                nullable: true);

            migrationBuilder.UpdateData(
                table: "Filmovi",
                keyColumn: "Id",
                keyValue: 1,
                column: "Poster",
                value: null);

            migrationBuilder.UpdateData(
                table: "Filmovi",
                keyColumn: "Id",
                keyValue: 2,
                column: "Poster",
                value: null);

            migrationBuilder.UpdateData(
                table: "Filmovi",
                keyColumn: "Id",
                keyValue: 3,
                column: "Poster",
                value: null);

            migrationBuilder.UpdateData(
                table: "Glumci",
                keyColumn: "Id",
                keyValue: 1,
                column: "Slika",
                value: null);

            migrationBuilder.UpdateData(
                table: "Glumci",
                keyColumn: "Id",
                keyValue: 2,
                column: "Slika",
                value: null);

            migrationBuilder.UpdateData(
                table: "Glumci",
                keyColumn: "Id",
                keyValue: 3,
                column: "Slika",
                value: null);

            migrationBuilder.UpdateData(
                table: "Glumci",
                keyColumn: "Id",
                keyValue: 4,
                column: "Slika",
                value: null);

            migrationBuilder.UpdateData(
                table: "Glumci",
                keyColumn: "Id",
                keyValue: 5,
                column: "Slika",
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
    }
}
