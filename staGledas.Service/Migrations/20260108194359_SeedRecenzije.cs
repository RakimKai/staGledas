using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace staGledas.Service.Migrations
{
    /// <inheritdoc />
    public partial class SeedRecenzije : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.UpdateData(
                table: "Korisnici",
                keyColumn: "Id",
                keyValue: 1,
                columns: new[] { "LozinkaHash", "LozinkaSalt" },
                values: new object[] { "AKBIcol+ojwbE+pFZjZ1WCVU5tw=", "MM0moa3+w9Gyqs2LvMX6Qw==" });

            migrationBuilder.UpdateData(
                table: "Korisnici",
                keyColumn: "Id",
                keyValue: 2,
                columns: new[] { "LozinkaHash", "LozinkaSalt" },
                values: new object[] { "AKBIcol+ojwbE+pFZjZ1WCVU5tw=", "MM0moa3+w9Gyqs2LvMX6Qw==" });
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.UpdateData(
                table: "Korisnici",
                keyColumn: "Id",
                keyValue: 1,
                columns: new[] { "LozinkaHash", "LozinkaSalt" },
                values: new object[] { "c4QGbJBvTHYgtzWQ73/Hm3JgF2U=", "sOKGmPuB5dPqDSfE7YT7fQ==" });

            migrationBuilder.UpdateData(
                table: "Korisnici",
                keyColumn: "Id",
                keyValue: 2,
                columns: new[] { "LozinkaHash", "LozinkaSalt" },
                values: new object[] { "c4QGbJBvTHYgtzWQ73/Hm3JgF2U=", "sOKGmPuB5dPqDSfE7YT7fQ==" });
        }
    }
}
