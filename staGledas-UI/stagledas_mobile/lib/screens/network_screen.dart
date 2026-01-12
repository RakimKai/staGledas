import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stagledas_mobile/models/pratitelji.dart';
import 'package:stagledas_mobile/models/search_result.dart';
import 'package:stagledas_mobile/providers/pratitelji_provider.dart';
import 'package:stagledas_mobile/screens/other_user_profile_screen.dart';
import 'package:stagledas_mobile/utils/auth_util.dart';
import 'package:stagledas_mobile/widgets/loading_spinner_widget.dart';

class NetworkScreen extends StatefulWidget {
  const NetworkScreen({super.key});

  @override
  State<NetworkScreen> createState() => _NetworkScreenState();
}

class _NetworkScreenState extends State<NetworkScreen>
    with SingleTickerProviderStateMixin {
  late PratiteljiProvider _pratiteljiProvider;
  late TabController _tabController;

  bool _isLoading = true;
  SearchResult<Pratitelji>? _followers;
  SearchResult<Pratitelji>? _following;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _pratiteljiProvider = context.read<PratiteljiProvider>();
    _loadData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    if (Authorization.id == null) {
      setState(() => _isLoading = false);
      return;
    }

    try {
      var followers = await _pratiteljiProvider.get(filter: {
        'KorisnikId': Authorization.id,
        'IsPratiteljIncluded': true,
        'PageSize': 50,
      });

      var following = await _pratiteljiProvider.get(filter: {
        'PratiteljId': Authorization.id,
        'IsKorisnikIncluded': true,
        'PageSize': 50,
      });

      setState(() {
        _followers = followers;
        _following = following;
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
        title: const Text(
          'Network',
          style: TextStyle(
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
            Tab(text: "Pratitelji"),
            Tab(text: "Pratim"),
          ],
        ),
      ),
      body: _isLoading
          ? const LoadingSpinnerWidget(height: 300)
          : TabBarView(
              controller: _tabController,
              children: [
                _buildFollowersList(_followers, isFollowers: true),
                _buildFollowersList(_following, isFollowers: false),
              ],
            ),
    );
  }

  Widget _buildFollowersList(SearchResult<Pratitelji>? data,
      {required bool isFollowers}) {
    if (data == null || data.result.isEmpty) {
      return Center(
        child: Text(
          isFollowers ? 'Nema pratitelja' : 'Ne pratite nikoga',
          style: const TextStyle(
            fontFamily: "Inter",
            fontSize: 14,
            color: Color(0xFF718096),
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: data.result.length,
      itemBuilder: (context, index) {
        final item = data.result[index];
        final user = isFollowers ? item.pratitelj : item.korisnik;
        final username = user?.korisnickoIme ?? 'Korisnik';
        final fullName = '${user?.ime ?? ''} ${user?.prezime ?? ''}'.trim();

        return GestureDetector(
          onTap: () {
            if (user?.id != null) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => OtherUserProfileScreen(
                    userId: user!.id!,
                    username: user.korisnickoIme,
                    userImage: user.slika,
                  ),
                ),
              ).then((_) => _loadData()); // Refresh on return
            }
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
                  child: Text(
                    username[0].toUpperCase(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        username,
                        style: const TextStyle(
                          fontFamily: "Inter",
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF2D3748),
                        ),
                      ),
                      if (fullName.isNotEmpty)
                        Text(
                          fullName,
                          style: const TextStyle(
                            fontFamily: "Inter",
                            fontSize: 12,
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
      },
    );
  }
}
