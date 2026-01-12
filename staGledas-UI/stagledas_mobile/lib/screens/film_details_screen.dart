import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stagledas_mobile/models/film.dart';
import 'package:stagledas_mobile/providers/film_provider.dart';
import 'package:stagledas_mobile/providers/recenzija_provider.dart';
import 'package:stagledas_mobile/widgets/loading_spinner_widget.dart';

class FilmDetailsScreen extends StatefulWidget {
  final int filmId;

  const FilmDetailsScreen({super.key, required this.filmId});

  @override
  State<FilmDetailsScreen> createState() => _FilmDetailsScreenState();
}

class _FilmDetailsScreenState extends State<FilmDetailsScreen> {
  late FilmProvider _filmProvider;

  bool _isLoading = true;
  bool _isActionLoading = false;
  Film? _film;
  bool _isInWatchlist = false;
  bool _isWatched = false;

  @override
  void initState() {
    super.initState();
    _filmProvider = context.read<FilmProvider>();
    _loadFilm();
  }

  Future<void> _loadFilm() async {
    try {
      var film = await _filmProvider.getById(widget.filmId);

      bool isInWatchlist = false;
      bool isWatched = false;

      try {
        final results = await Future.wait([
          _filmProvider.isInWatchlist(widget.filmId),
          _filmProvider.isWatched(widget.filmId),
        ]);
        isInWatchlist = results[0];
        isWatched = results[1];
      } catch (_) {}

      setState(() {
        _film = film;
        _isInWatchlist = isInWatchlist;
        _isWatched = isWatched;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Greška pri učitavanju filma: $e"),
            backgroundColor: Colors.red.shade700,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2FCFB),
      body: _isLoading
          ? const LoadingSpinnerWidget(height: 400)
          : _film == null
              ? const Center(
                  child: Text(
                    "Film nije pronađen",
                    style: TextStyle(color: Color(0xFF718096)),
                  ),
                )
              : Stack(
                  children: [
                    SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildPosterCarousel(),

                          Padding(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _film!.naslov ?? 'Nepoznato',
                                  style: const TextStyle(
                                    fontFamily: "Inter",
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF2D3748),
                                  ),
                                ),
                                const SizedBox(height: 4),

                                if (_film!.godinaIzlaska != null)
                                  Text(
                                    "(${_film!.godinaIzlaska})",
                                    style: const TextStyle(
                                      fontFamily: "Inter",
                                      fontSize: 16,
                                      color: Color(0xFF718096),
                                    ),
                                  ),
                                const SizedBox(height: 16),

                                Row(
                                  children: [
                                    if (_film!.prosjecnaOcjena != null &&
                                        _film!.prosjecnaOcjena! > 0) ...[
                                      const Icon(
                                        Icons.star,
                                        size: 18,
                                        color: Color(0xFF99D6AC),
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        _film!.prosjecnaOcjena!
                                            .toStringAsFixed(1),
                                        style: const TextStyle(
                                          fontFamily: "Inter",
                                          fontSize: 14,
                                          color: Color(0xFF2D3748),
                                        ),
                                      ),
                                      const SizedBox(width: 16),
                                    ],
                                    if (_film!.trajanje != null) ...[
                                      const Icon(
                                        Icons.access_time,
                                        size: 18,
                                        color: Color(0xFF718096),
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        '${_film!.trajanje} min',
                                        style: const TextStyle(
                                          fontFamily: "Inter",
                                          fontSize: 14,
                                          color: Color(0xFF718096),
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                                const SizedBox(height: 20),

                                if (_film!.reziser != null) ...[
                                  const Text(
                                    "Režiser",
                                    style: TextStyle(
                                      fontFamily: "Inter",
                                      fontSize: 12,
                                      color: Color(0xFF718096),
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    _film!.reziser!,
                                    style: const TextStyle(
                                      fontFamily: "Inter",
                                      fontSize: 16,
                                      color: Color(0xFF2D3748),
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                ],

                                if (_film!.opis != null &&
                                    _film!.opis!.isNotEmpty) ...[
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
                                    _film!.opis!,
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
                        padding: const EdgeInsets.symmetric(
                            horizontal: 40, vertical: 20),
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
                                  : () async {
                                      setState(() => _isActionLoading = true);
                                      try {
                                        var inWatchlist = await _filmProvider
                                            .toggleWatchlist(widget.filmId);
                                        setState(() {
                                          _isInWatchlist = inWatchlist;
                                          if (inWatchlist) {
                                            _isWatched = false;
                                          }
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
                                        if (mounted) {
                                          setState(() => _isActionLoading = false);
                                        }
                                      }
                                    },
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
                                  : () async {
                                      setState(() => _isActionLoading = true);
                                      try {
                                        var isWatched = await _filmProvider
                                            .markAsWatched(widget.filmId);
                                        setState(() {
                                          _isWatched = isWatched;
                                          if (isWatched) {
                                            _isInWatchlist = false;
                                          }
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
                                        if (mounted) {
                                          setState(() => _isActionLoading = false);
                                        }
                                      }
                                    },
                            ),
                            _buildBottomActionButton(
                              icon: Icons.rate_review_outlined,
                              label: "Recenzija",
                              isActive: false,
                              activeColor: const Color(0xFFFFD60A),
                              onTap: () => _showCreateReviewDialog(),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
    );
  }

  Widget _buildPosterCarousel() {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.55,
      child: Stack(
        children: [
          Positioned.fill(
            child: _film!.posterPath != null
                ? CachedNetworkImage(
                    imageUrl: _film!.posterUrl,
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

  void _showCreateReviewDialog() {
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
                        if (_film!.posterPath != null)
                          ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: CachedNetworkImage(
                              imageUrl: _film!.posterUrl,
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
                                _film!.naslov ?? '',
                                style: const TextStyle(
                                  fontFamily: "Inter",
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF2D3748),
                                ),
                              ),
                              if (_film!.godinaIzlaska != null)
                                Text(
                                  '${_film!.godinaIzlaska}',
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
                            'filmId': _film!.id,
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
