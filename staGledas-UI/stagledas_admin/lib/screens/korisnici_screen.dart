import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stagledas_admin/models/korisnik.dart';
import 'package:stagledas_admin/providers/korisnik_provider.dart';
import 'package:stagledas_admin/utils/util.dart';
import 'package:stagledas_admin/widgets/custom_button.dart';
import 'package:stagledas_admin/widgets/loading_spinner.dart';
import 'package:stagledas_admin/widgets/master_screen.dart';
import 'package:intl/intl.dart';

class KorisniciScreen extends StatefulWidget {
  const KorisniciScreen({super.key});

  @override
  State<KorisniciScreen> createState() => _KorisniciScreenState();
}

class _KorisniciScreenState extends State<KorisniciScreen> {
  late KorisnikProvider _korisnikProvider;
  List<Korisnik> _korisnici = [];
  bool _isLoading = true;
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;

  int _currentPage = 1;
  int _totalCount = 0;
  static const int _pageSize = 10;
  String? _currentSearch;

  int get _totalPages => (_totalCount / _pageSize).ceil();

  @override
  void initState() {
    super.initState();
    _korisnikProvider = context.read<KorisnikProvider>();
    _loadData();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), () {
      _currentPage = 1;
      _currentSearch = value.isEmpty ? null : value;
      _loadData();
    });
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    try {
      var filter = <String, dynamic>{
        'Page': _currentPage,
        'PageSize': _pageSize,
      };
      if (_currentSearch != null && _currentSearch!.isNotEmpty) {
        filter['ime'] = _currentSearch;
      }
      var result = await _korisnikProvider.get(filter: filter);
      setState(() {
        _korisnici = result.result;
        _totalCount = result.count;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  void _goToPage(int page) {
    if (page < 1 || page > _totalPages) return;
    _currentPage = page;
    _loadData();
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreen(
      selectedIndex: 2,
      headerTitle: "Korisnici",
      headerDescription: "Ovdje možete pronaći listu korisnika.",
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSearchBar(),
          const SizedBox(height: 20),
          Expanded(
            child: _isLoading
                ? const LoadingSpinner()
                : _buildTable(),
          ),
          if (!_isLoading && _totalPages > 0) _buildPagination(),
        ],
      ),
    );
  }

  Widget _buildPagination() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            onPressed: _currentPage > 1 ? () => _goToPage(1) : null,
            icon: const Icon(Icons.first_page),
            tooltip: "Prva stranica",
          ),
          IconButton(
            onPressed: _currentPage > 1 ? () => _goToPage(_currentPage - 1) : null,
            icon: const Icon(Icons.chevron_left),
            tooltip: "Prethodna",
          ),
          const SizedBox(width: 16),
          Text(
            "Stranica $_currentPage od $_totalPages",
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 14,
            ),
          ),
          const SizedBox(width: 16),
          IconButton(
            onPressed: _currentPage < _totalPages ? () => _goToPage(_currentPage + 1) : null,
            icon: const Icon(Icons.chevron_right),
            tooltip: "Sljedeća",
          ),
          IconButton(
            onPressed: _currentPage < _totalPages ? () => _goToPage(_totalPages) : null,
            icon: const Icon(Icons.last_page),
            tooltip: "Zadnja stranica",
          ),
          const SizedBox(width: 24),
          Text(
            "Ukupno: $_totalCount",
            style: const TextStyle(
              color: Color(0xFF718096),
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Row(
      children: [
        Container(
          constraints: const BoxConstraints(maxWidth: 400),
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: "Pretraži korisnika...",
              prefixIcon: const Icon(Icons.search),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
            ),
            onChanged: _onSearchChanged,
          ),
        ),
        const Spacer(),
        CustomButton(
          buttonText: "Kreiraj administratora",
          icon: Icons.admin_panel_settings,
          onPress: _showCreateAdminDialog,
        ),
      ],
    );
  }

  Widget _buildTable() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: SingleChildScrollView(
        child: DataTable(
          headingRowColor: WidgetStateProperty.all(AppColors.tableHeader.withOpacity(0.3)),
          columns: const [
            DataColumn(label: Text('Ime', style: TextStyle(fontWeight: FontWeight.bold))),
            DataColumn(label: Text('Prezime', style: TextStyle(fontWeight: FontWeight.bold))),
            DataColumn(label: Text('Email', style: TextStyle(fontWeight: FontWeight.bold))),
            DataColumn(label: Text('Datum pridruživanja', style: TextStyle(fontWeight: FontWeight.bold))),
            DataColumn(label: Text('Premium', style: TextStyle(fontWeight: FontWeight.bold))),
            DataColumn(label: Text('Akcije', style: TextStyle(fontWeight: FontWeight.bold))),
          ],
          rows: _korisnici.map((korisnik) {
            return DataRow(
              cells: [
                DataCell(Text(korisnik.ime ?? '')),
                DataCell(Text(korisnik.prezime ?? '')),
                DataCell(Text(korisnik.email ?? '')),
                DataCell(Text(
                  korisnik.datumKreiranja != null
                      ? DateFormat('dd/MM/yyyy').format(korisnik.datumKreiranja!)
                      : '',
                )),
                DataCell(
                  korisnik.isPremium == true
                      ? const Icon(Icons.check_circle, color: AppColors.success)
                      : const Icon(Icons.cancel, color: AppColors.error),
                ),
                DataCell(
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, size: 20),
                        color: AppColors.primaryBlue,
                        onPressed: () => _showEditDialog(korisnik),
                        tooltip: "Uredi",
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, size: 20),
                        color: AppColors.error,
                        onPressed: () => _confirmDelete(korisnik),
                        tooltip: "Obriši",
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

  void _showEditDialog(Korisnik korisnik) {
    final formKey = GlobalKey<FormState>();
    final imeController = TextEditingController(text: korisnik.ime ?? '');
    final prezimeController = TextEditingController(text: korisnik.prezime ?? '');
    final emailController = TextEditingController(text: korisnik.email ?? '');
    final telefonController = TextEditingController(text: korisnik.telefon ?? '');
    bool isPremium = korisnik.isPremium ?? false;
    bool status = korisnik.status ?? true;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text("Uredi korisnika"),
          content: SizedBox(
            width: 400,
            child: Form(
              key: formKey,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      controller: imeController,
                      decoration: const InputDecoration(
                        labelText: "Ime",
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Ime je obavezno';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: prezimeController,
                      decoration: const InputDecoration(
                        labelText: "Prezime",
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Prezime je obavezno';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: emailController,
                      decoration: const InputDecoration(
                        labelText: "Email",
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Email je obavezan';
                        }
                        if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                          return 'Unesite ispravan email';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: telefonController,
                      decoration: const InputDecoration(
                        labelText: "Telefon",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    SwitchListTile(
                      title: const Text("Premium korisnik"),
                      value: isPremium,
                      onChanged: (value) => setDialogState(() => isPremium = value),
                      activeColor: AppColors.primaryBlue,
                    ),
                    SwitchListTile(
                      title: const Text("Aktivan"),
                      value: status,
                      onChanged: (value) => setDialogState(() => status = value),
                      activeColor: AppColors.success,
                    ),
                  ],
                ),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Odustani"),
            ),
            TextButton(
              onPressed: () async {
                if (!formKey.currentState!.validate()) return;
                final scaffoldMessenger = ScaffoldMessenger.of(context);
                Navigator.pop(context);
                try {
                  await _korisnikProvider.update(korisnik.id!, {
                    'ime': imeController.text,
                    'prezime': prezimeController.text,
                    'email': emailController.text,
                    'telefon': telefonController.text,
                    'isPremium': isPremium,
                    'status': status,
                  });
                  _loadData();
                  scaffoldMessenger.showSnackBar(
                    const SnackBar(content: Text("Korisnik uspješno ažuriran.")),
                  );
                } catch (e) {
                  scaffoldMessenger.showSnackBar(
                    const SnackBar(content: Text("Greška pri ažuriranju korisnika.")),
                  );
                }
              },
              child: Text("Spremi", style: TextStyle(color: AppColors.primaryBlue)),
            ),
          ],
        ),
      ),
    );
  }

  void _confirmDelete(Korisnik korisnik) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Potvrda brisanja"),
        content: Text("Da li ste sigurni da želite obrisati korisnika ${korisnik.ime} ${korisnik.prezime}?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Odustani"),
          ),
          TextButton(
            onPressed: () async {
              final scaffoldMessenger = ScaffoldMessenger.of(context);
              Navigator.pop(context);
              try {
                await _korisnikProvider.delete(korisnik.id!);
                _loadData();
                scaffoldMessenger.showSnackBar(
                  const SnackBar(content: Text("Korisnik uspješno obrisan.")),
                );
              } catch (e) {
                scaffoldMessenger.showSnackBar(
                  const SnackBar(content: Text("Greška pri brisanju korisnika.")),
                );
              }
            },
            child: Text("Obriši", style: TextStyle(color: AppColors.error)),
          ),
        ],
      ),
    );
  }

  void _showCreateAdminDialog() {
    final formKey = GlobalKey<FormState>();
    final imeController = TextEditingController();
    final prezimeController = TextEditingController();
    final emailController = TextEditingController();
    final korisnickoImeController = TextEditingController();
    final lozinkaController = TextEditingController();
    final lozinkaPotvrdaController = TextEditingController();
    String? errorMessage;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text("Kreiraj administratora"),
          content: SizedBox(
            width: 400,
            child: Form(
              key: formKey,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (errorMessage != null)
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        margin: const EdgeInsets.only(bottom: 16),
                        decoration: BoxDecoration(
                          color: Colors.red.shade50,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.red.shade200),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.error_outline, color: Colors.red.shade700, size: 20),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                errorMessage!,
                                style: TextStyle(color: Colors.red.shade700),
                              ),
                            ),
                          ],
                        ),
                      ),
                    TextFormField(
                      controller: imeController,
                      decoration: const InputDecoration(
                        labelText: "Ime",
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Ime je obavezno';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: prezimeController,
                      decoration: const InputDecoration(
                        labelText: "Prezime",
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Prezime je obavezno';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: emailController,
                      decoration: const InputDecoration(
                        labelText: "Email",
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Email je obavezan';
                        }
                        if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                          return 'Unesite ispravan email';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: korisnickoImeController,
                      decoration: const InputDecoration(
                        labelText: "Korisničko ime",
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Korisničko ime je obavezno';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: lozinkaController,
                      obscureText: true,
                      decoration: const InputDecoration(
                        labelText: "Lozinka",
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Lozinka je obavezna';
                        }
                        if (value.length < 4) {
                          return 'Lozinka mora imati najmanje 4 karaktera';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: lozinkaPotvrdaController,
                      obscureText: true,
                      decoration: const InputDecoration(
                        labelText: "Potvrda lozinke",
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Potvrda lozinke je obavezna';
                        }
                        if (value != lozinkaController.text) {
                          return 'Lozinke se ne podudaraju';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Odustani"),
            ),
            TextButton(
              onPressed: () async {
                if (!formKey.currentState!.validate()) return;

                setDialogState(() => errorMessage = null);

                try {
                  await _korisnikProvider.insert({
                    'ime': imeController.text,
                    'prezime': prezimeController.text,
                    'email': emailController.text,
                    'korisnickoIme': korisnickoImeController.text,
                    'lozinka': lozinkaController.text,
                    'lozinkaPotvrda': lozinkaPotvrdaController.text,
                    'ulogaId': 1,
                  });

                  if (context.mounted) {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Administrator uspješno kreiran.")),
                    );
                  }
                  _loadData();
                } catch (e) {
                  setDialogState(() {
                    errorMessage = e.toString().replaceAll('Exception: ', '');
                  });
                }
              },
              child: Text("Kreiraj", style: TextStyle(color: AppColors.primaryBlue)),
            ),
          ],
        ),
      ),
    );
  }
}
