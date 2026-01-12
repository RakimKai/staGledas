import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stagledas_mobile/models/search_result.dart';
import 'package:stagledas_mobile/models/watchlist.dart';
import 'package:stagledas_mobile/providers/watchlist_provider.dart';
import 'package:stagledas_mobile/screens/film_details_screen.dart';
import 'package:stagledas_mobile/utils/auth_util.dart';
import 'package:stagledas_mobile/widgets/loading_spinner_widget.dart';

class WatchlistScreen extends StatefulWidget {
  final int? userId;
  final String? username;

  const WatchlistScreen({super.key, this.userId, this.username});

  @override
  State<WatchlistScreen> createState() => _WatchlistScreenState();
}

class _WatchlistScreenState extends State<WatchlistScreen>
    with SingleTickerProviderStateMixin {
  late WatchlistProvider _watchlistProvider;
  late TabController _tabController;

  bool _isLoading = true;
  SearchResult<Watchlist>? _watchlist;
  SearchResult<Watchlist>? _watched;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _watchlistProvider = context.read<WatchlistProvider>();
    _loadData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  bool get _isOwnProfile => widget.userId == null || widget.userId == Authorization.id;

  Future<void> _loadData() async {
    final userId = widget.userId ?? Authorization.id;
    if (userId == null) {
      setState(() => _isLoading = false);
      return;
    }

    try {
      var watchlist = await _watchlistProvider.get(filter: {
        'KorisnikId': userId,
        'Pogledano': false,
        'IsFilmIncluded': true,
        'PageSize': 50,
      });

      var watched = await _watchlistProvider.get(filter: {
        'KorisnikId': userId,
        'Pogledano': true,
        'IsFilmIncluded': true,
        'PageSize': 50,
      });

      setState(() {
        _watchlist = watchlist;
        _watched = watched;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF2D3748)),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          _isOwnProfile ? 'Watchlist' : 'Watchlist - ${widget.username ?? 'Korisnik'}',
          style: const TextStyle(
            fontFamily: "Inter",
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF2D3748),
          ),
        ),
        bottom: TabBar(
          controller: _tabController,
          labelColor: const Color(0xFF4AB3EF),
          unselectedLabelColor: const Color(0xFF718096),
          indicatorColor: const Color(0xFF4AB3EF),
          dividerColor: Colors.transparent,
          labelStyle: const TextStyle(
            fontFamily: "Inter",
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
          tabs: const [
            Tab(text: "Plan to watch"),
            Tab(text: "Watched"),
          ],
        ),
      ),
      body: _isLoading
          ? const LoadingSpinnerWidget(height: 300)
          : TabBarView(
              controller: _tabController,
              children: [
                _buildMovieGrid(_watchlist),
                _buildMovieGrid(_watched),
              ],
            ),
    );
  }

  Widget _buildMovieGrid(SearchResult<Watchlist>? data) {
    if (data == null || data.result.isEmpty) {
      return const Center(
        child: Text(
          'Nema filmova',
          style: TextStyle(
            fontFamily: "Inter",
            fontSize: 14,
            color: Color(0xFF718096),
          ),
        ),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 0.65,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: data.result.length,
      itemBuilder: (context, index) {
        final item = data.result[index];
        final film = item.film;

        return GestureDetector(
          onTap: () {
            if (film != null && film.id != null) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FilmDetailsScreen(filmId: film.id!),
                ),
              ).then((_) {
                _loadData();
              });
            }
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: film?.posterPath != null
                      ? CachedNetworkImage(
                          imageUrl:
                              'https://image.tmdb.org/t/p/w185${film!.posterPath}',
                          fit: BoxFit.cover,
                          width: double.infinity,
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
                            child: const Icon(Icons.movie,
                                color: Color(0xFF718096)),
                          ),
                        )
                      : Container(
                          color: const Color(0xFFE2E8F0),
                          child:
                              const Icon(Icons.movie, color: Color(0xFF718096)),
                        ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
