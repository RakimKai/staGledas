import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:stagledas_mobile/models/poruka.dart';
import 'package:stagledas_mobile/models/search_result.dart';
import 'package:stagledas_mobile/providers/base_provider.dart';
import 'package:stagledas_mobile/utils/auth_util.dart';

class PorukaProvider extends BaseProvider<Poruka> {
  PorukaProvider() : super("Poruke");

  Future<List<Poruka>> getConversation(int otherUserId) async {
    var currentUserId = Authorization.id;

    var sentMessages = await get(filter: {
      'PosiljateljId': currentUserId,
      'PrimateljId': otherUserId,
      'IsPosiljateljIncluded': true,
      'IsPrimateljIncluded': true,
    });

    var receivedMessages = await get(filter: {
      'PosiljateljId': otherUserId,
      'PrimateljId': currentUserId,
      'IsPosiljateljIncluded': true,
      'IsPrimateljIncluded': true,
    });

    var allMessages = [...sentMessages.result, ...receivedMessages.result];
    allMessages.sort((a, b) {
      var dateA = a.datumSlanja ?? DateTime(1970);
      var dateB = b.datumSlanja ?? DateTime(1970);
      return dateA.compareTo(dateB);
    });

    return allMessages;
  }

  Future<Map<int, Poruka>> getConversationsList() async {
    var currentUserId = Authorization.id;

    var sentMessages = await get(filter: {
      'PosiljateljId': currentUserId,
      'IsPosiljateljIncluded': true,
      'IsPrimateljIncluded': true,
    });

    var receivedMessages = await get(filter: {
      'PrimateljId': currentUserId,
      'IsPosiljateljIncluded': true,
      'IsPrimateljIncluded': true,
    });

    Map<int, Poruka> conversations = {};

    for (var msg in sentMessages.result) {
      var otherId = msg.primateljId!;
      if (!conversations.containsKey(otherId) ||
          (msg.datumSlanja?.isAfter(conversations[otherId]!.datumSlanja ?? DateTime(1970)) ?? false)) {
        conversations[otherId] = msg;
      }
    }

    for (var msg in receivedMessages.result) {
      var otherId = msg.posiljateljId!;
      if (!conversations.containsKey(otherId) ||
          (msg.datumSlanja?.isAfter(conversations[otherId]!.datumSlanja ?? DateTime(1970)) ?? false)) {
        conversations[otherId] = msg;
      }
    }

    return conversations;
  }

  Future<Poruka> sendMessage(int recipientId, String content) async {
    return await insert({
      'PosiljateljId': Authorization.id,
      'PrimateljId': recipientId,
      'Sadrzaj': content,
    });
  }

  Future<Poruka> markAsRead(int messageId) async {
    var url = "$fullUrl/$messageId/procitaj";
    var uri = Uri.parse(url);
    var headers = createHeaders();

    var response = await http.put(uri, headers: headers);

    if (isValidResponse(response)) {
      var data = jsonDecode(response.body);
      return Poruka.fromJson(data);
    } else {
      throw Exception("Failed to mark message as read");
    }
  }

  Future<int> getUnreadCount() async {
    var result = await get(filter: {
      'PrimateljId': Authorization.id,
      'Procitano': false,
    });
    return result.count ?? 0;
  }

  @override
  Poruka fromJson(data) {
    return Poruka.fromJson(data);
  }
}
