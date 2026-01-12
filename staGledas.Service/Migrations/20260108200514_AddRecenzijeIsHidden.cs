using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace staGledas.Service.Migrations
{
    /// <inheritdoc />
    public partial class AddRecenzijeIsHidden : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<DateTime>(
                name: "DatumSkrivanja",
                table: "Recenzije",
                type: "datetime2",
                nullable: true);

            migrationBuilder.AddColumn<bool>(
                name: "IsHidden",
                table: "Recenzije",
                type: "bit",
                nullable: false,
                defaultValue: false);

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

            migrationBuilder.UpdateData(
                table: "Recenzije",
                keyColumn: "Id",
                keyValue: 1,
                columns: new[] { "DatumSkrivanja", "IsHidden" },
                values: new object[] { null, false });

            migrationBuilder.UpdateData(
                table: "Recenzije",
                keyColumn: "Id",
                keyValue: 2,
                columns: new[] { "DatumSkrivanja", "IsHidden" },
                values: new object[] { null, false });
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "DatumSkrivanja",
                table: "Recenzije");

            migrationBuilder.DropColumn(
                name: "IsHidden",
                table: "Recenzije");

            migrationBuilder.UpdateData(
                table: "Korisnici",
                keyColumn: "Id",
                keyValue: 1,
                columns: new[] { "LozinkaHash", "LozinkaSalt" },
                values: new object[] { "oYswjVKvdXGkX5eKuhwAIo15t94=", "s+7g5bmKHp78/j6N1AQScQ==" });

            migrationBuilder.UpdateData(
                table: "Korisnici",
                keyColumn: "Id",
                keyValue: 2,
                columns: new[] { "LozinkaHash", "LozinkaSalt" },
                values: new object[] { "oYswjVKvdXGkX5eKuhwAIo15t94=", "s+7g5bmKHp78/j6N1AQScQ==" });
        }
    }
}
