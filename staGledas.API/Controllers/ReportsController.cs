using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using staGledas.Model.DTOs.Reports;
using staGledas.Service.Interfaces;

namespace staGledas.API.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    [Authorize]
    public class ReportsController : ControllerBase
    {
        private readonly IReportsService _reportsService;
        private readonly IPdfReportService _pdfReportService;

        public ReportsController(IReportsService reportsService, IPdfReportService pdfReportService)
        {
            _reportsService = reportsService;
            _pdfReportService = pdfReportService;
        }

        [HttpGet("dashboard")]
        public DashboardStats GetDashboardStats()
        {
            return _reportsService.GetDashboardStats();
        }

        [HttpGet("analytics/{godina}")]
        public AnalyticsReport GetAnalyticsReport(int godina)
        {
            return _reportsService.GetAnalyticsReport(godina);
        }

        [HttpGet("yearly-comparison")]
        public List<YearlyReport> GetYearlyComparison([FromQuery] int? odGodine = null, [FromQuery] int? doGodine = null)
        {
            var currentYear = DateTime.Now.Year;
            var fromYear = odGodine ?? currentYear - 2;
            var toYear = doGodine ?? currentYear;
            return _reportsService.GetYearlyComparison(fromYear, toYear);
        }

        [HttpGet("top-movies")]
        public List<MovieStats> GetTopMovies([FromQuery] int count = 10)
        {
            return _reportsService.GetTopMovies(count);
        }

        [HttpGet("user-distribution")]
        public UserTypeDistribution GetUserDistribution()
        {
            return _reportsService.GetUserTypeDistribution();
        }

        [HttpGet("export-pdf/{godina}")]
        public IActionResult ExportPdf(int godina)
        {
            var report = _reportsService.GetAnalyticsReport(godina);
            var distribution = _reportsService.GetUserTypeDistribution();

            var pdfBytes = _pdfReportService.GenerateYearlyReport(godina, report, distribution);

            return File(pdfBytes, "application/pdf", $"StaGledas_Izvjestaj_{godina}.pdf");
        }
    }
}
