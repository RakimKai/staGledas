import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stagledas_admin/models/zalba.dart';
import 'package:stagledas_admin/providers/zalba_provider.dart';
import 'package:stagledas_admin/utils/util.dart';
import 'package:stagledas_admin/widgets/custom_button.dart';
import 'package:stagledas_admin/widgets/loading_spinner.dart';
import 'package:stagledas_admin/widgets/master_screen.dart';
import 'package:intl/intl.dart';

class ZalbeScreen extends StatefulWidget {
  const ZalbeScreen({super.key});

  @override
  State<ZalbeScreen> createState() => _ZalbeScreenState();
}

class _ZalbeScreenState extends State<ZalbeScreen> {
  late ZalbaProvider _zalbaProvider;
  List<Zalba> _zalbe = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _zalbaProvider = context.read<ZalbaProvider>();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    try {
      var result = await _zalbaProvider.get();
      setState(() {
        _zalbe = result.result;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreen(
      selectedIndex: 5,
      headerTitle: "Žalbe",
      headerDescription: "Ovdje možete pregledati prijavljeni sadržaj.",
      child: _isLoading
          ? const LoadingSpinner()
          : _buildContent(),
    );
  }

  Widget _buildContent() {
    if (_zalbe.isEmpty) {
      return const Center(
        child: Text("Nema prijavljenog sadržaja."),
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: SingleChildScrollView(
        child: DataTable(
          headingRowColor: WidgetStateProperty.all(AppColors.tableHeader.withOpacity(0.3)),
          columns: const [
            DataColumn(label: Text('ID', style: TextStyle(fontWeight: FontWeight.bold))),
            DataColumn(label: Text('Korisnik', style: TextStyle(fontWeight: FontWeight.bold))),
            DataColumn(label: Text('Recenzija', style: TextStyle(fontWeight: FontWeight.bold))),
            DataColumn(label: Text('Razlog', style: TextStyle(fontWeight: FontWeight.bold))),
            DataColumn(label: Text('Status', style: TextStyle(fontWeight: FontWeight.bold))),
            DataColumn(label: Text('Datum', style: TextStyle(fontWeight: FontWeight.bold))),
            DataColumn(label: Text('Akcije', style: TextStyle(fontWeight: FontWeight.bold))),
          ],
          rows: _zalbe.map((zalba) {
            final status = ZalbaStatus.fromString(zalba.status);
            return DataRow(
              cells: [
                DataCell(Text('${zalba.id}')),
                DataCell(Text(zalba.korisnik?.korisnickoIme ??
                    '${zalba.korisnik?.korisnickoIme ?? ''} ${zalba.korisnik?.prezime ?? ''}'.trim())),
                DataCell(
                  Text(
                    zalba.recenzija?.naslov ?? 'Recenzija #${zalba.recenzijaId}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                DataCell(
                  Text(
                    zalba.razlog ?? '',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                DataCell(
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: status?.boja.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      status?.naziv ?? '',
                      style: TextStyle(
                        color: status?.boja,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                DataCell(Text(
                  zalba.datumKreiranja != null
                      ? DateFormat('dd/MM/yyyy').format(zalba.datumKreiranja!)
                      : '',
                )),
                DataCell(
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (zalba.status == 'pending') ...[
                        IconButton(
                          icon: const Icon(Icons.check_circle, size: 20),
                          color: AppColors.success,
                          onPressed: () => _approveZalba(zalba),
                          tooltip: "Odobri",
                        ),
                        IconButton(
                          icon: const Icon(Icons.cancel, size: 20),
                          color: AppColors.error,
                          onPressed: () => _rejectZalba(zalba),
                          tooltip: "Odbij",
                        ),
                      ],
                      IconButton(
                        icon: const Icon(Icons.visibility, size: 20),
                        color: AppColors.primaryBlue,
                        onPressed: () => _showDetails(zalba),
                        tooltip: "Detalji",
                      ),
                    ],
                  ),
                ),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }

  Future<void> _approveZalba(Zalba zalba) async {
    try {
      await _zalbaProvider.approve(zalba.id!);
      _loadData();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Žalba odobrena."),
          backgroundColor: AppColors.success,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Greška pri odobravanju žalbe."),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  Future<void> _rejectZalba(Zalba zalba) async {
    try {
      await _zalbaProvider.reject(zalba.id!);
      _loadData();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Žalba odbijena."),
          backgroundColor: AppColors.success,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Greška pri odbijanju žalbe."),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  void _showDetails(Zalba zalba) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Žalba #${zalba.id}"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailRow("Korisnik", zalba.korisnik?.korisnickoIme ??
                '${zalba.korisnik?.ime ?? ''} ${zalba.korisnik?.prezime ?? ''}'.trim()),
            _buildDetailRow("Recenzija", zalba.recenzija?.naslov ?? ''),
            _buildDetailRow("Razlog", zalba.razlog ?? ''),
            _buildDetailRow("Status", zalba.status ?? ''),
            if (zalba.odgovor != null)
              _buildDetailRow("Odgovor", zalba.odgovor!),
            _buildDetailRow(
              "Datum kreiranja",
              zalba.datumKreiranja != null
                  ? DateFormat('dd/MM/yyyy HH:mm').format(zalba.datumKreiranja!)
                  : '',
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Zatvori"),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              "$label:",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}
