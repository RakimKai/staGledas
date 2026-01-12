import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stagledas_admin/models/reports.dart';
import 'package:stagledas_admin/providers/reports_provider.dart';
import 'package:stagledas_admin/screens/filmovi_screen.dart';
import 'package:stagledas_admin/screens/korisnici_screen.dart';
import 'package:stagledas_admin/screens/novosti_screen.dart';
import 'package:stagledas_admin/screens/zalbe_screen.dart';
import 'package:stagledas_admin/utils/util.dart';
import 'package:stagledas_admin/widgets/info_card.dart';
import 'package:stagledas_admin/widgets/loading_spinner.dart';
import 'package:stagledas_admin/widgets/master_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late ReportsProvider _reportsProvider;
  DashboardStats? _stats;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _reportsProvider = context.read<ReportsProvider>();
    _loadStats();
  }

  Future<void> _loadStats() async {
    try {
      var stats = await _reportsProvider.getDashboardStats();
      setState(() {
        _stats = stats;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreen(
      selectedIndex: 0,
      child: _isLoading
          ? const LoadingSpinner(message: "Učitavanje statistike...")
          : _buildContent(),
    );
  }

  Widget _buildContent() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Wrap(
          spacing: 24,
          runSpacing: 24,
          alignment: WrapAlignment.center,
          children: [
            SizedBox(
              width: 200,
              height: 220,
              child: InfoCard(
                title: "Korisnici:",
                value: "${_stats?.brojKorisnika ?? 0}",
                subtitle: "Pregledaj sve korisnike",
                icon: Icons.person_outline_rounded,
                onTap: () => _navigateTo(const KorisniciScreen()),
              ),
            ),
            SizedBox(
              width: 200,
              height: 220,
              child: InfoCard(
                title: "Premium Korisnici:",
                value: "${_stats?.brojPremiumKorisnika ?? 0}",
                subtitle: "Upravljaj premium korisnicima",
                icon: Icons.star_outline_rounded,
                onTap: () => _navigateTo(const KorisniciScreen()),
              ),
            ),
            SizedBox(
              width: 200,
              height: 220,
              child: InfoCard(
                title: "Filmovi:",
                value: "${_stats?.brojFilmova ?? 0}",
                subtitle: "Ažuriraj listu filmova",
                icon: Icons.tv_rounded,
                onTap: () => _navigateTo(const FilmoviScreen()),
              ),
            ),
            SizedBox(
              width: 200,
              height: 220,
              child: InfoCard(
                title: "Novosti:",
                value: "${_stats?.brojNovosti ?? 0}",
                subtitle: "Upravljaj trenutnim novostima",
                icon: Icons.newspaper_rounded,
                onTap: () => _navigateTo(const NovostiScreen()),
              ),
            ),
            SizedBox(
              width: 200,
              height: 220,
              child: InfoCard(
                title: "Flagiran sadržaj:",
                value: "${_stats?.brojFlagiranogSadrzaja ?? 0}",
                subtitle: "Provjeri prijavljene objave",
                icon: Icons.warning_amber_rounded,
                onTap: () => _navigateTo(const ZalbeScreen()),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateTo(Widget screen) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => screen),
    );
  }
}
