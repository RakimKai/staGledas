using staGledas.Model.DTOs.Reports;

namespace staGledas.Service.Interfaces
{
    public interface IPdfReportService
    {
        byte[] GenerateYearlyReport(int godina, AnalyticsReport report, UserTypeDistribution distribution);
    }
}
