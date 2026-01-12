import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stagledas_mobile/models/film.dart';
import 'package:stagledas_mobile/models/tmdb_movie.dart';
import 'package:stagledas_mobile/providers/film_provider.dart';
import 'package:stagledas_mobile/providers/recenzija_provider.dart';
import 'package:stagledas_mobile/providers/tmdb_provider.dart';

class TmdbDetailsScreen extends StatefulWidget {
  final TmdbMovie tmdbMovie;

  const TmdbDetailsScreen({super.key, required this.tmdbMovie});

  @override
  State<TmdbDetailsScreen> createState() => _TmdbDetailsScreenState();
}

class _TmdbDetailsScreenState extends State<TmdbDetailsScreen> {
  final TmdbProvider _tmdbProvider = TmdbProvider();
  late FilmProvider _filmProvider;

  bool _isActionLoading = false;
  Film? _importedFilm;
  bool _isInWatchlist = false;
  bool _isWatched = false;

  @override
  void initState() {
    super.initState();
    _filmProvider = context.read<FilmProvider>();
  }

  Future<Film> _ensureImported() async {
    if (_importedFilm != null) {
      return _importedFilm!;
    }
    final film = await _tmdbProvider.getOrImportMovie(widget.tmdbMovie.id!);
    setState(() => _importedFilm = film);
    return film;
  }

  @override
  Widget build(BuildContext context) {
    final movie = widget.tmdbMovie;

    return Scaffold(
      backgroundColor: const Color(0xFFF2FCFB),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildPosterCarousel(movie),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        movie.title ?? 'Nepoznato',
                        style: const TextStyle(
                          fontFamily: "Inter",
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2D3748),
                        ),
                      ),
                      const SizedBox(height: 4),
                      if (movie.year != null)
                        Text(
                          "(${movie.year})",
                          style: const TextStyle(
                            fontFamily: "Inter",
                            fontSize: 16,
                            color: Color(0xFF718096),
                          ),
                        ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          if (movie.voteAverage != null &&
                              movie.voteAverage! > 0) ...[
                            const Icon(
                              Icons.star,
                              size: 18,
                              color: Color(0xFF99D6AC),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              (movie.voteAverage! / 2).toStringAsFixed(1),
                              style: const TextStyle(
                                fontFamily: "Inter",
                                fontSize: 14,
                                color: Color(0xFF2D3748),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '(TMDb)',
                              style: const TextStyle(
                                fontFamily: "Inter",
                                fontSize: 12,
                                color: Color(0xFF718096),
                              ),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 20),
                      if (movie.overview != null &&
                          movie.overview!.isNotEmpty) ...[
                        const Text(
                          "Opis",
                          style: TextStyle(
                            fontFamily: "Inter",
                            fontSize: 12,
                            color: Color(0xFF718096),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          movie.overview!,
                          style: const TextStyle(
                            fontFamily: "Inter",
                            fontSize: 14,
                            color: Color(0xFF718096),
                            height: 1.6,
                          ),
                        ),
                      ],
                      const SizedBox(height: 100),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).padding.top + 10,
            left: 16,
            child: GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.9),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                    ),
                  ],
                ),
                child: const Icon(Icons.arrow_back, color: Color(0xFF2D3748)),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    const Color(0xFFF2FCFB).withOpacity(0),
                    const Color(0xFFF2FCFB),
                  ],
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildBottomActionButton(
                    icon: _isInWatchlist
                        ? Icons.bookmark
                        : Icons.bookmark_border,
                    label: "Watchlist",
                    isActive: _isInWatchlist,
                    activeColor: const Color(0xFF4AB3EF),
                    onTap: _isActionLoading
                        ? null
                        : () => _handleWatchlistAction(),
                  ),
                  _buildBottomActionButton(
                    icon: _isWatched
                        ? Icons.visibility
                        : Icons.visibility_outlined,
                    label: "Pogledano",
                    isActive: _isWatched,
                    activeColor: const Color(0xFF99D6AC),
                    onTap: _isActionLoading
                        ? null
                        : () => _handleWatchedAction(),
                  ),
                  _buildBottomActionButton(
                    icon: Icons.rate_review_outlined,
                    label: "Recenzija",
                    isActive: false,
                    activeColor: const Color(0xFFFFD60A),
                    onTap: _isActionLoading
                        ? null
                        : () => _handleReviewAction(),
                  ),
                ],
              ),
            ),
          ),
          if (_isActionLoading)
            Positioned.fill(
              child: Container(
                color: Colors.black.withOpacity(0.3),
                child: const Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircularProgressIndicator(color: Colors.white),
                      SizedBox(height: 16),
                      Text(
                        'Učitavanje...',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Future<void> _handleWatchlistAction() async {
    setState(() => _isActionLoading = true);
    try {
      final film = await _ensureImported();
      var inWatchlist = await _filmProvider.toggleWatchlist(film.id!);
      setState(() {
        _isInWatchlist = inWatchlist;
        if (inWatchlist) _isWatched = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(inWatchlist
                ? "Dodano u plan za gledanje"
                : "Uklonjeno iz watchliste"),
            backgroundColor: const Color(0xFF4AB3EF),
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 1),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text("Greška"),
            backgroundColor: Colors.red.shade700,
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 1),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isActionLoading = false);
    }
  }

  Future<void> _handleWatchedAction() async {
    setState(() => _isActionLoading = true);
    try {
      final film = await _ensureImported();
      var isWatched = await _filmProvider.markAsWatched(film.id!);
      setState(() {
        _isWatched = isWatched;
        if (isWatched) _isInWatchlist = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(isWatched
                ? "Označeno kao pogledano"
                : "Uklonjeno iz pogledanih"),
            backgroundColor: const Color(0xFF99D6AC),
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 1),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text("Greška"),
            backgroundColor: Colors.red.shade700,
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 1),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isActionLoading = false);
    }
  }

  Future<void> _handleReviewAction() async {
    setState(() => _isActionLoading = true);
    try {
      final film = await _ensureImported();
      setState(() => _isActionLoading = false);
      if (mounted) {
        _showCreateReviewDialog(film);
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isActionLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text("Greška pri učitavanju filma"),
            backgroundColor: Colors.red.shade700,
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 1),
          ),
        );
      }
    }
  }

  Widget _buildPosterCarousel(TmdbMovie movie) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.55,
      child: Stack(
        children: [
          Positioned.fill(
            child: movie.posterPath != null
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
                      child: const Icon(Icons.movie,
                          color: Color(0xFF718096), size: 80),
                    ),
                  )
                : Container(
                    color: const Color(0xFFE2E8F0),
                    child: const Icon(Icons.movie,
                        color: Color(0xFF718096), size: 80),
                  ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            height: 100,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    const Color(0xFFF2FCFB).withOpacity(0.8),
                    const Color(0xFFF2FCFB),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomActionButton({
    required IconData icon,
    required String label,
    required bool isActive,
    VoidCallback? onTap,
    Color activeColor = const Color(0xFF4AB3EF),
  }) {
    final isDisabled = onTap == null;

    return GestureDetector(
      onTap: onTap,
      child: Opacity(
        opacity: isDisabled ? 0.5 : 1.0,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: isActive
                    ? activeColor.withOpacity(0.2)
                    : Colors.white,
                shape: BoxShape.circle,
                border: Border.all(
                  color: isActive ? activeColor : const Color(0xFFE2E8F0),
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 8,
                  ),
                ],
              ),
              child: Icon(
                icon,
                color: isActive ? activeColor : const Color(0xFF718096),
                size: 28,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                fontFamily: "Inter",
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: isActive ? activeColor : const Color(0xFF718096),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showCreateReviewDialog(Film film) {
    final recenzijaProvider = context.read<RecenzijaProvider>();
    final TextEditingController sadrzajController = TextEditingController();

    double rating = 3.0;
    bool imaSpoiler = false;

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
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF7FAFC),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        if (film.posterPath != null)
                          ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: CachedNetworkImage(
                              imageUrl: film.posterUrl,
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
                                film.naslov ?? '',
                                style: const TextStyle(
                                  fontFamily: "Inter",
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF2D3748),
                                ),
                              ),
                              if (film.godinaIzlaska != null)
                                Text(
                                  '${film.godinaIzlaska}',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Color(0xFF718096),
                                  ),
                                ),
                            ],
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
                              : (rating >= starValue - 0.5
                                  ? Icons.star_half
                                  : Icons.star_border),
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
                      hintStyle:
                          const TextStyle(color: Color(0xFF718096), fontSize: 14),
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
                          await recenzijaProvider.insert({
                            'filmId': film.id,
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
}
