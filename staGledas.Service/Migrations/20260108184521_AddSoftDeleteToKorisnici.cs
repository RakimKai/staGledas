using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace staGledas.Service.Migrations
{
    /// <inheritdoc />
    public partial class AddSoftDeleteToKorisnici : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<DateTime>(
                name: "DatumBrisanja",
                table: "Korisnici",
                type: "datetime2",
                nullable: true);

            migrationBuilder.AddColumn<bool>(
                name: "IsDeleted",
                table: "Korisnici",
                type: "bit",
                nullable: false,
                defaultValue: false);

            migrationBuilder.UpdateData(
                table: "Korisnici",
                keyColumn: "Id",
                keyValue: 1,
                columns: new[] { "DatumBrisanja", "IsDeleted", "LozinkaHash", "LozinkaSalt" },
                values: new object[] { null, false, "c4QGbJBvTHYgtzWQ73/Hm3JgF2U=", "sOKGmPuB5dPqDSfE7YT7fQ==" });

            migrationBuilder.UpdateData(
                table: "Korisnici",
                keyColumn: "Id",
                keyValue: 2,
                columns: new[] { "DatumBrisanja", "IsDeleted", "LozinkaHash", "LozinkaSalt" },
                values: new object[] { null, false, "c4QGbJBvTHYgtzWQ73/Hm3JgF2U=", "sOKGmPuB5dPqDSfE7YT7fQ==" });
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "DatumBrisanja",
                table: "Korisnici");

            migrationBuilder.DropColumn(
                name: "IsDeleted",
                table: "Korisnici");

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
    }
}
