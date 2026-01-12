import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stagledas_mobile/models/recenzija.dart';
import 'package:stagledas_mobile/models/search_result.dart';
import 'package:stagledas_mobile/providers/recenzija_provider.dart';
import 'package:stagledas_mobile/utils/auth_util.dart';
import 'package:stagledas_mobile/widgets/loading_spinner_widget.dart';

class UserRecenzijeScreen extends StatefulWidget {
  final int? userId;
  final String? username;

  const UserRecenzijeScreen({super.key, this.userId, this.username});

  @override
  State<UserRecenzijeScreen> createState() => _UserRecenzijeScreenState();
}

class _UserRecenzijeScreenState extends State<UserRecenzijeScreen> {
  late RecenzijaProvider _recenzijaProvider;

  bool _isLoading = true;
  SearchResult<Recenzija>? _recenzije;

  @override
  void initState() {
    super.initState();
    _recenzijaProvider = context.read<RecenzijaProvider>();
    _loadData();
  }

  int get _targetUserId => widget.userId ?? Authorization.id!;
  bool get _isOwnProfile => widget.userId == null || widget.userId == Authorization.id;

  Future<void> _loadData() async {
    final userId = widget.userId ?? Authorization.id;
    if (userId == null) {
      setState(() => _isLoading = false);
      return;
    }

    try {
      var recenzije = await _recenzijaProvider.get(filter: {
        'KorisnikId': userId,
        'IsFilmIncluded': true,
        'PageSize': 50,
        'OrderBy': 'DatumKreiranja desc',
      });

      setState(() {
        _recenzije = recenzije;
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
          _isOwnProfile ? 'Moje recenzije' : 'Recenzije - ${widget.username ?? 'Korisnik'}',
          style: const TextStyle(
            fontFamily: "Inter",
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF2D3748),
          ),
        ),
      ),
      body: _isLoading
          ? const LoadingSpinnerWidget(height: 300)
          : _recenzije == null || _recenzije!.result.isEmpty
              ? const Center(
                  child: Text(
                    'Nemate recenzija',
                    style: TextStyle(
                      fontFamily: "Inter",
                      fontSize: 14,
                      color: Color(0xFF718096),
                    ),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _recenzije!.result.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () => _showRecenzijaDetails(_recenzije!.result[index]),
                      child: _buildRecenzijaCard(_recenzije!.result[index]),
                    );
                  },
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
                    width: 60,
                    height: 90,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      width: 60,
                      height: 90,
                      color: const Color(0xFFE2E8F0),
                      child: const Center(
                        child: CircularProgressIndicator(
                          color: Color(0xFF4AB3EF),
                          strokeWidth: 2,
                        ),
                      ),
                    ),
                    errorWidget: (context, url, error) => Container(
                      width: 60,
                      height: 90,
                      color: const Color(0xFFE2E8F0),
                      child: const Icon(Icons.movie, color: Color(0xFF718096)),
                    ),
                  )
                : Container(
                    width: 60,
                    height: 90,
                    color: const Color(0xFFE2E8F0),
                    child: const Icon(Icons.movie, color: Color(0xFF718096)),
                  ),
          ),
          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  recenzija.filmNaslov ?? 'Film',
                  style: const TextStyle(
                    fontFamily: "Inter",
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF4AB3EF),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),

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
                    children: [
                      Container(
                        width: 18,
                        height: 18,
                        decoration: const BoxDecoration(
                          color: Color(0xFFFFD60A),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.visibility_off,
                          size: 10,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 6),
                      const Text(
                        "Sadrži spojlere",
                        style: TextStyle(
                          fontFamily: "Inter",
                          fontSize: 11,
                          color: Color(0xFF718096),
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  )
                else
                  Text(
                    (recenzija.sadrzaj ?? '').length > 80
                        ? '${(recenzija.sadrzaj ?? '').substring(0, 80)}...'
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

                if (recenzija.datumKreiranja != null) ...[
                  const SizedBox(height: 6),
                  Text(
                    '${recenzija.datumKreiranja!.day}.${recenzija.datumKreiranja!.month}.${recenzija.datumKreiranja!.year}',
                    style: const TextStyle(
                      fontFamily: "Inter",
                      fontSize: 11,
                      color: Color(0xFF718096),
                    ),
                  ),
                ],
              ],
            ),
          ),

          if (_isOwnProfile)
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  onPressed: () => _showEditRecenzijaDialog(recenzija),
                  icon: const Icon(Icons.edit_outlined),
                  color: const Color(0xFF4AB3EF),
                  iconSize: 22,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
                const SizedBox(width: 8),
                IconButton(
                  onPressed: () => _deleteRecenzija(recenzija),
                  icon: const Icon(Icons.delete_outline),
                  color: Colors.red.shade300,
                  iconSize: 22,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
        ],
      ),
    );
  }

  Future<void> _deleteRecenzija(Recenzija recenzija) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        title: const Text(
          'Obriši recenziju',
          style: TextStyle(color: Color(0xFF2D3748)),
        ),
        content: const Text(
          'Da li ste sigurni da želite obrisati ovu recenziju?',
          style: TextStyle(color: Color(0xFF718096)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Odustani'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(
              'Obriši',
              style: TextStyle(color: Colors.red.shade400),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true && recenzija.id != null) {
      try {
        await _recenzijaProvider.delete(recenzija.id!);
        _loadData();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Recenzija obrisana'),
              backgroundColor: Color(0xFF99D6AC),
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Greška: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
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

                if (recenzija.datumKreiranja != null)
                  Text(
                    '${recenzija.datumKreiranja!.day}.${recenzija.datumKreiranja!.month}.${recenzija.datumKreiranja!.year}',
                    style: const TextStyle(
                      fontFamily: "Inter",
                      fontSize: 12,
                      color: Color(0xFF718096),
                    ),
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
                            _loadData();
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
