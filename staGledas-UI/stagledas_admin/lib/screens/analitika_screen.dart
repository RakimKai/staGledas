import 'dart:html' as html;
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:stagledas_admin/models/reports.dart';
import 'package:stagledas_admin/providers/reports_provider.dart';
import 'package:stagledas_admin/utils/util.dart';
import 'package:stagledas_admin/widgets/custom_button.dart';
import 'package:stagledas_admin/widgets/loading_spinner.dart';
import 'package:stagledas_admin/widgets/master_screen.dart';

class AnalitikaScreen extends StatefulWidget {
  const AnalitikaScreen({super.key});

  @override
  State<AnalitikaScreen> createState() => _AnalitikaScreenState();
}

class _AnalitikaScreenState extends State<AnalitikaScreen> {
  late ReportsProvider _reportsProvider;
  List<YearlyReport> _yearlyComparison = [];
  AnalyticsReport? _selectedYearReport;
  UserTypeDistribution? _userDistribution;
  bool _isLoading = true;
  int _selectedYear = DateTime.now().year;
  bool _showYearlyView = false;

  @override
  void initState() {
    super.initState();
    _reportsProvider = context.read<ReportsProvider>();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    try {
      var yearlyComparison = await _reportsProvider.getYearlyComparison();
      var userDistribution = await _reportsProvider.getUserDistribution();
      setState(() {
        _yearlyComparison = yearlyComparison;
        _userDistribution = userDistribution;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _loadYearReport(int year) async {
    setState(() => _isLoading = true);
    try {
      var report = await _reportsProvider.getAnalyticsReport(year);
      setState(() {
        _selectedYearReport = report;
        _selectedYear = year;
        _showYearlyView = true;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _exportPdf() async {
    try {
      final pdfBytes = await _reportsProvider.exportPdf(_selectedYear);
      final blob = html.Blob([Uint8List.fromList(pdfBytes)], 'application/pdf');
      final url = html.Url.createObjectUrlFromBlob(blob);
      final anchor = html.AnchorElement(href: url)
        ..setAttribute('download', 'StaGledas_Izvjestaj_$_selectedYear.pdf')
        ..click();
      html.Url.revokeObjectUrl(url);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Greška pri exportu PDF-a: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreen(
      selectedIndex: 1,
      headerTitle: "Analitika",
      headerDescription: "Ovdje možete pronaći analitiku i izvještaj.",
      child: _isLoading
          ? const LoadingSpinner()
          : _showYearlyView
              ? _buildYearlyView()
              : _buildComparisonView(),
    );
  }

  Widget _buildComparisonView() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildComparisonTable(),
          const SizedBox(height: 40),
          _buildPieChart(),
        ],
      ),
    );
  }

  Widget _buildComparisonTable() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          headingRowColor: WidgetStateProperty.all(AppColors.tableHeader.withOpacity(0.3)),
          columns: [
            const DataColumn(label: Text('')),
            ..._yearlyComparison.map((r) => DataColumn(
                  label: Text(
                    '${r.godina}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                )),
          ],
          rows: [
            _buildComparisonRow('Broj korisnika', _yearlyComparison.map((r) => '${r.brojKorisnika}').toList()),
            _buildComparisonRow('Broj premium korisnika', _yearlyComparison.map((r) => '${r.brojPremiumKorisnika}').toList()),
            _buildComparisonRow('Broj kreiranih recenzija', _yearlyComparison.map((r) => '${r.brojKreiranihRecenzija}').toList()),
            _buildComparisonRow('Ukupni prihodi platforme', _yearlyComparison.map((r) => '${r.ukupniPrihodi?.toStringAsFixed(2)} KM').toList()),
          ],
        ),
      ),
    );
  }

  DataRow _buildComparisonRow(String label, List<String> values) {
    return DataRow(
      cells: [
        DataCell(Text(label, style: const TextStyle(fontWeight: FontWeight.w500))),
        ...values.map((v) => DataCell(Text(v))),
      ],
    );
  }

  Widget _buildPieChart() {
    if (_userDistribution == null) return const SizedBox();

    return Row(
      children: [
        SizedBox(
          width: 200,
          height: 200,
          child: PieChart(
            PieChartData(
              sections: [
                PieChartSectionData(
                  value: _userDistribution!.premiumKorisnici?.toDouble() ?? 0,
                  color: AppColors.chartBlue,
                  title: '',
                  radius: 80,
                ),
                PieChartSectionData(
                  value: _userDistribution!.standardniKorisnici?.toDouble() ?? 0,
                  color: AppColors.chartTeal,
                  title: '',
                  radius: 80,
                ),
              ],
              sectionsSpace: 2,
            ),
          ),
        ),
        const SizedBox(width: 20),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(width: 16, height: 16, color: AppColors.chartBlue),
                const SizedBox(width: 8),
                const Text("Premium Korisnik"),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Container(width: 16, height: 16, color: AppColors.chartTeal),
                const SizedBox(width: 8),
                const Text("Korisnik"),
              ],
            ),
          ],
        ),
        const Spacer(),
        CustomButton(
          buttonText: "Detaljni izvještaj",
          onPress: () => _loadYearReport(DateTime.now().year),
        ),
      ],
    );
  }

  Widget _buildYearlyView() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => setState(() => _showYearlyView = false),
              ),
              const SizedBox(width: 8),
              DropdownButton<int>(
                value: _selectedYear,
                items: List.generate(5, (i) => DateTime.now().year - i)
                    .map((year) => DropdownMenuItem(
                          value: year,
                          child: Text("Izaberi godinu: $year"),
                        ))
                    .toList(),
                onChanged: (year) {
                  if (year != null) _loadYearReport(year);
                },
              ),
              const Spacer(),
              CustomButton(
                buttonText: "Printaj",
                icon: Icons.print,
                onPress: _exportPdf,
              ),
            ],
          ),
          const SizedBox(height: 20),
          _buildYearlyTable(),
          const SizedBox(height: 40),
          const Text(
            "Mjesečni prikaz novih premium i standardnih korisnika",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 20),
          _buildBarChart(),
        ],
      ),
    );
  }

  Widget _buildYearlyTable() {
    if (_selectedYearReport == null) return const SizedBox();

    final report = _selectedYearReport!;
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: DataTable(
        headingRowColor: WidgetStateProperty.all(AppColors.tableHeader.withOpacity(0.3)),
        columns: [
          const DataColumn(label: Text('')),
          DataColumn(
            label: Text(
              '${report.godina}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
        rows: [
          DataRow(cells: [
            const DataCell(Text('Broj korisnika')),
            DataCell(Text('${report.brojKorisnika}')),
          ]),
          DataRow(cells: [
            const DataCell(Text('Broj premium korisnika')),
            DataCell(Text('${report.brojPremiumKorisnika}')),
          ]),
          DataRow(cells: [
            const DataCell(Text('Postotak premium korisnika')),
            DataCell(Text('${report.postotakPremiumKorisnika?.toStringAsFixed(1)}%')),
          ]),
          DataRow(cells: [
            const DataCell(Text('Ukupni prihodi platforme')),
            DataCell(Text('${report.ukupniPrihodi?.toStringAsFixed(2)}')),
          ]),
          DataRow(cells: [
            const DataCell(Text('Broj obrisanih računa')),
            DataCell(Text('${report.brojObrisanihRacuna}')),
          ]),
          DataRow(cells: [
            const DataCell(Text('Rast u odnosu na prethodnu godinu')),
            DataCell(Text('${report.rastUOdnosuNaProslodisnjuGodinu?.toStringAsFixed(1)}%')),
          ]),
          DataRow(cells: [
            const DataCell(Text('Broj kreiranih recenzija')),
            DataCell(Text('${report.brojKreiranihRecenzija}')),
          ]),
          DataRow(cells: [
            const DataCell(Text('Broj administratora')),
            DataCell(Text('${report.brojAdministratora}')),
          ]),
        ],
      ),
    );
  }

  Widget _buildBarChart() {
    if (_selectedYearReport?.mjesecnaStatistika == null ||
        _selectedYearReport!.mjesecnaStatistika!.isEmpty) {
      return const Center(child: Text("Nema podataka za prikaz"));
    }

    final data = _selectedYearReport!.mjesecnaStatistika!;

    return SizedBox(
      height: 300,
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          maxY: data
              .map((e) => (e.brojStandardnihKorisnika ?? 0) + (e.brojPremiumKorisnika ?? 0))
              .reduce((a, b) => a > b ? a : b)
              .toDouble() * 1.2,
          barGroups: data.asMap().entries.map((entry) {
            return BarChartGroupData(
              x: entry.key,
              barRods: [
                BarChartRodData(
                  toY: entry.value.brojStandardnihKorisnika?.toDouble() ?? 0,
                  color: AppColors.chartPurple,
                  width: 12,
                ),
                BarChartRodData(
                  toY: entry.value.brojPremiumKorisnika?.toDouble() ?? 0,
                  color: AppColors.chartTeal,
                  width: 12,
                ),
              ],
            );
          }).toList(),
          titlesData: FlTitlesData(
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  if (value.toInt() < data.length) {
                    return Text(
                      data[value.toInt()].nazivMjeseca?.substring(0, 3) ?? '',
                      style: const TextStyle(fontSize: 10),
                    );
                  }
                  return const Text('');
                },
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: true, reservedSize: 40),
            ),
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          borderData: FlBorderData(show: false),
          gridData: FlGridData(show: true),
        ),
      ),
    );
  }
}
