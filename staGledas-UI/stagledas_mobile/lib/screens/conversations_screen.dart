import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:stagledas_mobile/models/obavijest.dart';
import 'package:stagledas_mobile/models/poruka.dart';
import 'package:stagledas_mobile/providers/obavijest_provider.dart';
import 'package:stagledas_mobile/providers/poruka_provider.dart';
import 'package:stagledas_mobile/screens/chat_screen.dart';
import 'package:stagledas_mobile/screens/other_user_profile_screen.dart';
import 'package:stagledas_mobile/screens/klub_detail_screen.dart';
import 'package:stagledas_mobile/services/signalr_service.dart';
import 'package:stagledas_mobile/utils/auth_util.dart';
import 'package:stagledas_mobile/widgets/loading_spinner_widget.dart';

class ConversationsScreen extends StatefulWidget {
  const ConversationsScreen({super.key});

  @override
  State<ConversationsScreen> createState() => _ConversationsScreenState();
}

class _ConversationsScreenState extends State<ConversationsScreen>
    with SingleTickerProviderStateMixin {
  late PorukaProvider _porukaProvider;
  late ObavijestProvider _obavijestProvider;
  late SignalRService _signalRService;
  late TabController _tabController;

  bool _isLoadingMessages = true;
  bool _isLoadingNotifications = true;
  Map<int, Poruka> _conversations = {};
  List<Obavijest> _notifications = [];

  StreamSubscription<Map<String, dynamic>>? _notificationSubscription;
  StreamSubscription<Poruka>? _messageSubscription;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _porukaProvider = context.read<PorukaProvider>();
    _obavijestProvider = context.read<ObavijestProvider>();
    _signalRService = context.read<SignalRService>();

    _tabController.addListener(_onTabChanged);

    _initSignalR();
    _loadData();
  }

  void _onTabChanged() {
    if (_tabController.indexIsChanging) return;

    if (_tabController.index == 1) {
      _signalRService.clearUnreadNotifications();
    }
  }

  Future<void> _initSignalR() async {
    if (!_signalRService.isConnected) {
      await _signalRService.connect();
    }

    _messageSubscription = _signalRService.onMessageReceived.listen((message) {
      _loadConversations();
    });

    _notificationSubscription = _signalRService.onNotificationReceived.listen((data) {
      try {
        final notification = Obavijest.fromJson(data);
        setState(() {
          _notifications.insert(0, notification);
        });
      } catch (e) {}
    });
  }

  @override
  void dispose() {
    _notificationSubscription?.cancel();
    _messageSubscription?.cancel();
    _tabController.removeListener(_onTabChanged);
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    await Future.wait([
      _loadConversations(),
      _loadNotifications(),
    ]);
  }

  Future<void> _loadConversations() async {
    try {
      var conversations = await _porukaProvider.getConversationsList();
      setState(() {
        _conversations = conversations;
        _isLoadingMessages = false;
      });
    } catch (e) {
      setState(() => _isLoadingMessages = false);
    }
  }

  Future<void> _loadNotifications() async {
    try {
      var result = await _obavijestProvider.get(filter: {
        'PrimateljId': Authorization.id,
        'IsPosiljateljIncluded': true,
        'IsKlubIncluded': true,
        'PageSize': 50,
      });

      for (var notification in result.result) {
        if (notification.status != 'pending' && notification.procitano == false && notification.id != null) {
          try {
            await _obavijestProvider.markAsRead(notification.id!);
            notification.procitano = true;
          } catch (_) {}
        }
      }

      setState(() {
        _notifications = result.result;
        _isLoadingNotifications = false;
      });
    } catch (e) {
      setState(() => _isLoadingNotifications = false);
    }
  }

  Future<void> _approveNotification(Obavijest notification) async {
    try {
      await _obavijestProvider.approve(notification.id!);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Zahtjev odobren!'),
          backgroundColor: Color(0xFF99D6AC),
        ),
      );
      _loadNotifications();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Greška: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _rejectNotification(Obavijest notification) async {
    try {
      await _obavijestProvider.reject(notification.id!);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Zahtjev odbijen.'),
          backgroundColor: Color(0xFF718096),
        ),
      );
      _loadNotifications();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Greška: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2FCFB),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF2FCFB),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF2D3748)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Inbox",
          style: TextStyle(
            fontFamily: "Inter",
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF2D3748),
          ),
        ),
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: const Color(0xFF4AB3EF),
          indicatorWeight: 3,
          labelColor: const Color(0xFF4AB3EF),
          unselectedLabelColor: const Color(0xFF718096),
          dividerColor: Colors.transparent,
          labelStyle: const TextStyle(
            fontFamily: "Inter",
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
          tabs: [
            const Tab(text: "Poruke"),
            Tab(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text("Obavijesti"),
                  if (_notifications.any((n) => n.procitano == false))
                    Container(
                      margin: const EdgeInsets.only(left: 6),
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: Color(0xFFE57373),
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        '${_notifications.where((n) => n.procitano == false).length}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildMessagesTab(),
          _buildNotificationsTab(),
        ],
      ),
    );
  }

  Widget _buildMessagesTab() {
    if (_isLoadingMessages) {
      return const LoadingSpinnerWidget(height: 300);
    }

    if (_conversations.isEmpty) {
      return _buildEmptyState(
        icon: Icons.chat_bubble_outline,
        title: "Nemate poruka",
        subtitle: "Pratite nekoga da biste mogli razgovarati",
      );
    }

    var sortedConversations = _conversations.entries.toList()
      ..sort((a, b) {
        var dateA = a.value.datumSlanja ?? DateTime(1970);
        var dateB = b.value.datumSlanja ?? DateTime(1970);
        return dateB.compareTo(dateA);
      });

    return RefreshIndicator(
      onRefresh: _loadConversations,
      color: const Color(0xFF4AB3EF),
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemCount: sortedConversations.length,
        itemBuilder: (context, index) {
          var entry = sortedConversations[index];
          var otherUserId = entry.key;
          var lastMessage = entry.value;
          return _buildConversationTile(otherUserId, lastMessage);
        },
      ),
    );
  }

  Widget _buildNotificationsTab() {
    if (_isLoadingNotifications) {
      return const LoadingSpinnerWidget(height: 300);
    }

    if (_notifications.isEmpty) {
      return _buildEmptyState(
        icon: Icons.notifications_none,
        title: "Nemate obavijesti",
        subtitle: "Ovdje će se pojaviti zahtjevi za pridruživanje klubovima",
      );
    }

    return RefreshIndicator(
      onRefresh: _loadNotifications,
      color: const Color(0xFF4AB3EF),
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemCount: _notifications.length,
        itemBuilder: (context, index) {
          return _buildNotificationTile(_notifications[index]);
        },
      ),
    );
  }

  Widget _buildEmptyState({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 64, color: Colors.grey.shade400),
          const SizedBox(height: 16),
          Text(
            title,
            style: TextStyle(
              fontFamily: "Inter",
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: TextStyle(
              fontFamily: "Inter",
              fontSize: 14,
              color: Colors.grey.shade500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildConversationTile(int otherUserId, Poruka lastMessage) {
    final isSentByMe = lastMessage.posiljateljId == Authorization.id;
    final otherUser = isSentByMe ? lastMessage.primatelj : lastMessage.posiljatelj;
    final isUnread = !isSentByMe && lastMessage.procitano == false;

    return InkWell(
      onTap: () {
        if (otherUser != null) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChatScreen(otherUser: otherUser),
            ),
          ).then((_) => _loadConversations());
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isUnread ? const Color(0xFF4AB3EF).withOpacity(0.05) : Colors.transparent,
          border: Border(
            bottom: BorderSide(color: Colors.grey.shade200),
          ),
        ),
        child: Row(
          children: [
            _buildAvatar(otherUser?.slika),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        otherUser?.fullName ?? 'Korisnik',
                        style: TextStyle(
                          fontFamily: "Inter",
                          fontSize: 16,
                          fontWeight: isUnread ? FontWeight.bold : FontWeight.w500,
                          color: const Color(0xFF2D3748),
                        ),
                      ),
                      Text(
                        _formatDate(lastMessage.datumSlanja),
                        style: TextStyle(
                          fontFamily: "Inter",
                          fontSize: 12,
                          color: isUnread ? const Color(0xFF4AB3EF) : Colors.grey.shade500,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      if (isSentByMe)
                        const Text(
                          "Vi: ",
                          style: TextStyle(
                            fontFamily: "Inter",
                            fontSize: 14,
                            color: Color(0xFF718096),
                          ),
                        ),
                      Expanded(
                        child: Text(
                          lastMessage.sadrzaj ?? '',
                          style: TextStyle(
                            fontFamily: "Inter",
                            fontSize: 14,
                            fontWeight: isUnread ? FontWeight.w500 : FontWeight.normal,
                            color: isUnread ? const Color(0xFF2D3748) : const Color(0xFF718096),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            if (isUnread)
              Container(
                width: 10,
                height: 10,
                margin: const EdgeInsets.only(left: 8),
                decoration: const BoxDecoration(
                  color: Color(0xFF4AB3EF),
                  shape: BoxShape.circle,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationTile(Obavijest notification) {
    final isPending = notification.status == 'pending';
    final isClubJoinRequest = notification.tip == 'club_join_request';
    final isApproved = notification.tip == 'club_join_approved';
    final isRejected = notification.tip == 'club_join_rejected';
    final isKicked = notification.tip == 'club_kicked';
    final isNewFollower = notification.tip == 'new_follower';
    final isClubRelated = isClubJoinRequest || isApproved || isRejected || isKicked;

    IconData icon;
    Color iconColor;

    if (isNewFollower) {
      icon = Icons.person_add;
      iconColor = const Color(0xFF99D6AC);
    } else if (isClubJoinRequest) {
      icon = Icons.group_add;
      iconColor = const Color(0xFF4AB3EF);
    } else if (isApproved) {
      icon = Icons.check_circle;
      iconColor = const Color(0xFF99D6AC);
    } else if (isRejected || isKicked) {
      icon = Icons.cancel;
      iconColor = const Color(0xFFE57373);
    } else {
      icon = Icons.notifications;
      iconColor = const Color(0xFF718096);
    }

    String? imageToShow;
    IconData fallbackIcon;
    if (isClubRelated) {
      imageToShow = notification.klub?.slika;
      fallbackIcon = Icons.groups;
    } else {
      imageToShow = notification.posiljatelj?.slika;
      fallbackIcon = Icons.person;
    }

    return GestureDetector(
      onTap: () {
        if (notification.posiljatelj != null && !isClubRelated) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => OtherUserProfileScreen(
                userId: notification.posiljatelj!.id!,
                username: notification.posiljatelj!.korisnickoIme,
                userImage: notification.posiljatelj!.slika,
              ),
            ),
          );
        } else if (isClubRelated && notification.klub != null) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => KlubDetailScreen(klubId: notification.klub!.id!),
            ),
          );
        }
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        padding: const EdgeInsets.all(12),
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
                _buildNotificationAvatar(imageToShow, fallbackIcon),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(icon, size: 16, color: iconColor),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              _getNotificationTitle(notification),
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
                      const SizedBox(height: 4),
                      Text(
                        notification.poruka ?? '',
                        style: const TextStyle(
                          fontFamily: "Inter",
                          fontSize: 13,
                          color: Color(0xFF718096),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _formatDate(notification.datumKreiranja),
                        style: TextStyle(
                          fontFamily: "Inter",
                          fontSize: 11,
                          color: Colors.grey.shade500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (isPending && isClubJoinRequest) ...[
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => _rejectNotification(notification),
                    style: TextButton.styleFrom(
                      foregroundColor: const Color(0xFF718096),
                    ),
                    child: const Text('Odbij'),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () => _approveNotification(notification),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF99D6AC),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text('Odobri'),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _getNotificationTitle(Obavijest notification) {
    switch (notification.tip) {
      case 'club_join_request':
        return 'Zahtjev za pridruživanje';
      case 'club_join_approved':
        return 'Zahtjev odobren';
      case 'club_join_rejected':
        return 'Zahtjev odbijen';
      case 'club_kicked':
        return 'Uklonjeni iz kluba';
      case 'follow_request':
        return 'Zahtjev za praćenje';
      case 'new_follower':
        return 'Novi pratitelj';
      default:
        return 'Obavijest';
    }
  }

  Widget _buildAvatar(String? slika) {
    return CircleAvatar(
      radius: 24,
      backgroundColor: Colors.grey.shade300,
      backgroundImage: slika != null && slika.isNotEmpty
          ? MemoryImage(base64Decode(slika))
          : null,
      child: slika == null || slika.isEmpty
          ? const Icon(Icons.person, size: 24, color: Colors.white)
          : null,
    );
  }

  Widget _buildNotificationAvatar(String? slika, IconData fallbackIcon) {
    return CircleAvatar(
      radius: 24,
      backgroundColor: const Color(0xFF4AB3EF).withOpacity(0.1),
      backgroundImage: slika != null && slika.isNotEmpty
          ? MemoryImage(base64Decode(slika))
          : null,
      child: slika == null || slika.isEmpty
          ? Icon(fallbackIcon, size: 24, color: const Color(0xFF4AB3EF))
          : null,
    );
  }

  String _formatDate(DateTime? date) {
    if (date == null) return '';

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final messageDate = DateTime(date.year, date.month, date.day);

    if (messageDate == today) {
      return DateFormat('HH:mm').format(date);
    } else if (messageDate == today.subtract(const Duration(days: 1))) {
      return 'Jučer';
    } else if (now.difference(date).inDays < 7) {
      const days = ['Pon', 'Uto', 'Sri', 'Čet', 'Pet', 'Sub', 'Ned'];
      return days[date.weekday - 1];
    } else {
      return DateFormat('dd.MM.').format(date);
    }
  }
}
