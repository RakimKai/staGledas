import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stagledas_admin/models/film.dart';
import 'package:stagledas_admin/providers/film_provider.dart';
import 'package:stagledas_admin/utils/util.dart';
import 'package:stagledas_admin/widgets/loading_spinner.dart';
import 'package:stagledas_admin/widgets/master_screen.dart';
import 'package:intl/intl.dart';

class FilmoviScreen extends StatefulWidget {
  const FilmoviScreen({super.key});

  @override
  State<FilmoviScreen> createState() => _FilmoviScreenState();
}

class _FilmoviScreenState extends State<FilmoviScreen> {
  late FilmProvider _filmProvider;
  List<Film> _filmovi = [];
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
    _filmProvider = context.read<FilmProvider>();
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
        filter['naslov'] = _currentSearch;
      }
      var result = await _filmProvider.get(filter: filter);
      setState(() {
        _filmovi = result.result;
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
      selectedIndex: 3,
      headerTitle: "Filmovi",
      headerDescription: "Ovdje možete pronaći listu filmova.",
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
    return Container(
      constraints: const BoxConstraints(maxWidth: 400),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: "Pretraži filmove...",
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
            DataColumn(label: Text('Datum izlaska', style: TextStyle(fontWeight: FontWeight.bold))),
            DataColumn(label: Text('Kreiranih recenzija', style: TextStyle(fontWeight: FontWeight.bold))),
            DataColumn(label: Text('Akcije', style: TextStyle(fontWeight: FontWeight.bold))),
          ],
          rows: _filmovi.map((film) {
            return DataRow(
              cells: [
                DataCell(Text(film.naslov ?? '')),
                DataCell(Text(
                  film.godinaIzdanja != null ? "${film.godinaIzdanja}" : '',
                )),
                DataCell(Text("${film.brojOcjena ?? 0}")),
                DataCell(
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, size: 20),
                        color: AppColors.primaryBlue,
                        onPressed: () => _showEditDialog(film),
                        tooltip: "Uredi",
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, size: 20),
                        color: AppColors.error,
                        onPressed: () => _confirmDelete(film),
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

  void _showEditDialog(Film film) {
    final formKey = GlobalKey<FormState>();
    final naslovController = TextEditingController(text: film.naslov ?? '');
    final opisController = TextEditingController(text: film.opis ?? '');
    final godinaController = TextEditingController(text: film.godinaIzdanja?.toString() ?? '');
    final trajanjeController = TextEditingController(text: film.trajanje?.toString() ?? '');
    final reziserController = TextEditingController(text: film.reziser ?? '');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Uredi film"),
        content: SizedBox(
          width: 500,
          child: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: naslovController,
                    decoration: const InputDecoration(
                      labelText: "Naslov",
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Naslov je obavezan';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: opisController,
                    maxLines: 4,
                    decoration: const InputDecoration(
                      labelText: "Opis",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: godinaController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: "Godina izdanja",
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value != null && value.isNotEmpty) {
                              final year = int.tryParse(value);
                              if (year == null || year < 1888 || year > 2100) {
                                return 'Unesite ispravnu godinu';
                              }
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: TextFormField(
                          controller: trajanjeController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: "Trajanje (min)",
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value != null && value.isNotEmpty) {
                              final duration = int.tryParse(value);
                              if (duration == null || duration < 1) {
                                return 'Unesite ispravno trajanje';
                              }
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: reziserController,
                    decoration: const InputDecoration(
                      labelText: "Režiser",
                      border: OutlineInputBorder(),
                    ),
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
                await _filmProvider.update(film.id!, {
                  'naslov': naslovController.text,
                  'opis': opisController.text,
                  'godinaIzdanja': int.tryParse(godinaController.text),
                  'trajanje': int.tryParse(trajanjeController.text),
                  'reziser': reziserController.text,
                });
                _loadData();
                scaffoldMessenger.showSnackBar(
                  const SnackBar(content: Text("Film uspješno ažuriran.")),
                );
              } catch (e) {
                scaffoldMessenger.showSnackBar(
                  const SnackBar(content: Text("Greška pri ažuriranju filma.")),
                );
              }
            },
            child: Text("Spremi", style: TextStyle(color: AppColors.primaryBlue)),
          ),
        ],
      ),
    );
  }

  void _confirmDelete(Film film) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Potvrda brisanja"),
        content: Text("Da li ste sigurni da želite obrisati film ${film.naslov}?"),
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
                await _filmProvider.delete(film.id!);
                _loadData();
                scaffoldMessenger.showSnackBar(
                  const SnackBar(content: Text("Film uspješno obrisan.")),
                );
              } catch (e) {
                scaffoldMessenger.showSnackBar(
                  const SnackBar(content: Text("Greška pri brisanju filma.")),
                );
              }
            },
            child: Text("Obriši", style: TextStyle(color: AppColors.error)),
          ),
        ],
      ),
    );
  }
}
