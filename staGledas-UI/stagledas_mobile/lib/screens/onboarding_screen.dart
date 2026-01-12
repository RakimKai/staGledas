import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:provider/provider.dart';
import 'package:stagledas_mobile/models/tmdb_movie.dart';
import 'package:stagledas_mobile/providers/onboarding_provider.dart';
import 'package:stagledas_mobile/screens/home_screen.dart';
import 'package:stagledas_mobile/utils/auth_util.dart';
import 'package:stagledas_mobile/widgets/loading_spinner_widget.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  late OnboardingProvider _onboardingProvider;
  final CardSwiperController _swiperController = CardSwiperController();

  List<TmdbMovie> _movies = [];
  final List<int> _likedMovies = [];
  final List<int> _watchedMovies = [];
  bool _isLoading = true;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _onboardingProvider = context.read<OnboardingProvider>();
    _loadMovies();
  }

  Future<void> _loadMovies() async {
    try {
      var movies = await _onboardingProvider.getTopMovies();
      setState(() {
        _movies = movies;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Greska pri ucitavanju filmova: $e"),
            backgroundColor: Colors.red.shade700,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: const Color(0xFFF2FCFB),
        body: Stack(
          children: [
            if (!_isLoading && _movies.isNotEmpty && _currentIndex < _movies.length)
              Positioned.fill(
                child: CachedNetworkImage(
                  imageUrl: _movies[_currentIndex].posterUrl,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    color: const Color(0xFFF2FCFB),
                  ),
                  errorWidget: (context, url, error) => Container(
                    color: const Color(0xFFF2FCFB),
                  ),
                  imageBuilder: (context, imageProvider) => Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: imageProvider,
                        fit: BoxFit.cover,
                        colorFilter: ColorFilter.mode(
                          Colors.white.withOpacity(0.3),
                          BlendMode.srcOver,
                        ),
                      ),
                    ),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
                      child: Container(
                        color: const Color(0xFFF2FCFB).withOpacity(0.85),
                      ),
                    ),
                  ),
                ),
              ),

            SafeArea(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8, 12, 20, 0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        IconButton(
                          onPressed: _skipOnboarding,
                          icon: const Icon(
                            Icons.close,
                            color: Color(0xFF2D3748),
                            size: 28,
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 8, right: 36),
                            child: Column(
                              children: [
                                const Text(
                                  "Šta voliš gledati?",
                                  style: TextStyle(
                                    fontFamily: "Inter",
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF2D3748),
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 8),
                                const Text(
                                  "Prevuci desno ako ti se sviđa, lijevo ako ne",
                                  style: TextStyle(
                                    fontFamily: "Inter",
                                    fontSize: 14,
                                    color: Color(0xFF718096),
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  "${_currentIndex + 1} / ${_movies.length}",
                                  style: const TextStyle(
                                    fontFamily: "Inter",
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xFF4AB3EF),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  Expanded(
                    child: _isLoading
                        ? const LoadingSpinnerWidget(height: 400)
                        : _movies.isEmpty
                            ? const Center(
                                child: Text(
                                  "Nema dostupnih filmova",
                                  style: TextStyle(color: Color(0xFF718096)),
                                ),
                              )
                            : Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 10),
                                child: CardSwiper(
                                  controller: _swiperController,
                                  cardsCount: _movies.length,
                                  numberOfCardsDisplayed: 1,
                                  backCardOffset: const Offset(0, 0),
                                  padding: EdgeInsets.zero,
                                  scale: 1.0,
                                  onSwipe: _onSwipe,
                                  onEnd: _onEnd,
                                  cardBuilder: (context, index, percentThresholdX,
                                      percentThresholdY) {
                                    return _buildMovieCard(_movies[index]);
                                  },
                                ),
                              ),
                  ),

                  if (!_isLoading && _movies.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.swipe, color: Color(0xFF2D3748), size: 20),
                          SizedBox(width: 8),
                          Text(
                            "Prevuci karticu",
                            style: TextStyle(
                              fontFamily: "Inter",
                              fontSize: 14,
                              color: Color(0xFF2D3748),
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMovieCard(TmdbMovie movie) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          fit: StackFit.expand,
          children: [
            movie.posterPath != null
                ? CachedNetworkImage(
                    imageUrl: movie.posterUrl,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      color: const Color(0xFFE2E8F0),
                      child: const Center(
                        child: CircularProgressIndicator(
                          color: Color(0xFF4AB3EF),
                        ),
                      ),
                    ),
                    errorWidget: (context, url, error) => Container(
                      color: const Color(0xFFE2E8F0),
                      child: const Icon(
                        Icons.movie,
                        size: 80,
                        color: Color(0xFF718096),
                      ),
                    ),
                  )
                : Container(
                    color: const Color(0xFFE2E8F0),
                    child: const Icon(
                      Icons.movie,
                      size: 80,
                      color: Color(0xFF718096),
                    ),
                  ),

            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 200,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.9),
                    ],
                  ),
                ),
              ),
            ),

            Positioned(
              bottom: 20,
              left: 20,
              right: 20,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    movie.title ?? 'Nepoznato',
                    style: const TextStyle(
                      fontFamily: "Inter",
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      if (movie.year != null) ...[
                        const Icon(
                          Icons.calendar_today,
                          size: 16,
                          color: Colors.white70,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          movie.year.toString(),
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(width: 16),
                      ],
                      if (movie.voteAverage != null &&
                          movie.voteAverage! > 0) ...[
                        const Icon(
                          Icons.star,
                          size: 16,
                          color: Color(0xFF99D6AC),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          movie.voteAverage!.toStringAsFixed(1),
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool _onSwipe(
      int previousIndex, int? currentIndex, CardSwiperDirection direction) {
    var movie = _movies[previousIndex];

    if (direction == CardSwiperDirection.right) {
      if (movie.id != null) {
        _likedMovies.add(movie.id!);
      }
    }

    setState(() {
      _currentIndex = currentIndex ?? _currentIndex;
    });

    return true;
  }

  void _onEnd() {
    _showCompletionDialog();
  }

  void _skipOnboarding() {
    _saveInBackground();
    _navigateToHome();
  }

  void _saveInBackground() {
    if (_likedMovies.isEmpty) return;

    _onboardingProvider.processOnboarding(
      Authorization.id!,
      {
        'likedTmdbIds': _likedMovies,
        'watchedTmdbIds': _watchedMovies,
        'ratings': <Map<String, dynamic>>[],
      },
    ).catchError((_) {
      return;
    });
  }

  void _showCompletionDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          "Odlično!",
          style: TextStyle(
            fontFamily: "Inter",
            fontWeight: FontWeight.bold,
            color: Color(0xFF2D3748),
          ),
          textAlign: TextAlign.center,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.check_circle,
              color: Color(0xFF99D6AC),
              size: 64,
            ),
            const SizedBox(height: 16),
            Text(
              _likedMovies.isEmpty
                  ? "Nema više filmova za prikazati.\nMožeš nastaviti na početnu stranicu."
                  : "Svidjelo ti se ${_likedMovies.length} ${_likedMovies.length == 1 ? 'film' : _likedMovies.length < 5 ? 'filma' : 'filmova'}!\nNa osnovu toga ćemo ti preporučiti slične.",
              style: const TextStyle(
                fontFamily: "Inter",
                fontSize: 14,
                color: Color(0xFF718096),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                _saveInBackground();
                _navigateToHome();
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
                "Nastavi",
                style: TextStyle(
                  fontFamily: "Inter",
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _navigateToHome() {
    if (mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const HomeScreen(),
        ),
      );
    }
  }
}
