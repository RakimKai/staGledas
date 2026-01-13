import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:signalr_netcore/signalr_client.dart';
import 'package:stagledas_mobile/models/poruka.dart';
import 'package:stagledas_mobile/utils/auth_util.dart';

class SignalRService extends ChangeNotifier {
  HubConnection? _hubConnection;
  bool _isConnected = false;
  bool _hasUnreadMessages = false;
  bool _hasUnreadNotifications = false;
  int? _currentUserId;

  final StreamController<Poruka> _messageController = StreamController<Poruka>.broadcast();
  final StreamController<Map<String, dynamic>> _messagesReadController = StreamController<Map<String, dynamic>>.broadcast();
  final StreamController<Map<String, dynamic>> _notificationController = StreamController<Map<String, dynamic>>.broadcast();
  final StreamController<bool> _unreadBadgeController = StreamController<bool>.broadcast();

  Stream<Poruka> get onMessageReceived => _messageController.stream;
  Stream<Map<String, dynamic>> get onMessagesRead => _messagesReadController.stream;
  Stream<Map<String, dynamic>> get onNotificationReceived => _notificationController.stream;
  Stream<bool> get onUnreadBadgeChanged => _unreadBadgeController.stream;
  bool get isConnected => _isConnected;
  bool get hasUnreadInbox => _hasUnreadMessages || _hasUnreadNotifications;
  bool get hasUnreadMessages => _hasUnreadMessages;
  bool get hasUnreadNotifications => _hasUnreadNotifications;

  void setHasUnreadMessages(bool value) {
    if (_hasUnreadMessages != value) {
      _hasUnreadMessages = value;
      _unreadBadgeController.add(hasUnreadInbox);
      notifyListeners();
    }
  }

  void setHasUnreadNotifications(bool value) {
    if (_hasUnreadNotifications != value) {
      _hasUnreadNotifications = value;
      _unreadBadgeController.add(hasUnreadInbox);
      notifyListeners();
    }
  }

  void setHasUnreadInbox({bool? messages, bool? notifications}) {
    bool changed = false;
    if (messages != null && _hasUnreadMessages != messages) {
      _hasUnreadMessages = messages;
      changed = true;
    }
    if (notifications != null && _hasUnreadNotifications != notifications) {
      _hasUnreadNotifications = notifications;
      changed = true;
    }
    if (changed) {
      _unreadBadgeController.add(hasUnreadInbox);
      notifyListeners();
    }
  }

  void clearUnreadMessages() {
    setHasUnreadMessages(false);
  }

  void clearUnreadNotifications() {
    setHasUnreadNotifications(false);
  }

  Future<void> connect() async {
    if (_isConnected) return;

    try {
      final credentials = await AuthUtil.getCredentials();
      if (credentials == null) return;

      _currentUserId = await AuthUtil.getCurrentUserId();

      String baseUrl = const String.fromEnvironment('baseUrl', defaultValue: 'http://10.0.2.2:5284/api/');
      baseUrl = baseUrl.replaceAll('/api/', '').replaceAll('/api', '');
      if (!baseUrl.endsWith('/')) baseUrl += '/';

      final basicAuth = base64Encode(utf8.encode('${credentials['username']}:${credentials['password']}'));
      final hubUrl = '${baseUrl}chatHub?access_token=$basicAuth';

      _hubConnection = HubConnectionBuilder()
          .withUrl(hubUrl)
          .withAutomaticReconnect()
          .build();

      _hubConnection!.on('ReceiveMessage', _handleReceiveMessage);
      _hubConnection!.on('MessageSent', _handleMessageSent);
      _hubConnection!.on('MessagesRead', _handleMessagesRead);
      _hubConnection!.on('ReceiveNotification', _handleReceiveNotification);

      _hubConnection!.onclose(({error}) {
        _isConnected = false;
        notifyListeners();
      });

      _hubConnection!.onreconnecting(({error}) {
        _isConnected = false;
        notifyListeners();
      });

      _hubConnection!.onreconnected(({connectionId}) {
        _isConnected = true;
        notifyListeners();
      });

      await _hubConnection!.start();
      _isConnected = true;
      notifyListeners();
    } catch (e) {
      _isConnected = false;
    }
  }

  void _handleReceiveMessage(List<Object?>? args) {
    if (args == null || args.isEmpty) return;

    try {
      Map<String, dynamic> data;
      if (args[0] is Map<String, dynamic>) {
        data = args[0] as Map<String, dynamic>;
      } else if (args[0] is Map) {
        data = Map<String, dynamic>.from(args[0] as Map);
      } else {
        return;
      }

      final message = Poruka.fromJson(data);
      _messageController.add(message);

      if (message.primateljId == _currentUserId && message.posiljateljId != _currentUserId) {
        setHasUnreadMessages(true);
      }
    } catch (e) {}
  }

  void _handleMessageSent(List<Object?>? args) {
    if (args == null || args.isEmpty) return;

    try {
      Map<String, dynamic> data;
      if (args[0] is Map<String, dynamic>) {
        data = args[0] as Map<String, dynamic>;
      } else if (args[0] is Map) {
        data = Map<String, dynamic>.from(args[0] as Map);
      } else {
        return;
      }

      final message = Poruka.fromJson(data);
      _messageController.add(message);
    } catch (e) {}
  }

  void _handleMessagesRead(List<Object?>? args) {
    if (args == null || args.isEmpty) return;

    try {
      Map<String, dynamic> data;
      if (args[0] is Map<String, dynamic>) {
        data = args[0] as Map<String, dynamic>;
      } else if (args[0] is Map) {
        data = Map<String, dynamic>.from(args[0] as Map);
      } else {
        return;
      }

      _messagesReadController.add(data);
    } catch (e) {}
  }

  void _handleReceiveNotification(List<Object?>? args) {
    if (args == null || args.isEmpty) return;

    try {
      Map<String, dynamic> data;
      if (args[0] is Map<String, dynamic>) {
        data = args[0] as Map<String, dynamic>;
      } else if (args[0] is Map) {
        data = Map<String, dynamic>.from(args[0] as Map);
      } else {
        return;
      }

      _notificationController.add(data);
      setHasUnreadNotifications(true);
    } catch (e) {}
  }

  Future<void> disconnect() async {
    if (_hubConnection != null) {
      await _hubConnection!.stop();
      _isConnected = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _messageController.close();
    _messagesReadController.close();
    _notificationController.close();
    _unreadBadgeController.close();
    disconnect();
    super.dispose();
  }
}
