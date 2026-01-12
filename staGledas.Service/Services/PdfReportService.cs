using QuestPDF.Fluent;
using QuestPDF.Helpers;
using QuestPDF.Infrastructure;
using staGledas.Model.DTOs.Reports;
using staGledas.Service.Interfaces;

namespace staGledas.Service.Services
{
    public class PdfReportService : IPdfReportService
    {
        public PdfReportService()
        {
            QuestPDF.Settings.License = LicenseType.Community;
        }

        public byte[] GenerateYearlyReport(int godina, AnalyticsReport report, UserTypeDistribution distribution)
        {
            var document = Document.Create(container =>
            {
                container.Page(page =>
                {
                    page.Size(PageSizes.A4);
                    page.Margin(40);
                    page.DefaultTextStyle(x => x.FontSize(11));

                    page.Header().Element(c => ComposeHeader(c, godina));
                    page.Content().Element(c => ComposeContent(c, report, distribution));
                    page.Footer().Element(ComposeFooter);
                });
            });

            return document.GeneratePdf();
        }

        private void ComposeHeader(IContainer container, int godina)
        {
            container.Column(column =>
            {
                column.Item().Row(row =>
                {
                    row.RelativeItem().Column(col =>
                    {
                        col.Item().Text("Sta Gledas?")
                            .FontSize(24)
                            .Bold()
                            .FontColor(Colors.Blue.Medium);

                        col.Item().Text("Godisnji izvjestaj")
                            .FontSize(14)
                            .FontColor(Colors.Grey.Medium);
                    });

                    row.ConstantItem(100).AlignRight().Column(col =>
                    {
                        col.Item().Text($"Godina: {godina}")
                            .FontSize(16)
                            .Bold();

                        col.Item().Text(DateTime.Now.ToString("dd.MM.yyyy"))
                            .FontSize(10)
                            .FontColor(Colors.Grey.Medium);
                    });
                });

                column.Item().PaddingTop(10).LineHorizontal(1).LineColor(Colors.Grey.Lighten2);
            });
        }

        private void ComposeContent(IContainer container, AnalyticsReport report, UserTypeDistribution distribution)
        {
            container.PaddingVertical(20).Column(column =>
            {
                column.Spacing(20);

                column.Item().Text("Statistika").FontSize(16).Bold().FontColor(Colors.Blue.Medium);

                column.Item().Table(table =>
                {
                    table.ColumnsDefinition(columns =>
                    {
                        columns.RelativeColumn(2);
                        columns.RelativeColumn(1);
                    });

                    table.Cell().Element(CellStyle).Text("Broj korisnika").Bold();
                    table.Cell().Element(CellStyle).AlignRight().Text(report.BrojKorisnika.ToString());

                    table.Cell().Element(CellStyle).Text("Broj premium korisnika").Bold();
                    table.Cell().Element(CellStyle).AlignRight().Text(report.BrojPremiumKorisnika.ToString());

                    table.Cell().Element(CellStyle).Text("Postotak premium korisnika").Bold();
                    table.Cell().Element(CellStyle).AlignRight().Text($"{report.PostotakPremiumKorisnika:F1}%");

                    table.Cell().Element(CellStyle).Text("Ukupni prihodi platforme").Bold();
                    table.Cell().Element(CellStyle).AlignRight().Text($"{report.UkupniPrihodi:N2} KM");

                    table.Cell().Element(CellStyle).Text("Broj obrisanih racuna").Bold();
                    table.Cell().Element(CellStyle).AlignRight().Text(report.BrojObrisanihRacuna.ToString());

                    table.Cell().Element(CellStyle).Text("Rast u odnosu na proslu godinu").Bold();
                    table.Cell().Element(CellStyle).AlignRight().Text($"{report.RastUOdnosuNaProslodisnjuGodinu:F1}%");

                    table.Cell().Element(CellStyle).Text("Broj kreiranih recenzija").Bold();
                    table.Cell().Element(CellStyle).AlignRight().Text(report.BrojKreiranihRecenzija.ToString());

                    table.Cell().Element(CellStyle).Text("Broj administratora").Bold();
                    table.Cell().Element(CellStyle).AlignRight().Text(report.BrojAdministratora.ToString());

                    static IContainer CellStyle(IContainer container) =>
                        container.BorderBottom(1).BorderColor(Colors.Grey.Lighten2).Padding(8);
                });

                column.Item().PaddingTop(20).Text("Distribucija korisnika").FontSize(16).Bold().FontColor(Colors.Blue.Medium);

                var standardUsers = report.BrojKorisnika - report.BrojPremiumKorisnika;
                column.Item().Row(row =>
                {
                    row.RelativeItem().Column(col =>
                    {
                        col.Item().Background(Colors.Blue.Lighten4).Padding(15).Column(inner =>
                        {
                            inner.Item().Text("Standardni korisnici").FontSize(12).FontColor(Colors.Grey.Darken2);
                            inner.Item().Text(standardUsers.ToString()).FontSize(24).Bold().FontColor(Colors.Blue.Medium);
                        });
                    });

                    row.ConstantItem(20);

                    row.RelativeItem().Column(col =>
                    {
                        col.Item().Background(Colors.Green.Lighten4).Padding(15).Column(inner =>
                        {
                            inner.Item().Text("Premium korisnici").FontSize(12).FontColor(Colors.Grey.Darken2);
                            inner.Item().Text(report.BrojPremiumKorisnika.ToString()).FontSize(24).Bold().FontColor(Colors.Green.Medium);
                        });
                    });

                    row.ConstantItem(20);

                    row.RelativeItem().Column(col =>
                    {
                        col.Item().Background(Colors.Orange.Lighten4).Padding(15).Column(inner =>
                        {
                            inner.Item().Text("Postotak premium").FontSize(12).FontColor(Colors.Grey.Darken2);
                            inner.Item().Text($"{report.PostotakPremiumKorisnika:F1}%").FontSize(24).Bold().FontColor(Colors.Orange.Medium);
                        });
                    });
                });

                if (report.MjesecnaStatistika != null && report.MjesecnaStatistika.Count > 0)
                {
                    column.Item().PaddingTop(20).Text("Mjesecna statistika").FontSize(16).Bold().FontColor(Colors.Blue.Medium);

                    column.Item().Table(table =>
                    {
                        table.ColumnsDefinition(columns =>
                        {
                            columns.RelativeColumn(2);
                            columns.RelativeColumn(1);
                            columns.RelativeColumn(1);
                            columns.RelativeColumn(1);
                        });

                        table.Header(header =>
                        {
                            header.Cell().Element(HeaderStyle).Text("Mjesec");
                            header.Cell().Element(HeaderStyle).AlignRight().Text("Standardni");
                            header.Cell().Element(HeaderStyle).AlignRight().Text("Premium");
                            header.Cell().Element(HeaderStyle).AlignRight().Text("Ukupno");

                            static IContainer HeaderStyle(IContainer container) =>
                                container.Background(Colors.Blue.Medium).Padding(8).DefaultTextStyle(x => x.FontColor(Colors.White).Bold());
                        });

                        foreach (var month in report.MjesecnaStatistika)
                        {
                            var total = month.BrojStandardnihKorisnika + month.BrojPremiumKorisnika;

                            table.Cell().Element(DataCellStyle).Text(month.NazivMjeseca ?? $"Mjesec {month.Mjesec}");
                            table.Cell().Element(DataCellStyle).AlignRight().Text(month.BrojStandardnihKorisnika.ToString());
                            table.Cell().Element(DataCellStyle).AlignRight().Text(month.BrojPremiumKorisnika.ToString());
                            table.Cell().Element(DataCellStyle).AlignRight().Text(total.ToString());
                        }

                        static IContainer DataCellStyle(IContainer container) =>
                            container.BorderBottom(1).BorderColor(Colors.Grey.Lighten2).Padding(8);
                    });
                }
            });
        }

        private void ComposeFooter(IContainer container)
        {
            container.Column(column =>
            {
                column.Item().LineHorizontal(1).LineColor(Colors.Grey.Lighten2);
                column.Item().PaddingTop(10).Row(row =>
                {
                    row.RelativeItem().Text("Sta Gledas? - Admin Panel")
                        .FontSize(9)
                        .FontColor(Colors.Grey.Medium);

                    row.RelativeItem().AlignRight().Text(text =>
                    {
                        text.Span("Stranica ").FontSize(9).FontColor(Colors.Grey.Medium);
                        text.CurrentPageNumber().FontSize(9);
                        text.Span(" od ").FontSize(9).FontColor(Colors.Grey.Medium);
                        text.TotalPages().FontSize(9);
                    });
                });
            });
        }
    }
}
