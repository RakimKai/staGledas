import 'dart:convert';
import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stagledas_mobile/layouts/master_layout.dart';
import 'package:stagledas_mobile/models/film.dart';
import 'package:stagledas_mobile/models/novost.dart';
import 'package:stagledas_mobile/models/search_result.dart';
import 'package:stagledas_mobile/providers/film_provider.dart';
import 'package:stagledas_mobile/providers/novost_provider.dart';
import 'package:stagledas_mobile/providers/poruka_provider.dart';
import 'package:stagledas_mobile/providers/obavijest_provider.dart';
import 'package:stagledas_mobile/screens/film_details_screen.dart';
import 'package:stagledas_mobile/widgets/loading_spinner_widget.dart';
import 'package:stagledas_mobile/screens/conversations_screen.dart';
import 'package:stagledas_mobile/services/signalr_service.dart';
import 'package:stagledas_mobile/utils/auth_util.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late FilmProvider _filmProvider;
  late NovostProvider _novostProvider;
  late PorukaProvider _porukaProvider;
  late ObavijestProvider _obavijestProvider;
  late SignalRService _signalRService;
  late TabController _tabController;
  final ScrollController _moviesScrollController = ScrollController();

  bool _isLoading = true;
  bool _isLoadingMoreMovies = false;
  bool _hasMoreMovies = true;
  int _moviesPage = 1;
  static const int _moviesPageSize = 15;

  List<Film> _popularMovies = [];
  SearchResult<Novost>? _novosti;

  final Map<int, Uint8List> _imageCache = {};

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _filmProvider = context.read<FilmProvider>();
    _novostProvider = context.read<NovostProvider>();
    _porukaProvider = context.read<PorukaProvider>();
    _obavijestProvider = context.read<ObavijestProvider>();
    _signalRService = context.read<SignalRService>();
    _moviesScrollController.addListener(_onMoviesScroll);
    _initSignalR();
    _loadData();
  }

  Future<void> _initSignalR() async {
    if (!_signalRService.isConnected) {
      await _signalRService.connect();
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    _moviesScrollController.dispose();
    super.dispose();
  }

  void _onMoviesScroll() {
    if (_moviesScrollController.position.pixels >=
        _moviesScrollController.position.maxScrollExtent - 200) {
      if (!_isLoadingMoreMovies && _hasMoreMovies) {
        _loadMoreMovies();
      }
    }
  }

  Future<void> _loadMoreMovies() async {
    if (_isLoadingMoreMovies || !_hasMoreMovies) return;

    setState(() => _isLoadingMoreMovies = true);
    _moviesPage++;

    try {
      var result = await _filmProvider.get(filter: {
        'Page': _moviesPage,
        'PageSize': _moviesPageSize,
        'OrderBy': 'ProsjecnaOcjena desc',
      });
      setState(() {
        _popularMovies.addAll(result.result);
        _hasMoreMovies = result.result.length >= _moviesPageSize;
        _isLoadingMoreMovies = false;
      });
    } catch (e) {
      setState(() {
        _isLoadingMoreMovies = false;
        _moviesPage--;
      });
    }
  }

  Future<void> _loadData() async {
    try {
      var popularMovies = await _filmProvider.get(filter: {
        'Page': 1,
        'PageSize': _moviesPageSize,
        'OrderBy': 'ProsjecnaOcjena desc',
      });

      var novosti = await _novostProvider.get(filter: {
        'PageSize': 10,
      });

      bool hasUnreadMessages = false;
      bool hasUnreadNotifications = false;
      if (Authorization.id != null) {
        try {
          var unreadMessages = await _porukaProvider.get(filter: {
            'PrimateljId': Authorization.id,
            'Procitano': false,
            'PageSize': 1,
          });
          hasUnreadMessages = unreadMessages.result.isNotEmpty;

          var unreadNotifications = await _obavijestProvider.get(filter: {
            'PrimateljId': Authorization.id,
            'Procitano': false,
            'PageSize': 1,
          });
          hasUnreadNotifications = unreadNotifications.result.isNotEmpty;
        } catch (_) {}
      }

      for (var novost in novosti.result) {
        if (novost.slika != null && novost.id != null) {
          _cacheImage(novost.id!, novost.slika!);
        }
      }

      _signalRService.setHasUnreadInbox(messages: hasUnreadMessages, notifications: hasUnreadNotifications);

      setState(() {
        _popularMovies = popularMovies.result;
        _hasMoreMovies = popularMovies.result.length >= _moviesPageSize;
        _moviesPage = 1;
        _novosti = novosti;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  void _cacheImage(int id, String base64Data) {
    if (_imageCache.containsKey(id)) return;
    try {
      Uint8List? bytes;
      if (base64Data.startsWith('data:')) {
        bytes = Uri.parse(base64Data).data?.contentAsBytes();
      } else {
        bytes = base64Decode(base64Data);
      }
      if (bytes != null) {
        _imageCache[id] = bytes;
      }
    } catch (_) {}
  }

  Uint8List? _getCachedImage(int id) {
    return _imageCache[id];
  }

  @override
  Widget build(BuildContext context) {
    return MasterLayout(
      selectedIndex: 0,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Row(
              children: [
                Builder(
                  builder: (context) {
                    final signalR = context.read<SignalRService>();
                    return StreamBuilder<bool>(
                      stream: signalR.onUnreadBadgeChanged,
                      initialData: signalR.hasUnreadInbox,
                      builder: (context, snapshot) {
                        final hasUnread = snapshot.data ?? false;
                        return Stack(
                          children: [
                            IconButton(
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                              icon: const Icon(
                                Icons.chat_bubble_outline,
                                color: Color(0xFF718096),
                                size: 26,
                              ),
                              onPressed: () {
                                signalR.clearUnreadMessages();
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const ConversationsScreen(),
                                  ),
                                ).then((_) {
                                  _loadData();
                                });
                              },
                            ),
                            if (hasUnread)
                              Positioned(
                                right: 0,
                                top: 0,
                                child: Container(
                                  width: 10,
                                  height: 10,
                                  decoration: const BoxDecoration(
                                    color: Color(0xFFE57373),
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ),
                          ],
                        );
                      },
                    );
                  },
                ),
                const Expanded(
                  child: Text(
                    "Šta Gledaš?",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: "Inter",
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2D3748),
                    ),
                  ),
                ),
                const SizedBox(width: 26),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            child: TabBar(
              controller: _tabController,
              indicatorColor: const Color(0xFF4AB3EF),
              indicatorWeight: 3,
              labelColor: const Color(0xFF4AB3EF),
              unselectedLabelColor: const Color(0xFF718096),
              dividerColor: Colors.transparent,
              labelStyle: const TextStyle(
                fontFamily: "Inter",
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
              tabs: const [
                Tab(text: "Filmovi"),
                Tab(text: "Novosti"),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildFilmoviTab(),
                _buildNovostiTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilmoviTab() {
    if (_isLoading) {
      return const LoadingSpinnerWidget(height: 300);
    }

    return SingleChildScrollView(
      controller: _moviesScrollController,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Popularno ove sedmice:",
            style: TextStyle(
              fontFamily: "Inter",
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Color(0xFF718096),
            ),
          ),
          const SizedBox(height: 12),
          if (_popularMovies.isNotEmpty)
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 0.65,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: _popularMovies.length,
              itemBuilder: (context, index) {
                return _buildMovieGridItem(_popularMovies[index]);
              },
            ),
          if (_isLoadingMoreMovies)
            const Padding(
              padding: EdgeInsets.all(16),
              child: Center(
                child: CircularProgressIndicator(
                  color: Color(0xFF4AB3EF),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildMovieGridItem(Film movie) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => FilmDetailsScreen(filmId: movie.id!),
          ),
        );
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: movie.posterPath != null
            ? CachedNetworkImage(
                imageUrl: movie.posterUrl,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  color: const Color(0xFFE2E8F0),
                  child: const Center(
                    child: CircularProgressIndicator(
                      color: Color(0xFF4AB3EF),
                      strokeWidth: 2,
                    ),
                  ),
                ),
                errorWidget: (context, url, error) => Container(
                  color: const Color(0xFFE2E8F0),
                  child: const Icon(Icons.movie, color: Color(0xFF718096)),
                ),
              )
            : Container(
                color: const Color(0xFFE2E8F0),
                child: const Icon(Icons.movie, color: Color(0xFF718096)),
              ),
      ),
    );
  }

  Widget _buildNovostiTab() {
    if (_isLoading) {
      return const LoadingSpinnerWidget(height: 300);
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Popularno ove sedmice:",
            style: TextStyle(
              fontFamily: "Inter",
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Color(0xFF718096),
            ),
          ),
          const SizedBox(height: 12),
          if (_novosti != null && _novosti!.result.isNotEmpty)
            ...(_novosti!.result.map((novost) => GestureDetector(
              onTap: () => _showNovostDetails(novost),
              child: _buildNovostCard(novost),
            )).toList())
          else
            const Center(
              child: Text(
                "Nema dostupnih novosti",
                style: TextStyle(color: Color(0xFF718096)),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildNovostCard(Novost novost) {
    final cachedImage = novost.id != null ? _getCachedImage(novost.id!) : null;

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
            child: cachedImage != null
                ? Image.memory(
                    cachedImage,
                    width: 80,
                    height: 100,
                    fit: BoxFit.cover,
                    gaplessPlayback: true,
                    errorBuilder: (context, error, stackTrace) => Container(
                      width: 80,
                      height: 100,
                      color: const Color(0xFFE2E8F0),
                      child: const Icon(Icons.newspaper, color: Color(0xFF718096)),
                    ),
                  )
                : Container(
                    width: 80,
                    height: 100,
                    color: const Color(0xFFE2E8F0),
                    child: const Icon(Icons.newspaper, color: Color(0xFF718096)),
                  ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  novost.naslov ?? '',
                  style: const TextStyle(
                    fontFamily: "Inter",
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2D3748),
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  (novost.sadrzaj ?? '').length > 50
                      ? '${(novost.sadrzaj ?? '').substring(0, 50)}...'
                      : novost.sadrzaj ?? '',
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

  void _showNovostDetails(Novost novost) {
    final cachedImage = novost.id != null ? _getCachedImage(novost.id!) : null;

    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Container(
          constraints: const BoxConstraints(maxWidth: 500, maxHeight: 700),
          child: Stack(
            children: [
              SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (cachedImage != null)
                      ClipRRect(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(16),
                          topRight: Radius.circular(16),
                        ),
                        child: Image.memory(
                          cachedImage,
                          height: 200,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          gaplessPlayback: true,
                        ),
                      ),
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            novost.naslov ?? '',
                            style: const TextStyle(
                              fontFamily: "Inter",
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF2D3748),
                            ),
                          ),
                          const SizedBox(height: 8),
                          if (novost.datumKreiranja != null)
                            Text(
                              '${novost.datumKreiranja!.day}.${novost.datumKreiranja!.month}.${novost.datumKreiranja!.year}',
                              style: const TextStyle(
                                fontFamily: "Inter",
                                fontSize: 12,
                                color: Color(0xFF718096),
                              ),
                            ),
                          const SizedBox(height: 16),
                          Text(
                            novost.sadrzaj ?? '',
                            style: const TextStyle(
                              fontFamily: "Inter",
                              fontSize: 14,
                              color: Color(0xFF4A5568),
                              height: 1.6,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                top: 8,
                right: 8,
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.5),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.close,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
