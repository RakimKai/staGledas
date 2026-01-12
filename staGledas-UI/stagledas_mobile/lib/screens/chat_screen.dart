import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stagledas_mobile/models/korisnik.dart';
import 'package:stagledas_mobile/models/poruka.dart';
import 'package:stagledas_mobile/providers/poruka_provider.dart';
import 'package:stagledas_mobile/screens/other_user_profile_screen.dart';
import 'package:stagledas_mobile/services/signalr_service.dart';
import 'package:stagledas_mobile/utils/auth_util.dart';
import 'package:stagledas_mobile/widgets/chat_bubble_widget.dart';
import 'package:stagledas_mobile/widgets/loading_spinner_widget.dart';

class ChatScreen extends StatefulWidget {
  final Korisnik otherUser;

  const ChatScreen({super.key, required this.otherUser});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late PorukaProvider _porukaProvider;
  late SignalRService _signalRService;
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  bool _isLoading = true;
  bool _isSending = false;
  List<Poruka> _messages = [];
  int? _currentUserId;

  StreamSubscription<Poruka>? _messageSubscription;
  StreamSubscription<Map<String, dynamic>>? _messagesReadSubscription;

  @override
  void initState() {
    super.initState();
    _porukaProvider = context.read<PorukaProvider>();
    _signalRService = context.read<SignalRService>();
    _initSignalR();
    _loadMessages();
  }

  Future<void> _initSignalR() async {
    final userId = await AuthUtil.getCurrentUserId();
    _currentUserId = userId;

    if (!_signalRService.isConnected) {
      await _signalRService.connect();
    }

    _messageSubscription = _signalRService.onMessageReceived.listen((message) {
      if ((message.posiljateljId == widget.otherUser.id && message.primateljId == _currentUserId) ||
          (message.posiljateljId == _currentUserId && message.primateljId == widget.otherUser.id)) {
        if (!_messages.any((m) => m.id == message.id)) {
          setState(() {
            _messages.add(message);
            _messages.sort((a, b) => a.datumSlanja!.compareTo(b.datumSlanja!));
          });
          _scrollToBottom();

          if (message.posiljateljId == widget.otherUser.id) {
            _porukaProvider.markAsRead(message.id!);
          }
        }
      }
    });

    _messagesReadSubscription = _signalRService.onMessagesRead.listen((data) {
      final readByUserId = data['primateljId'];

      if (readByUserId == widget.otherUser.id) {
        setState(() {
          for (var msg in _messages) {
            if (msg.posiljateljId == _currentUserId && msg.primateljId == widget.otherUser.id) {
              msg.procitano = true;
            }
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _messageSubscription?.cancel();
    _messagesReadSubscription?.cancel();
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadMessages() async {
    try {
      var messages = await _porukaProvider.getConversation(widget.otherUser.id!);

      for (var msg in messages) {
        if (msg.posiljateljId == widget.otherUser.id && msg.procitano == false) {
          await _porukaProvider.markAsRead(msg.id!);
        }
      }

      setState(() {
        _messages = messages;
        _isLoading = false;
      });

      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollToBottom();
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _sendMessage() async {
    final content = _messageController.text.trim();
    if (content.isEmpty || _isSending) return;

    setState(() => _isSending = true);

    try {
      await _porukaProvider.sendMessage(widget.otherUser.id!, content);
      _messageController.clear();
      await _loadMessages();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString().replaceAll('Exception: ', '')),
          backgroundColor: Colors.red.shade400,
        ),
      );
    } finally {
      setState(() => _isSending = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2FCFB),
      appBar: _buildAppBar(),
      body: Column(
        children: [
          Expanded(
            child: _isLoading
                ? const LoadingSpinnerWidget(height: 300)
                : _messages.isEmpty
                    ? _buildEmptyState()
                    : _buildMessagesList(),
          ),
          _buildMessageInput(),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 1,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Color(0xFF2D3748)),
        onPressed: () => Navigator.pop(context),
      ),
      title: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => OtherUserProfileScreen(
                userId: widget.otherUser.id!,
                username: widget.otherUser.korisnickoIme,
                userImage: widget.otherUser.slika,
              ),
            ),
          );
        },
        child: Row(
          children: [
            _buildAvatar(widget.otherUser.slika, 18),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.otherUser.fullName,
                  style: const TextStyle(
                    fontFamily: "Inter",
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF2D3748),
                  ),
                ),
                if (widget.otherUser.korisnickoIme != null)
                  Text(
                    '@${widget.otherUser.korisnickoIme}',
                    style: const TextStyle(
                      fontFamily: "Inter",
                      fontSize: 12,
                      color: Color(0xFF718096),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.chat_bubble_outline,
            size: 48,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 12),
          Text(
            "Zapocnite razgovor",
            style: TextStyle(
              fontFamily: "Inter",
              fontSize: 16,
              color: Colors.grey.shade500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessagesList() {
    return RefreshIndicator(
      onRefresh: _loadMessages,
      color: const Color(0xFF4AB3EF),
      child: ListView.builder(
        controller: _scrollController,
        padding: const EdgeInsets.symmetric(vertical: 12),
        itemCount: _messages.length,
        itemBuilder: (context, index) {
          return ChatBubbleWidget(poruka: _messages[index]);
        },
      ),
    );
  }

  Widget _buildMessageInput() {
    return Container(
      padding: EdgeInsets.only(
        left: 12,
        right: 12,
        top: 8,
        bottom: MediaQuery.of(context).padding.bottom + 8,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: const Color(0xFFF2FCFB),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: TextField(
                controller: _messageController,
                maxLines: null,
                keyboardType: TextInputType.multiline,
                textCapitalization: TextCapitalization.sentences,
                decoration: const InputDecoration(
                  hintText: "Unesite poruku...",
                  hintStyle: TextStyle(
                    fontFamily: "Inter",
                    color: Color(0xFF718096),
                  ),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 12),
                ),
                style: const TextStyle(
                  fontFamily: "Inter",
                  fontSize: 15,
                  color: Color(0xFF2D3748),
                ),
                onSubmitted: (_) => _sendMessage(),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Container(
            decoration: const BoxDecoration(
              color: Color(0xFF4AB3EF),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              onPressed: _isSending ? null : _sendMessage,
              icon: _isSending
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : const Icon(Icons.send, color: Colors.white, size: 20),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAvatar(String? slika, double radius) {
    return CircleAvatar(
      radius: radius,
      backgroundColor: Colors.grey.shade300,
      backgroundImage: slika != null && slika.isNotEmpty
          ? MemoryImage(base64Decode(slika))
          : null,
      child: slika == null || slika.isEmpty
          ? Icon(Icons.person, size: radius, color: Colors.white)
          : null,
    );
  }
}
