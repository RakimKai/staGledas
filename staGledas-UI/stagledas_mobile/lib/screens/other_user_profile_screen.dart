import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stagledas_mobile/models/korisnik.dart';
import 'package:stagledas_mobile/models/pratitelji.dart';
import 'package:stagledas_mobile/providers/korisnik_provider.dart';
import 'package:stagledas_mobile/providers/pratitelji_provider.dart';
import 'package:stagledas_mobile/screens/chat_screen.dart';
import 'package:stagledas_mobile/screens/user_recenzije_screen.dart';
import 'package:stagledas_mobile/screens/watchlist_screen.dart';
import 'package:stagledas_mobile/utils/auth_util.dart';
import 'package:stagledas_mobile/widgets/loading_spinner_widget.dart';

class OtherUserProfileScreen extends StatefulWidget {
  final int userId;
  final String? username;
  final String? userImage;

  const OtherUserProfileScreen({
    super.key,
    required this.userId,
    this.username,
    this.userImage,
  });

  @override
  State<OtherUserProfileScreen> createState() => _OtherUserProfileScreenState();
}

class _OtherUserProfileScreenState extends State<OtherUserProfileScreen> {
  late KorisnikProvider _korisnikProvider;
  late PratiteljiProvider _pratiteljiProvider;

  bool _isLoading = true;
  bool _isFollowLoading = false;
  Korisnik? _user;
  Map<String, dynamic>? _statistics;
  Pratitelji? _followRecord;
  bool _areMutualFollowers = false;

  @override
  void initState() {
    super.initState();
    _korisnikProvider = context.read<KorisnikProvider>();
    _pratiteljiProvider = context.read<PratiteljiProvider>();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    try {
      var user = await _korisnikProvider.getById(widget.userId);
      var statistics = await _korisnikProvider.getStatistics(widget.userId);

      var followRecord = await _pratiteljiProvider.isFollowing(widget.userId);

      var areMutual = await _pratiteljiProvider.areMutualFollowers(widget.userId);

      setState(() {
        _user = user;
        _statistics = statistics;
        _followRecord = followRecord;
        _areMutualFollowers = areMutual;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
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

  Future<void> _toggleFollow() async {
    setState(() => _isFollowLoading = true);

    try {
      if (_followRecord != null) {
        await _pratiteljiProvider.unfollow(_followRecord!.id!);
        setState(() {
          _followRecord = null;
          _areMutualFollowers = false;
        });
      } else {
        var newFollow = await _pratiteljiProvider.follow(widget.userId);
        var areMutual = await _pratiteljiProvider.areMutualFollowers(widget.userId);
        setState(() {
          _followRecord = newFollow;
          _areMutualFollowers = areMutual;
        });
      }
      var statistics = await _korisnikProvider.getStatistics(widget.userId);
      setState(() => _statistics = statistics);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Greška: ${e.toString().replaceAll('Exception: ', '')}'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() => _isFollowLoading = false);
    }
  }

  void _openChat() {
    if (_user != null && _areMutualFollowers) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ChatScreen(otherUser: _user!),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Možete slati poruke samo međusobnim pratiocima'),
          backgroundColor: Color(0xFF718096),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isOwnProfile = widget.userId == Authorization.id;

    return Scaffold(
      backgroundColor: const Color(0xFFF2FCFB),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF2FCFB),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF2D3748)),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.username ?? _user?.korisnickoIme ?? 'Profil',
          style: const TextStyle(
            fontFamily: "Inter",
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Color(0xFF2D3748),
          ),
        ),
        centerTitle: true,
        actions: [
          if (!isOwnProfile)
            IconButton(
              icon: Icon(
                Icons.chat_bubble_outline,
                color: _areMutualFollowers
                    ? const Color(0xFF99D6AC)
                    : Colors.grey.shade400,
              ),
              onPressed: _openChat,
            ),
        ],
      ),
      body: _isLoading
          ? const LoadingSpinnerWidget(height: 300)
          : SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 20),

                  _buildAvatar(),
                  const SizedBox(height: 16),

                  Text(
                    _user?.fullName ?? widget.username ?? 'Korisnik',
                    style: const TextStyle(
                      fontFamily: "Inter",
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2D3748),
                    ),
                  ),
                  const SizedBox(height: 4),

                  Text(
                    '@${_user?.korisnickoIme ?? widget.username ?? ''}',
                    style: const TextStyle(
                      fontFamily: "Inter",
                      fontSize: 14,
                      color: Color(0xFF718096),
                    ),
                  ),
                  const SizedBox(height: 20),

                  if (!isOwnProfile) _buildActionButtons(),

                  const SizedBox(height: 24),

                  _buildStatsRow(),

                  const SizedBox(height: 24),

                  if (_followRecord != null || isOwnProfile)
                    _buildContentSection()
                  else
                    _buildPrivateProfileMessage(),

                  const SizedBox(height: 30),
                ],
              ),
            ),
    );
  }

  Widget _buildAvatar() {
    final imageData = _user?.slika ?? widget.userImage;
    final displayName = _user?.korisnickoIme ?? widget.username ?? 'K';

    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: const Color(0xFF4AB3EF),
          width: 3,
        ),
      ),
      child: CircleAvatar(
        radius: 47,
        backgroundColor: const Color(0xFFE2E8F0),
        backgroundImage: imageData != null && imageData.isNotEmpty
            ? MemoryImage(base64Decode(imageData))
            : null,
        child: imageData == null || imageData.isEmpty
            ? Text(
                displayName[0].toUpperCase(),
                style: const TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF4AB3EF),
                ),
              )
            : null,
      ),
    );
  }

  Widget _buildActionButtons() {
    final isFollowing = _followRecord != null;

    return Center(
      child: SizedBox(
        width: 180,
        child: ElevatedButton(
          onPressed: _isFollowLoading ? null : _toggleFollow,
          style: ElevatedButton.styleFrom(
            backgroundColor: isFollowing
                ? Colors.grey.shade200
                : const Color(0xFF4AB3EF),
            foregroundColor: isFollowing
                ? const Color(0xFF2D3748)
                : Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            elevation: 0,
          ),
          child: _isFollowLoading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Color(0xFF4AB3EF),
                  ),
                )
              : Text(
                  isFollowing ? 'Prestani pratiti' : 'Prati',
                  style: const TextStyle(
                    fontFamily: "Inter",
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
        ),
      ),
    );
  }

  Widget _buildStatsRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildStatItem(
            'Pratitelji',
            _statistics?['brojPratioca']?.toString() ?? '0',
          ),
          Container(
            width: 1,
            height: 40,
            color: Colors.grey.shade300,
          ),
          _buildStatItem(
            'Pratim',
            _statistics?['brojPratim']?.toString() ?? '0',
          ),
          Container(
            width: 1,
            height: 40,
            color: Colors.grey.shade300,
          ),
          _buildStatItem(
            'Recenzije',
            _statistics?['brojRecenzija']?.toString() ?? '0',
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontFamily: "Inter",
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF2D3748),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontFamily: "Inter",
            fontSize: 12,
            color: Color(0xFF718096),
          ),
        ),
      ],
    );
  }

  Widget _buildContentSection() {
    final username = _user?.korisnickoIme ?? widget.username;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Divider(),
          const SizedBox(height: 16),
          const Text(
            'Aktivnost',
            style: TextStyle(
              fontFamily: "Inter",
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF2D3748),
            ),
          ),
          const SizedBox(height: 16),
          _buildInfoRow(
            Icons.rate_review_outlined,
            'Recenzije',
            _statistics?['brojRecenzija']?.toString() ?? '0',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => UserRecenzijeScreen(
                    userId: widget.userId,
                    username: username,
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 12),
          _buildInfoRow(
            Icons.video_library_outlined,
            'Watchlist',
            _statistics?['brojPogledanihFilmova']?.toString() ?? '0',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => WatchlistScreen(
                    userId: widget.userId,
                    username: username,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
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
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: const Color(0xFF4AB3EF).withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: const Color(0xFF4AB3EF), size: 22),
            ),
            const SizedBox(width: 16),
            Text(
              label,
              style: const TextStyle(
                fontFamily: "Inter",
                fontSize: 14,
                color: Color(0xFF2D3748),
              ),
            ),
            const Spacer(),
            Text(
              value,
              style: const TextStyle(
                fontFamily: "Inter",
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF4AB3EF),
              ),
            ),
            if (onTap != null) ...[
              const SizedBox(width: 8),
              Icon(
                Icons.chevron_right,
                color: Colors.grey.shade400,
                size: 20,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildPrivateProfileMessage() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Column(
        children: [
          const Divider(),
          const SizedBox(height: 40),
          Icon(
            Icons.lock_outline,
            size: 48,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 16),
          const Text(
            'Pratite ovog korisnika da vidite njihov sadržaj',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: "Inter",
              fontSize: 14,
              color: Color(0xFF718096),
            ),
          ),
        ],
      ),
    );
  }
}
