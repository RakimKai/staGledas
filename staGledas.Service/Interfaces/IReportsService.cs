using staGledas.Model.DTOs.Reports;

namespace staGledas.Service.Interfaces
{
    public interface IReportsService
    {
        DashboardStats GetDashboardStats();
        AnalyticsReport GetAnalyticsReport(int godina);
        List<YearlyReport> GetYearlyComparison(int odGodine, int doGodine);
        List<MovieStats> GetTopMovies(int count = 10);
        UserTypeDistribution GetUserTypeDistribution();
    }
}
