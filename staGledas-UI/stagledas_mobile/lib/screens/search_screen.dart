import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stagledas_mobile/layouts/master_layout.dart';
import 'package:stagledas_mobile/models/film.dart';
import 'package:stagledas_mobile/models/korisnik.dart';
import 'package:stagledas_mobile/models/tmdb_movie.dart';
import 'package:stagledas_mobile/providers/film_provider.dart';
import 'package:stagledas_mobile/providers/korisnik_provider.dart';
import 'package:stagledas_mobile/providers/tmdb_provider.dart';
import 'package:stagledas_mobile/screens/film_details_screen.dart';
import 'package:stagledas_mobile/screens/tmdb_details_screen.dart';
import 'package:stagledas_mobile/screens/other_user_profile_screen.dart';
import 'package:stagledas_mobile/utils/auth_util.dart';
import 'package:stagledas_mobile/widgets/loading_spinner_widget.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> with SingleTickerProviderStateMixin {
  late FilmProvider _filmProvider;
  late TmdbProvider _tmdbProvider;
  late KorisnikProvider _korisnikProvider;
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();

  bool _isLoading = false;
  bool _isInitialLoading = true;
  List<TmdbMovie>? _movieSearchResults;
  List<Korisnik>? _userSearchResults;
  List<Film>? _recommendations;
  int _selectedTab = 0;

  @override
  void initState() {
    super.initState();
    _filmProvider = context.read<FilmProvider>();
    _tmdbProvider = context.read<TmdbProvider>();
    _korisnikProvider = context.read<KorisnikProvider>();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        setState(() {
          _selectedTab = _tabController.index;
          _movieSearchResults = null;
          _userSearchResults = null;
        });
        if (_searchController.text.length >= 2) {
          _search(_searchController.text);
        }
      }
    });
    _loadRecommendations();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadRecommendations() async {
    if (Authorization.id != null) {
      try {
        var recommendations =
            await _filmProvider.getUserRecommendations(Authorization.id!);
        setState(() {
          _recommendations = recommendations;
          _isInitialLoading = false;
        });
      } catch (e) {
        setState(() => _isInitialLoading = false);
      }
    } else {
      setState(() => _isInitialLoading = false);
    }
  }

  Future<void> _search(String query) async {
    if (query.isEmpty) {
      setState(() {
        _movieSearchResults = null;
        _userSearchResults = null;
      });
      return;
    }

    setState(() => _isLoading = true);

    try {
      if (_selectedTab == 0) {
        final results = await _tmdbProvider.searchMovies(query);
        setState(() {
          _movieSearchResults = results;
          _isLoading = false;
        });
      } else {
        final results = await _korisnikProvider.get(filter: {
          'Ime': query,
          'PageSize': 20,
        });
        setState(() {
          _userSearchResults = results.result;
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Greška pri pretrazi: $e'),
            backgroundColor: Colors.red.shade700,
          ),
        );
      }
    }
  }

  void _openTmdbMovie(TmdbMovie tmdbMovie) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => TmdbDetailsScreen(tmdbMovie: tmdbMovie),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MasterLayout(
      selectedIndex: 2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Text(
              "Pretraži",
              style: TextStyle(
                fontFamily: "Inter",
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2D3748),
              ),
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
              labelStyle: const TextStyle(
                fontFamily: "Inter",
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
              dividerColor: Colors.transparent,
              tabs: const [
                Tab(text: "Filmovi"),
                Tab(text: "Korisnici"),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: TextField(
              controller: _searchController,
              onChanged: (value) {
                if (value.length >= 2) {
                  _search(value);
                } else if (value.isEmpty) {
                  setState(() {
                    _movieSearchResults = null;
                    _userSearchResults = null;
                  });
                }
              },
              style: const TextStyle(color: Color(0xFF2D3748)),
              decoration: InputDecoration(
                hintText: _selectedTab == 0
                    ? "Pretražite filmove..."
                    : "Pretražite korisnike...",
                hintStyle: const TextStyle(color: Color(0xFF718096), fontSize: 14),
                prefixIcon: const Icon(Icons.search, color: Color(0xFF718096)),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, color: Color(0xFF718096)),
                        onPressed: () {
                          _searchController.clear();
                          setState(() {
                            _movieSearchResults = null;
                            _userSearchResults = null;
                          });
                        },
                      )
                    : null,
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

          Expanded(
            child: Stack(
              children: [
                _isLoading
                    ? const LoadingSpinnerWidget(height: 200)
                    : _selectedTab == 0
                        ? (_movieSearchResults != null
                            ? _buildMovieSearchResults()
                            : _buildRecommendations())
                        : (_userSearchResults != null
                            ? _buildUserSearchResults()
                            : _buildUserSearchPlaceholder()),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMovieSearchResults() {
    if (_movieSearchResults!.isEmpty) {
      return const Center(
        child: Text(
          "Nema rezultata pretrage",
          style: TextStyle(color: Color(0xFF718096)),
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
      itemCount: _movieSearchResults!.length,
      itemBuilder: (context, index) {
        return _buildSearchResultItem(_movieSearchResults![index]);
      },
    );
  }

  Widget _buildUserSearchResults() {
    if (_userSearchResults!.isEmpty) {
      return const Center(
        child: Text(
          "Nema rezultata pretrage",
          style: TextStyle(color: Color(0xFF718096)),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: _userSearchResults!.length,
      itemBuilder: (context, index) {
        return _buildUserSearchItem(_userSearchResults![index]);
      },
    );
  }

  Widget _buildUserSearchItem(Korisnik user) {
    if (user.id == Authorization.id) {
      return const SizedBox.shrink();
    }

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => OtherUserProfileScreen(
              userId: user.id!,
              username: user.korisnickoIme,
              userImage: user.slika,
            ),
          ),
        );
      },
      child: Container(
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
          children: [
            CircleAvatar(
              radius: 24,
              backgroundColor: const Color(0xFF4AB3EF),
              backgroundImage: user.slika != null && user.slika!.isNotEmpty
                  ? MemoryImage(base64Decode(user.slika!))
                  : null,
              child: user.slika == null || user.slika!.isEmpty
                  ? Text(
                      (user.korisnickoIme ?? 'K')[0].toUpperCase(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    )
                  : null,
            ),
            const SizedBox(width: 12),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user.fullName,
                    style: const TextStyle(
                      fontFamily: "Inter",
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF2D3748),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '@${user.korisnickoIme ?? ''}',
                    style: const TextStyle(
                      fontFamily: "Inter",
                      fontSize: 13,
                      color: Color(0xFF718096),
                    ),
                  ),
                ],
              ),
            ),

            Icon(
              Icons.chevron_right,
              color: Colors.grey.shade400,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserSearchPlaceholder() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.people_outline,
            size: 64,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 16),
          const Text(
            "Pretražite korisnike",
            style: TextStyle(
              fontFamily: "Inter",
              fontSize: 16,
              color: Color(0xFF718096),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Unesite ime ili prezime korisnika",
            style: TextStyle(
              fontFamily: "Inter",
              fontSize: 14,
              color: Colors.grey.shade500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecommendations() {
    if (_isInitialLoading) {
      return const LoadingSpinnerWidget(height: 200);
    }

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (_recommendations != null && _recommendations!.isNotEmpty) ...[
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                "Preporučeno za tebe:",
                style: TextStyle(
                  fontFamily: "Inter",
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF718096),
                ),
              ),
            ),
            const SizedBox(height: 16),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 0.65,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: _recommendations!.length,
              itemBuilder: (context, index) {
                return _buildMovieGridItem(_recommendations![index]);
              },
            ),
          ] else
            const Center(
              child: Padding(
                padding: EdgeInsets.all(40),
                child: Text(
                  "Pretraži filmove da dodaš u watchlist!",
                  style: TextStyle(color: Color(0xFF718096)),
                  textAlign: TextAlign.center,
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: movie.posterPath != null
                  ? CachedNetworkImage(
                      imageUrl: movie.posterUrl,
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
                        child: const Icon(
                          Icons.movie,
                          color: Color(0xFF718096),
                        ),
                      ),
                    )
                  : Container(
                      color: const Color(0xFFE2E8F0),
                      child: const Icon(
                        Icons.movie,
                        color: Color(0xFF718096),
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchResultItem(TmdbMovie movie) {
    return GestureDetector(
      onTap: () => _openTmdbMovie(movie),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: movie.posterPath != null
                  ? CachedNetworkImage(
                      imageUrl: movie.posterUrl,
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
                      errorWidget: (context, url, error) => _buildMoviePlaceholder(movie.title),
                    )
                  : _buildMoviePlaceholder(movie.title),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMoviePlaceholder(String? title) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF4AB3EF).withOpacity(0.8),
            const Color(0xFF99D6AC).withOpacity(0.8),
          ],
        ),
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.movie_outlined,
                color: Colors.white,
                size: 32,
              ),
              if (title != null && title.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(
                  title,
                  style: const TextStyle(
                    fontFamily: "Inter",
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
