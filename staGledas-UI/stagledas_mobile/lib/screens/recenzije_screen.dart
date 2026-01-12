import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stagledas_mobile/layouts/master_layout.dart';
import 'package:stagledas_mobile/models/film.dart';
import 'package:stagledas_mobile/models/recenzija.dart';
import 'package:stagledas_mobile/providers/film_provider.dart';
import 'package:stagledas_mobile/providers/recenzija_provider.dart';
import 'package:stagledas_mobile/providers/tmdb_provider.dart';
import 'package:stagledas_mobile/models/tmdb_movie.dart';
import 'package:stagledas_mobile/widgets/loading_spinner_widget.dart';
import 'package:stagledas_mobile/screens/other_user_profile_screen.dart';
import 'package:stagledas_mobile/utils/auth_util.dart';
import 'package:stagledas_mobile/providers/zalba_provider.dart';

class RecenzijeScreen extends StatefulWidget {
  const RecenzijeScreen({super.key});

  @override
  State<RecenzijeScreen> createState() => _RecenzijeScreenState();
}

class _RecenzijeScreenState extends State<RecenzijeScreen> {
  late RecenzijaProvider _recenzijaProvider;
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  bool _isLoading = true;
  bool _isLoadingMore = false;
  bool _hasMore = true;
  int _currentPage = 1;
  static const int _pageSize = 15;
  List<Recenzija> _recenzije = [];
  String? _currentQuery;

  @override
  void initState() {
    super.initState();
    _recenzijaProvider = context.read<RecenzijaProvider>();
    _scrollController.addListener(_onScroll);
    _loadRecenzije();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
      if (!_isLoadingMore && _hasMore) {
        _loadMore();
      }
    }
  }

  Future<void> _loadRecenzije({String? query, bool reset = true}) async {
    if (reset) {
      setState(() {
        _isLoading = true;
        _currentPage = 1;
        _hasMore = true;
        _recenzije = [];
        _currentQuery = query;
      });
    }

    try {
      var filter = {
        'Page': _currentPage,
        'PageSize': _pageSize,
        'OrderBy': 'DatumKreiranja desc',
        'IsFilmIncluded': true,
        'IsKorisnikIncluded': true,
      };

      if (_currentQuery != null && _currentQuery!.isNotEmpty) {
        filter['SearchText'] = _currentQuery!;
      }

      var result = await _recenzijaProvider.get(filter: filter);
      setState(() {
        _recenzije = result.result;
        _hasMore = result.result.length >= _pageSize;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _loadMore() async {
    if (_isLoadingMore || !_hasMore) return;

    setState(() => _isLoadingMore = true);
    _currentPage++;

    try {
      var filter = {
        'Page': _currentPage,
        'PageSize': _pageSize,
        'OrderBy': 'DatumKreiranja desc',
        'IsFilmIncluded': true,
        'IsKorisnikIncluded': true,
      };

      if (_currentQuery != null && _currentQuery!.isNotEmpty) {
        filter['SearchText'] = _currentQuery!;
      }

      var result = await _recenzijaProvider.get(filter: filter);
      setState(() {
        _recenzije.addAll(result.result);
        _hasMore = result.result.length >= _pageSize;
        _isLoadingMore = false;
      });
    } catch (e) {
      setState(() {
        _isLoadingMore = false;
        _currentPage--;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MasterLayout(
      selectedIndex: 1,
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: Text(
                  "Recenzije",
                  style: TextStyle(
                    fontFamily: "Inter",
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2D3748),
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: TextField(
                  controller: _searchController,
                  onChanged: (value) {
                    if (value.length >= 2) {
                      _loadRecenzije(query: value);
                    } else if (value.isEmpty) {
                      _loadRecenzije();
                    }
                  },
                  style: const TextStyle(color: Color(0xFF2D3748)),
                  decoration: InputDecoration(
                    hintText: "Pretražiti recenzije...",
                    hintStyle: const TextStyle(color: Color(0xFF718096), fontSize: 14),
                    prefixIcon: const Icon(Icons.search, color: Color(0xFF718096)),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Color(0xFF4AB3EF)),
                    ),
                    contentPadding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
              ),

              const Padding(
                padding: EdgeInsets.fromLTRB(16, 8, 16, 12),
                child: Text(
                  "Popularno ove sedmice:",
                  style: TextStyle(
                    fontFamily: "Inter",
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF718096),
                  ),
                ),
              ),

              Expanded(
                child: _isLoading
                    ? const LoadingSpinnerWidget(height: 200)
                    : _recenzije.isEmpty
                        ? const Center(
                            child: Text(
                              "Nema dostupnih recenzija",
                              style: TextStyle(color: Color(0xFF718096)),
                            ),
                          )
                        : ListView.builder(
                            controller: _scrollController,
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            itemCount: _recenzije.length + (_isLoadingMore ? 1 : 0),
                            itemBuilder: (context, index) {
                              if (index == _recenzije.length) {
                                return const Padding(
                                  padding: EdgeInsets.all(16),
                                  child: Center(
                                    child: CircularProgressIndicator(
                                      color: Color(0xFF4AB3EF),
                                    ),
                                  ),
                                );
                              }
                              return GestureDetector(
                                onTap: () => _showRecenzijaDetails(_recenzije[index]),
                                child: _buildRecenzijaCard(_recenzije[index]),
                              );
                            },
                          ),
              ),
            ],
          ),
          Positioned(
            right: 16,
            bottom: 16,
            child: FloatingActionButton(
              onPressed: () => _showCreateRecenzijaDialog(),
              backgroundColor: const Color(0xFF4AB3EF),
              child: const Icon(Icons.add, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecenzijaCard(Recenzija recenzija) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: recenzija.filmPosterPath != null
                ? CachedNetworkImage(
                    imageUrl:
                        'https://image.tmdb.org/t/p/w185${recenzija.filmPosterPath}',
                    width: 80,
                    height: 120,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      width: 80,
                      height: 120,
                      color: const Color(0xFFE2E8F0),
                      child: const Center(
                        child: CircularProgressIndicator(
                          color: Color(0xFF4AB3EF),
                          strokeWidth: 2,
                        ),
                      ),
                    ),
                    errorWidget: (context, url, error) => Container(
                      width: 80,
                      height: 120,
                      color: const Color(0xFFE2E8F0),
                      child: const Icon(Icons.movie, color: Color(0xFF718096)),
                    ),
                  )
                : Container(
                    width: 80,
                    height: 120,
                    color: const Color(0xFFE2E8F0),
                    child: const Icon(Icons.movie, color: Color(0xFF718096)),
                  ),
          ),
          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    GestureDetector(
                      onTap: () => _navigateToProfile(recenzija),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 10,
                            backgroundColor: const Color(0xFF4AB3EF),
                            backgroundImage: recenzija.korisnikSlika != null
                                ? MemoryImage(base64Decode(recenzija.korisnikSlika!))
                                : null,
                            child: recenzija.korisnikSlika == null
                                ? Text(
                                    recenzija.displayName[0].toUpperCase(),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 10,
                                    ),
                                  )
                                : null,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            recenzija.displayName,
                            style: const TextStyle(
                              fontFamily: "Inter",
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF4AB3EF),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    SizedBox(
                      width: 24,
                      height: 24,
                      child: PopupMenuButton<String>(
                        icon: const Icon(
                          Icons.more_vert,
                          color: Color(0xFF718096),
                          size: 18,
                        ),
                        padding: EdgeInsets.zero,
                        onSelected: (value) {
                          if (value == 'report') {
                            _showReportDialog(recenzija);
                          } else if (value == 'edit') {
                            _showEditRecenzijaDialog(recenzija);
                          }
                        },
                        itemBuilder: (context) => [
                          if (recenzija.korisnikId == Authorization.id)
                            const PopupMenuItem(
                              value: 'edit',
                              child: Row(
                                children: [
                                  Icon(Icons.edit_outlined, size: 18, color: Color(0xFF718096)),
                                  SizedBox(width: 8),
                                  Text('Uredi'),
                                ],
                              ),
                            ),
                          if (recenzija.korisnikId != Authorization.id)
                            const PopupMenuItem(
                              value: 'report',
                              child: Row(
                                children: [
                                  Icon(Icons.flag_outlined, size: 18, color: Color(0xFF718096)),
                                  SizedBox(width: 8),
                                  Text('Prijavi'),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),

                if (recenzija.filmNaslov != null && recenzija.filmNaslov!.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Text(
                      recenzija.filmNaslov!,
                      style: const TextStyle(
                        fontFamily: "Inter",
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF4AB3EF),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),

                Row(
                  children: List.generate(5, (index) {
                    final rating = recenzija.ocjena ?? 0;
                    IconData icon;
                    if (index < rating.floor()) {
                      icon = Icons.star;
                    } else if (index < rating && rating - index >= 0.5) {
                      icon = Icons.star_half;
                    } else {
                      icon = Icons.star_border;
                    }
                    return Icon(
                      icon,
                      size: 16,
                      color: const Color(0xFF99D6AC),
                    );
                  }),
                ),
                const SizedBox(height: 6),

                if (recenzija.imaSpoiler == true)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 24,
                        height: 24,
                        decoration: const BoxDecoration(
                          color: Color(0xFFFFD60A),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.visibility_off,
                          size: 14,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        "Sadrži spojlere",
                        style: TextStyle(
                          fontFamily: "Inter",
                          fontSize: 12,
                          color: Color(0xFF718096),
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  )
                else
                  Text(
                    (recenzija.sadrzaj ?? '').length > 50
                        ? '${(recenzija.sadrzaj ?? '').substring(0, 50)}...'
                        : recenzija.sadrzaj ?? '',
                    style: const TextStyle(
                      fontFamily: "Inter",
                      fontSize: 12,
                      color: Color(0xFF718096),
                      height: 1.4,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _navigateToProfile(Recenzija recenzija) {
    if (recenzija.korisnikId == null) return;

    if (recenzija.korisnikId == Authorization.id) {
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => OtherUserProfileScreen(
          userId: recenzija.korisnikId!,
          username: recenzija.username,
          userImage: recenzija.korisnikSlika,
        ),
      ),
    );
  }

  void _showReportDialog(Recenzija recenzija) {
    String? selectedReason;
    final opisController = TextEditingController();
    final reasons = [
      'Neprimjeren sadržaj',
      'Spoiler bez upozorenja',
      'Govor mržnje',
      'Lažne informacije',
      'Spam',
      'Ostalo',
    ];

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          backgroundColor: Colors.white,
          title: const Text(
            'Prijavi recenziju',
            style: TextStyle(color: Color(0xFF2D3748)),
          ),
          content: SizedBox(
            width: 300,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Razlog prijave:',
                  style: TextStyle(fontWeight: FontWeight.w500, color: Color(0xFF2D3748)),
                ),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  value: selectedReason,
                  hint: const Text('Odaberi razlog'),
                  isExpanded: true,
                  dropdownColor: Colors.white,
                  style: const TextStyle(color: Color(0xFF2D3748)),
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                  items: reasons.map((reason) => DropdownMenuItem(
                    value: reason,
                    child: Text(reason, style: const TextStyle(color: Color(0xFF2D3748))),
                  )).toList(),
                  onChanged: (value) {
                    setDialogState(() {
                      selectedReason = value;
                    });
                  },
                ),
                const SizedBox(height: 16),
                const Text(
                  'Dodatni opis (opcionalno):',
                  style: TextStyle(fontWeight: FontWeight.w500, color: Color(0xFF2D3748)),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: opisController,
                  maxLines: 3,
                  style: const TextStyle(color: Color(0xFF2D3748)),
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Opišite problem...',
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Odustani', style: TextStyle(color: Color(0xFF718096))),
            ),
            TextButton(
              onPressed: selectedReason == null ? null : () async {
                final scaffoldMessenger = ScaffoldMessenger.of(context);
                final zalbaProvider = Provider.of<ZalbaProvider>(context, listen: false);
                Navigator.pop(context);
                try {
                  await zalbaProvider.insert({
                    'recenzijaId': recenzija.id,
                    'razlog': selectedReason,
                    'opis': opisController.text.isNotEmpty ? opisController.text : null,
                  });
                  scaffoldMessenger.showSnackBar(
                    const SnackBar(
                      content: Text('Recenzija uspješno prijavljena'),
                      backgroundColor: Color(0xFF99D6AC),
                    ),
                  );
                } catch (e) {
                  scaffoldMessenger.showSnackBar(
                    SnackBar(
                      content: Text(e.toString().replaceAll('Exception: ', '')),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              child: Text(
                'Prijavi',
                style: TextStyle(
                  color: selectedReason == null ? Colors.grey : Colors.red,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showRecenzijaDetails(Recenzija recenzija) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Container(
          constraints: const BoxConstraints(maxWidth: 400, maxHeight: 600),
          padding: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        recenzija.filmNaslov ?? 'Recenzija',
                        style: const TextStyle(
                          fontFamily: "Inter",
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2D3748),
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: Color(0xFF718096)),
                      onPressed: () => Navigator.pop(context),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                Row(
                  children: [
                    CircleAvatar(
                      radius: 16,
                      backgroundColor: const Color(0xFF4AB3EF),
                      backgroundImage: recenzija.korisnikSlika != null
                          ? MemoryImage(base64Decode(recenzija.korisnikSlika!))
                          : null,
                      child: recenzija.korisnikSlika == null
                          ? Text(
                              recenzija.displayName[0].toUpperCase(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            )
                          : null,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            recenzija.displayName,
                            style: const TextStyle(
                              fontFamily: "Inter",
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF2D3748),
                            ),
                          ),
                          if (recenzija.datumKreiranja != null)
                            Text(
                              '${recenzija.datumKreiranja!.day}.${recenzija.datumKreiranja!.month}.${recenzija.datumKreiranja!.year}',
                              style: const TextStyle(
                                fontFamily: "Inter",
                                fontSize: 12,
                                color: Color(0xFF718096),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                Row(
                  children: List.generate(5, (index) {
                    final rating = recenzija.ocjena ?? 0;
                    IconData icon;
                    if (index < rating.floor()) {
                      icon = Icons.star;
                    } else if (index < rating && rating - index >= 0.5) {
                      icon = Icons.star_half;
                    } else {
                      icon = Icons.star_border;
                    }
                    return Icon(
                      icon,
                      size: 24,
                      color: const Color(0xFF99D6AC),
                    );
                  }),
                ),
                const SizedBox(height: 16),

                Text(
                  recenzija.sadrzaj ?? 'Nema sadržaja',
                  style: const TextStyle(
                    fontFamily: "Inter",
                    fontSize: 14,
                    color: Color(0xFF4A5568),
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showCreateRecenzijaDialog() {
    final tmdbProvider = TmdbProvider();
    final TextEditingController filmSearchController = TextEditingController();
    final TextEditingController sadrzajController = TextEditingController();

    Film? selectedFilm;
    double rating = 3.0;
    bool imaSpoiler = false;
    List<TmdbMovie> searchResults = [];
    bool isSearching = false;
    bool isImporting = false;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => Dialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 400, maxHeight: 600),
            padding: const EdgeInsets.all(20),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Nova recenzija',
                        style: TextStyle(
                          fontFamily: "Inter",
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2D3748),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, color: Color(0xFF718096)),
                        onPressed: () => Navigator.pop(context),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  const Text(
                    'Film',
                    style: TextStyle(
                      fontFamily: "Inter",
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF2D3748),
                    ),
                  ),
                  const SizedBox(height: 8),

                  if (selectedFilm == null) ...[
                    TextField(
                      controller: filmSearchController,
                      style: const TextStyle(color: Color(0xFF2D3748)),
                      decoration: InputDecoration(
                        hintText: "Pretraži filmove...",
                        hintStyle: const TextStyle(color: Color(0xFF718096), fontSize: 14),
                        prefixIcon: const Icon(Icons.search, color: Color(0xFF718096)),
                        suffixIcon: isSearching
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: Padding(
                                  padding: EdgeInsets.all(12),
                                  child: CircularProgressIndicator(strokeWidth: 2),
                                ),
                              )
                            : null,
                        filled: true,
                        fillColor: const Color(0xFFF7FAFC),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      onChanged: (value) async {
                        if (value.length >= 2) {
                          setDialogState(() => isSearching = true);
                          try {
                            final results = await tmdbProvider.searchMovies(value);
                            setDialogState(() {
                              searchResults = results.take(5).toList();
                              isSearching = false;
                            });
                          } catch (e) {
                            setDialogState(() => isSearching = false);
                          }
                        } else {
                          setDialogState(() => searchResults = []);
                        }
                      },
                    ),
                    if (searchResults.isNotEmpty && !isImporting)
                      Container(
                        margin: const EdgeInsets.only(top: 8),
                        constraints: const BoxConstraints(maxHeight: 150),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF7FAFC),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: searchResults.length,
                          itemBuilder: (context, index) {
                            final tmdbMovie = searchResults[index];
                            return ListTile(
                              dense: true,
                              leading: tmdbMovie.posterPath != null
                                  ? ClipRRect(
                                      borderRadius: BorderRadius.circular(4),
                                      child: CachedNetworkImage(
                                        imageUrl: tmdbMovie.posterUrl,
                                        width: 30,
                                        height: 45,
                                        fit: BoxFit.cover,
                                      ),
                                    )
                                  : const Icon(Icons.movie),
                              title: Text(
                                tmdbMovie.title ?? '',
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: Color(0xFF2D3748),
                                ),
                              ),
                              subtitle: Text(
                                '${tmdbMovie.year ?? ''}',
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: Color(0xFF2D3748),
                                ),
                              ),
                              onTap: () async {
                                if (tmdbMovie.id == null) return;
                                setDialogState(() {
                                  isImporting = true;
                                  searchResults = [];
                                });
                                try {
                                  final importedFilm = await tmdbProvider.getOrImportMovie(tmdbMovie.id!);
                                  setDialogState(() {
                                    selectedFilm = importedFilm;
                                    isImporting = false;
                                    filmSearchController.clear();
                                  });
                                } catch (e) {
                                  setDialogState(() => isImporting = false);
                                }
                              },
                            );
                          },
                        ),
                      ),
                    if (isImporting)
                      Container(
                        margin: const EdgeInsets.only(top: 8),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF7FAFC),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                            SizedBox(width: 12),
                            Text(
                              'Učitavanje filma...',
                              style: TextStyle(
                                fontSize: 13,
                                color: Color(0xFF718096),
                              ),
                            ),
                          ],
                        ),
                      ),
                  ] else ...[
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF7FAFC),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          if (selectedFilm!.posterPath != null)
                            ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: CachedNetworkImage(
                                imageUrl: selectedFilm!.posterUrl,
                                width: 40,
                                height: 60,
                                fit: BoxFit.cover,
                              ),
                            ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  selectedFilm!.naslov ?? '',
                                  style: const TextStyle(
                                    fontFamily: "Inter",
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF2D3748),
                                  ),
                                ),
                                Text(
                                  '${selectedFilm!.godinaIzlaska ?? ''}',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Color(0xFF718096),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.close, size: 20),
                            onPressed: () {
                              setDialogState(() => selectedFilm = null);
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                  const SizedBox(height: 16),

                  const Text(
                    'Ocjena',
                    style: TextStyle(
                      fontFamily: "Inter",
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF2D3748),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(10, (index) {
                      final starIndex = index ~/ 2;
                      final isHalf = index % 2 == 0;
                      final starValue = starIndex + (isHalf ? 0.5 : 1.0);

                      IconData icon;
                      if (starValue <= rating) {
                        icon = isHalf ? Icons.star_half : Icons.star;
                      } else if (starValue - 0.5 < rating) {
                        icon = Icons.star_half;
                      } else {
                        icon = isHalf ? Icons.star_border : Icons.star_border;
                      }

                      if (!isHalf) {
                        return GestureDetector(
                          onTap: () {
                            setDialogState(() => rating = starValue);
                          },
                          child: Icon(
                            rating >= starValue
                                ? Icons.star
                                : (rating >= starValue - 0.5 ? Icons.star_half : Icons.star_border),
                            size: 32,
                            color: const Color(0xFF99D6AC),
                          ),
                        );
                      }
                      return const SizedBox.shrink();
                    }),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                        onPressed: () {
                          if (rating > 1) {
                            setDialogState(() => rating -= 0.5);
                          }
                        },
                        child: const Text('-0.5'),
                      ),
                      Text(
                        rating.toString(),
                        style: const TextStyle(
                          fontFamily: "Inter",
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2D3748),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          if (rating < 5) {
                            setDialogState(() => rating += 0.5);
                          }
                        },
                        child: const Text('+0.5'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  const Text(
                    'Recenzija',
                    style: TextStyle(
                      fontFamily: "Inter",
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF2D3748),
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: sadrzajController,
                    maxLines: 4,
                    style: const TextStyle(color: Color(0xFF2D3748)),
                    decoration: InputDecoration(
                      hintText: "Napišite svoju recenziju...",
                      hintStyle: const TextStyle(color: Color(0xFF718096), fontSize: 14),
                      filled: true,
                      fillColor: const Color(0xFFF7FAFC),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  Row(
                    children: [
                      Checkbox(
                        value: imaSpoiler,
                        onChanged: (value) {
                          setDialogState(() => imaSpoiler = value ?? false);
                        },
                        activeColor: const Color(0xFFFFD60A),
                      ),
                      const Expanded(
                        child: Text(
                          'Sadrži spojlere',
                          style: TextStyle(
                            fontFamily: "Inter",
                            fontSize: 14,
                            color: Color(0xFF2D3748),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: selectedFilm == null
                          ? null
                          : () async {
                              try {
                                await _recenzijaProvider.insert({
                                  'filmId': selectedFilm!.id,
                                  'ocjena': rating,
                                  'sadrzaj': sadrzajController.text,
                                  'imaSpoiler': imaSpoiler,
                                });
                                if (mounted) {
                                  Navigator.pop(context);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Recenzija uspješno kreirana'),
                                      backgroundColor: Color(0xFF99D6AC),
                                      duration: Duration(seconds: 1),
                                    ),
                                  );
                                  _loadRecenzije();
                                }
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Greška: $e'),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              }
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF4AB3EF),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'Objavi recenziju',
                        style: TextStyle(
                          fontFamily: "Inter",
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showEditRecenzijaDialog(Recenzija recenzija) {
    final TextEditingController sadrzajController = TextEditingController(text: recenzija.sadrzaj ?? '');

    double rating = recenzija.ocjena ?? 3.0;
    bool imaSpoiler = recenzija.imaSpoiler ?? false;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => Dialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 400, maxHeight: 550),
            padding: const EdgeInsets.all(20),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Uredi recenziju',
                        style: TextStyle(
                          fontFamily: "Inter",
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2D3748),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, color: Color(0xFF718096)),
                        onPressed: () => Navigator.pop(context),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF7FAFC),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        if (recenzija.filmPosterPath != null)
                          ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: CachedNetworkImage(
                              imageUrl: 'https://image.tmdb.org/t/p/w185${recenzija.filmPosterPath}',
                              width: 40,
                              height: 60,
                              fit: BoxFit.cover,
                            ),
                          ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            recenzija.filmNaslov ?? '',
                            style: const TextStyle(
                              fontFamily: "Inter",
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF2D3748),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  const Text(
                    'Ocjena',
                    style: TextStyle(
                      fontFamily: "Inter",
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF2D3748),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(5, (index) {
                      final starValue = index + 1.0;
                      return GestureDetector(
                        onTap: () {
                          setDialogState(() => rating = starValue);
                        },
                        child: Icon(
                          rating >= starValue
                              ? Icons.star
                              : (rating >= starValue - 0.5 ? Icons.star_half : Icons.star_border),
                          size: 32,
                          color: const Color(0xFF99D6AC),
                        ),
                      );
                    }),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                        onPressed: () {
                          if (rating > 0.5) {
                            setDialogState(() => rating -= 0.5);
                          }
                        },
                        child: const Text('-0.5'),
                      ),
                      Text(
                        rating.toString(),
                        style: const TextStyle(
                          fontFamily: "Inter",
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2D3748),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          if (rating < 5) {
                            setDialogState(() => rating += 0.5);
                          }
                        },
                        child: const Text('+0.5'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  const Text(
                    'Recenzija',
                    style: TextStyle(
                      fontFamily: "Inter",
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF2D3748),
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: sadrzajController,
                    maxLines: 4,
                    style: const TextStyle(color: Color(0xFF2D3748)),
                    decoration: InputDecoration(
                      hintText: "Napišite svoju recenziju...",
                      hintStyle: const TextStyle(color: Color(0xFF718096), fontSize: 14),
                      filled: true,
                      fillColor: const Color(0xFFF7FAFC),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  Row(
                    children: [
                      Checkbox(
                        value: imaSpoiler,
                        onChanged: (value) {
                          setDialogState(() => imaSpoiler = value ?? false);
                        },
                        activeColor: const Color(0xFFFFD60A),
                      ),
                      const Expanded(
                        child: Text(
                          'Sadrži spojlere',
                          style: TextStyle(
                            fontFamily: "Inter",
                            fontSize: 14,
                            color: Color(0xFF2D3748),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        try {
                          await _recenzijaProvider.update(recenzija.id!, {
                            'filmId': recenzija.filmId,
                            'ocjena': rating,
                            'sadrzaj': sadrzajController.text,
                            'imaSpoiler': imaSpoiler,
                          });
                          if (mounted) {
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Recenzija uspješno ažurirana'),
                                backgroundColor: Color(0xFF99D6AC),
                                duration: Duration(seconds: 1),
                              ),
                            );
                            _loadRecenzije();
                          }
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Greška: $e'),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF4AB3EF),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'Spremi izmjene',
                        style: TextStyle(
                          fontFamily: "Inter",
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
