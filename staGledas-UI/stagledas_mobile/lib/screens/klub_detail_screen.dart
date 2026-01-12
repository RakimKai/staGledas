import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stagledas_mobile/models/klub_filmova.dart';
import 'package:stagledas_mobile/models/klub_filmova_clanovi.dart';
import 'package:stagledas_mobile/models/klub_objave.dart';
import 'package:stagledas_mobile/models/klub_komentari.dart';
import 'package:stagledas_mobile/providers/klub_filmova_provider.dart';
import 'package:stagledas_mobile/providers/klub_objave_provider.dart';
import 'package:stagledas_mobile/providers/klub_komentari_provider.dart';
import 'package:stagledas_mobile/providers/klub_lajkovi_provider.dart';
import 'package:stagledas_mobile/screens/other_user_profile_screen.dart';
import 'package:stagledas_mobile/utils/auth_util.dart';
import 'package:stagledas_mobile/widgets/loading_spinner_widget.dart';
import 'package:intl/intl.dart';

class KlubDetailScreen extends StatefulWidget {
  final int klubId;

  const KlubDetailScreen({super.key, required this.klubId});

  @override
  State<KlubDetailScreen> createState() => _KlubDetailScreenState();
}

class _KlubDetailScreenState extends State<KlubDetailScreen> {
  late KlubFilmovaProvider _klubProvider;
  late KlubObjaveProvider _objaveProvider;
  late KlubKomentariProvider _komentariProvider;
  late KlubLajkoviProvider _lajkoviProvider;

  KlubFilmova? _club;
  List<KlubFilmovaClanovi> _members = [];
  List<KlubObjave> _posts = [];
  Map<int, List<KlubKomentari>> _commentsMap = {};
  Map<int, bool> _likedPosts = {};

  bool _isLoading = true;
  bool _isMember = false;
  bool _isOwner = false;
  final TextEditingController _postController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _klubProvider = context.read<KlubFilmovaProvider>();
    _objaveProvider = context.read<KlubObjaveProvider>();
    _komentariProvider = context.read<KlubKomentariProvider>();
    _lajkoviProvider = context.read<KlubLajkoviProvider>();
    _loadClubData();
  }

  Future<void> _loadClubData() async {
    setState(() => _isLoading = true);
    try {
      _club = await _klubProvider.getById(widget.klubId);
      _members = await _klubProvider.getMembers(widget.klubId);
      _isMember = _members.any((m) => m.korisnikId == Authorization.id);
      _isOwner = _club?.vlasnikId == Authorization.id;

      var postsResult = await _objaveProvider.get(filter: {
        'KlubId': widget.klubId,
        'IsKorisnikIncluded': true,
      });
      _posts = postsResult.result;

      for (var post in _posts) {
        if (post.id != null) {
          try {
            _likedPosts[post.id!] = await _lajkoviProvider.isLiked(post.id!);
          } catch (e) {
            _likedPosts[post.id!] = false;
          }
        }
      }

      setState(() => _isLoading = false);
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  Future<void> _joinClub() async {
    if (!Authorization.isPremium) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Movie Clubs su dostupni samo premium korisnicima'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    try {
      await _klubProvider.join(widget.klubId);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Zahtjev za pridruživanje poslan!'),
            backgroundColor: Color(0xFF4AB3EF),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        String errorMsg = e.toString().toLowerCase();
        String displayMsg;
        Color bgColor;

        if (errorMsg.contains('pun') || errorMsg.contains('full') || errorMsg.contains('maksimalan')) {
          displayMsg = 'Klub je trenutno pun. Pokušajte kasnije.';
          bgColor = Colors.orange;
        } else if (errorMsg.contains('već') || errorMsg.contains('already')) {
          displayMsg = 'Već ste poslali zahtjev za pridruživanje.';
          bgColor = Colors.orange;
        } else {
          displayMsg = 'Greška: $e';
          bgColor = Colors.red;
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(displayMsg), backgroundColor: bgColor),
        );
      }
    }
  }

  Future<void> _leaveClub() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        title: const Text('Napusti klub?', style: TextStyle(color: Color(0xFF2D3748))),
        content: const Text(
          'Jeste li sigurni da želite napustiti ovaj klub?',
          style: TextStyle(color: Color(0xFF718096)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Odustani'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Napusti'),
          ),
        ],
      ),
    );
    if (confirm != true) return;

    try {
      var result = await _klubProvider.leave(widget.klubId);
      if (mounted) {
        if (result['deleted'] == true) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Klub je obrisan'),
              backgroundColor: Color(0xFFE57373),
            ),
          );
          Navigator.pop(context, true); // Return true to indicate club was deleted
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Napustili ste klub'),
              backgroundColor: Color(0xFF4AB3EF),
            ),
          );
          _loadClubData();
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Greška: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  Future<void> _deleteClub() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        title: const Text('Obriši klub?', style: TextStyle(color: Color(0xFF2D3748))),
        content: const Text(
          'Jeste li sigurni da želite obrisati ovaj klub? Ova radnja je nepovratna i sve objave će biti izbrisane.',
          style: TextStyle(color: Color(0xFF718096)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Odustani'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Obriši'),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    try {
      await _klubProvider.deleteClub(widget.klubId);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Klub je uspješno obrisan'),
            backgroundColor: Color(0xFF99D6AC),
          ),
        );
        Navigator.pop(context, true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Greška: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  Future<void> _kickMember(int memberId, String memberName) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        title: const Text('Ukloni člana?', style: TextStyle(color: Color(0xFF2D3748))),
        content: Text(
          'Jeste li sigurni da želite ukloniti $memberName iz kluba?',
          style: const TextStyle(color: Color(0xFF718096)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Odustani'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Ukloni'),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    try {
      await _klubProvider.kickMember(widget.klubId, memberId);
      if (mounted) {
        Navigator.pop(context); // Close members dialog
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('$memberName je uklonjen iz kluba'),
            backgroundColor: const Color(0xFF99D6AC),
          ),
        );
        _loadClubData();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Greška: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  Future<void> _createPost() async {
    if (_postController.text.trim().isEmpty) return;

    if (!_isMember) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Morate biti član kluba da biste objavili'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    try {
      await _objaveProvider.insert({
        'klubId': widget.klubId,
        'korisnikId': Authorization.id,
        'sadrzaj': _postController.text.trim(),
      });
      _postController.clear();
      FocusScope.of(context).unfocus();
      _loadClubData();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  Future<void> _toggleLike(int postId) async {
    try {
      var result = await _lajkoviProvider.toggleLike(postId);
      setState(() {
        _likedPosts[postId] = result['isLiked'] ?? false;
        var postIndex = _posts.indexWhere((p) => p.id == postId);
        if (postIndex != -1) {
          _posts[postIndex].brojLajkova = result['likeCount'] ?? 0;
        }
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  Future<void> _loadComments(int postId) async {
    try {
      var result = await _komentariProvider.get(filter: {
        'ObjavaId': postId,
        'IsKorisnikIncluded': true,
      });
      setState(() {
        _commentsMap[postId] = result.result;
      });
    } catch (e) {}
  }

  void _showCommentsDialog(KlubObjave post) async {
    await _loadComments(post.id!);

    if (!mounted) return;

    final commentController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) {
          final comments = _commentsMap[post.id] ?? [];

          return Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: Container(
              height: MediaQuery.of(context).size.height * 0.6,
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Komentari (${comments.length})',
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2D3748),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: comments.isEmpty
                        ? Center(
                            child: Text(
                              'Nema komentara',
                              style: TextStyle(color: Colors.grey.shade500),
                            ),
                          )
                        : ListView.builder(
                            itemCount: comments.length,
                            itemBuilder: (context, index) {
                              final comment = comments[index];
                              return _buildCommentItem(comment);
                            },
                          ),
                  ),
                  if (_isMember)
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: commentController,
                            style: const TextStyle(color: Color(0xFF2D3748)),
                            decoration: InputDecoration(
                              hintText: 'Dodaj komentar...',
                              hintStyle: const TextStyle(color: Color(0xFF718096)),
                              filled: true,
                              fillColor: const Color(0xFFF2FCFB),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(24),
                                borderSide: BorderSide.none,
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        IconButton(
                          onPressed: () async {
                            if (commentController.text.trim().isEmpty) return;
                            try {
                              await _komentariProvider.insert({
                                'objavaId': post.id,
                                'korisnikId': Authorization.id,
                                'sadrzaj': commentController.text.trim(),
                              });
                              commentController.clear();
                              await _loadComments(post.id!);
                              setModalState(() {});
                              var postIndex = _posts.indexWhere((p) => p.id == post.id);
                              if (postIndex != -1) {
                                setState(() {
                                  _posts[postIndex].brojKomentara =
                                      (_posts[postIndex].brojKomentara ?? 0) + 1;
                                });
                              }
                            } catch (e) {
                              if (mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Error: $e')),
                                );
                              }
                            }
                          },
                          icon: const Icon(
                            Icons.send,
                            color: Color(0xFF4AB3EF),
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildCommentItem(KlubKomentari comment) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 16,
            backgroundColor: const Color(0xFF4AB3EF).withOpacity(0.1),
            backgroundImage: comment.korisnik?.slika != null
                ? MemoryImage(base64Decode(comment.korisnik!.slika!))
                : null,
            child: comment.korisnik?.slika == null
                ? Text(
                    (comment.korisnik?.korisnickoIme ?? 'K')[0].toUpperCase(),
                    style: const TextStyle(
                      color: Color(0xFF4AB3EF),
                      fontSize: 12,
                    ),
                  )
                : null,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      comment.korisnik?.korisnickoIme ?? 'Korisnik',
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF2D3748),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _formatDate(comment.datumKreiranja),
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 11,
                        color: Color(0xFF718096),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  comment.sadrzaj ?? '',
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 13,
                    color: Color(0xFF2D3748),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showMembersDialog() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.5,
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Članovi (${_members.length})',
              style: const TextStyle(
                fontFamily: 'Inter',
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2D3748),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: _members.length,
                itemBuilder: (context, index) {
                  final member = _members[index];
                  return ListTile(
                    onTap: () {
                      Navigator.pop(context);
                      if (member.korisnikId != Authorization.id) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => OtherUserProfileScreen(
                              userId: member.korisnikId!,
                            ),
                          ),
                        );
                      }
                    },
                    leading: CircleAvatar(
                      backgroundColor: const Color(0xFF4AB3EF).withOpacity(0.1),
                      backgroundImage: member.korisnik?.slika != null
                          ? MemoryImage(base64Decode(member.korisnik!.slika!))
                          : null,
                      child: member.korisnik?.slika == null
                          ? Text(
                              (member.korisnik?.korisnickoIme ?? 'K')[0].toUpperCase(),
                              style: const TextStyle(color: Color(0xFF4AB3EF)),
                            )
                          : null,
                    ),
                    title: Text(
                      member.korisnik?.korisnickoIme ?? 'Korisnik',
                      style: const TextStyle(
                        color: Color(0xFF2D3748),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    trailing: member.isOwner
                        ? Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFF99D6AC).withOpacity(0.2),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Text(
                              'Vlasnik',
                              style: TextStyle(
                                fontSize: 12,
                                color: Color(0xFF99D6AC),
                              ),
                            ),
                          )
                        : _isOwner && member.korisnikId != Authorization.id
                            ? IconButton(
                                icon: const Icon(Icons.person_remove, color: Colors.red, size: 20),
                                onPressed: () => _kickMember(
                                  member.korisnikId!,
                                  member.korisnik?.korisnickoIme ?? 'Korisnik',
                                ),
                                tooltip: 'Ukloni člana',
                              )
                            : null,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime? date) {
    if (date == null) return '';
    final now = DateTime.now();
    final diff = now.difference(date);

    if (diff.inMinutes < 1) return 'Upravo';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m';
    if (diff.inHours < 24) return '${diff.inHours}h';
    if (diff.inDays < 7) return '${diff.inDays}d';
    return DateFormat('dd.MM.yyyy').format(date);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2FCFB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          _club?.naziv ?? 'Klub',
          style: const TextStyle(
            fontFamily: 'Inter',
            fontWeight: FontWeight.bold,
            color: Color(0xFF2D3748),
          ),
        ),
        iconTheme: const IconThemeData(color: Color(0xFF2D3748)),
        actions: [
          if (_isOwner)
            IconButton(
              icon: const Icon(Icons.delete_outline, color: Colors.red),
              onPressed: _deleteClub,
              tooltip: 'Obriši klub',
            ),
          if (!_isOwner && _isMember)
            TextButton(
              onPressed: _leaveClub,
              child: const Text(
                'Napusti',
                style: TextStyle(color: Colors.red),
              ),
            ),
          if (!_isMember)
            TextButton(
              onPressed: _joinClub,
              child: const Text(
                'Pridruži se',
                style: TextStyle(color: Color(0xFF4AB3EF)),
              ),
            ),
        ],
      ),
      body: _isLoading
          ? const LoadingSpinnerWidget(height: 300)
          : Column(
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  color: Colors.white,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (_club?.opis != null && _club!.opis!.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: Text(
                            _club!.opis!,
                            style: const TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 14,
                              color: Color(0xFF718096),
                            ),
                          ),
                        ),
                      GestureDetector(
                        onTap: _showMembersDialog,
                        child: Row(
                          children: [
                            SizedBox(
                              width: 70,
                              height: 32,
                              child: Stack(
                                children: [
                                  for (var i = 0; i < _members.take(3).length; i++)
                                    Positioned(
                                      left: i * 20.0,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color: Colors.white,
                                            width: 2,
                                          ),
                                        ),
                                        child: CircleAvatar(
                                          radius: 14,
                                          backgroundColor: const Color(0xFF4AB3EF).withOpacity(0.2),
                                          backgroundImage: _members[i].korisnik?.slika != null
                                              ? MemoryImage(base64Decode(_members[i].korisnik!.slika!))
                                              : null,
                                          child: _members[i].korisnik?.slika == null
                                              ? Text(
                                                  (_members[i].korisnik?.korisnickoIme ?? 'K')[0].toUpperCase(),
                                                  style: const TextStyle(
                                                    fontSize: 10,
                                                    color: Color(0xFF4AB3EF),
                                                  ),
                                                )
                                              : null,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                            Text(
                              '${_members.length} članova',
                              style: const TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 13,
                                color: Color(0xFF718096),
                              ),
                            ),
                            const Spacer(),
                            const Icon(
                              Icons.chevron_right,
                              color: Color(0xFF718096),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),

                Expanded(
                  child: !_isMember
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.lock_outline,
                                size: 64,
                                color: Colors.grey.shade400,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'Pridružite se klubu',
                                style: TextStyle(
                                  color: Colors.grey.shade600,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 32),
                                child: Text(
                                  'Objave i diskusije su vidljive samo članovima kluba',
                                  style: TextStyle(
                                    color: Colors.grey.shade500,
                                    fontSize: 14,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          ),
                        )
                      : _posts.isEmpty
                          ? Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.forum_outlined,
                                    size: 64,
                                    color: Colors.grey.shade400,
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    'Nema objava',
                                    style: TextStyle(
                                      color: Colors.grey.shade500,
                                      fontSize: 16,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 8),
                                    child: Text(
                                      'Budite prvi koji će objaviti!',
                                      style: TextStyle(
                                        color: Colors.grey.shade400,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : RefreshIndicator(
                              onRefresh: _loadClubData,
                              child: ListView.builder(
                                padding: const EdgeInsets.all(16),
                                itemCount: _posts.length,
                                itemBuilder: (context, index) {
                                  return _buildPostCard(_posts[index]);
                                },
                              ),
                            ),
                ),

                if (_isMember)
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 8,
                          offset: const Offset(0, -2),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _postController,
                            style: const TextStyle(color: Color(0xFF2D3748)),
                            maxLines: null,
                            decoration: InputDecoration(
                              hintText: 'Napiši objavu...',
                              hintStyle: const TextStyle(color: Color(0xFF718096)),
                              filled: true,
                              fillColor: const Color(0xFFF2FCFB),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(24),
                                borderSide: BorderSide.none,
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        IconButton(
                          onPressed: _createPost,
                          icon: const Icon(
                            Icons.send,
                            color: Color(0xFF4AB3EF),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
    );
  }

  Widget _buildPostCard(KlubObjave post) {
    final isLiked = _likedPosts[post.id] ?? false;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: () {
                  if (post.korisnikId != Authorization.id) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => OtherUserProfileScreen(
                          userId: post.korisnikId!,
                        ),
                      ),
                    );
                  }
                },
                child: CircleAvatar(
                  radius: 20,
                  backgroundColor: const Color(0xFF4AB3EF).withOpacity(0.1),
                  backgroundImage: post.korisnik?.slika != null
                      ? MemoryImage(base64Decode(post.korisnik!.slika!))
                      : null,
                  child: post.korisnik?.slika == null
                      ? Text(
                          (post.korisnik?.korisnickoIme ?? 'K')[0].toUpperCase(),
                          style: const TextStyle(
                            color: Color(0xFF4AB3EF),
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      : null,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      post.korisnik?.korisnickoIme ?? 'Korisnik',
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF2D3748),
                      ),
                    ),
                    Text(
                      _formatDate(post.datumKreiranja),
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 12,
                        color: Color(0xFF718096),
                      ),
                    ),
                  ],
                ),
              ),
              if (post.korisnikId == Authorization.id)
                PopupMenuButton<String>(
                  icon: const Icon(Icons.more_vert, color: Color(0xFF718096)),
                  color: Colors.white,
                  onSelected: (value) async {
                    if (value == 'delete') {
                      try {
                        await _objaveProvider.delete(post.id!);
                        _loadClubData();
                      } catch (e) {
                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Error: $e')),
                          );
                        }
                      }
                    }
                  },
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: 'delete',
                      child: Text(
                        'Obriši',
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  ],
                ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            post.sadrzaj ?? '',
            style: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 14,
              color: Color(0xFF2D3748),
              height: 1.4,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              GestureDetector(
                onTap: () => _toggleLike(post.id!),
                child: Row(
                  children: [
                    Icon(
                      isLiked ? Icons.favorite : Icons.favorite_border,
                      color: isLiked ? const Color(0xFFE57373) : const Color(0xFF718096),
                      size: 20,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${post.brojLajkova ?? 0}',
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 13,
                        color: Color(0xFF718096),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 20),
              GestureDetector(
                onTap: () => _showCommentsDialog(post),
                child: Row(
                  children: [
                    const Icon(
                      Icons.chat_bubble_outline,
                      color: Color(0xFF718096),
                      size: 20,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${post.brojKomentara ?? 0}',
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 13,
                        color: Color(0xFF718096),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _postController.dispose();
    super.dispose();
  }
}
