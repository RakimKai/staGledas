import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:stagledas_mobile/models/obavijest.dart';
import 'package:stagledas_mobile/providers/base_provider.dart';

class ObavijestProvider extends BaseProvider<Obavijest> {
  ObavijestProvider() : super("Obavijesti");

  @override
  Obavijest fromJson(data) {
    return Obavijest.fromJson(data);
  }

  Future<Obavijest> approve(int id) async {
    var url = "$fullUrl/$id/approve";
    var uri = Uri.parse(url);

    var response = await http.post(
      uri,
      headers: createHeaders(),
    );

    if (isValidResponse(response)) {
      return fromJson(jsonDecode(response.body));
    }
    throw Exception("Failed to approve notification");
  }

  Future<Obavijest> reject(int id) async {
    var url = "$fullUrl/$id/reject";
    var uri = Uri.parse(url);

    var response = await http.post(
      uri,
      headers: createHeaders(),
    );

    if (isValidResponse(response)) {
      return fromJson(jsonDecode(response.body));
    }
    throw Exception("Failed to reject notification");
  }

  Future<Obavijest> markAsRead(int id) async {
    var url = "$fullUrl/$id/read";
    var uri = Uri.parse(url);

    var response = await http.post(
      uri,
      headers: createHeaders(),
    );

    if (isValidResponse(response)) {
      return fromJson(jsonDecode(response.body));
    }
    throw Exception("Failed to mark as read");
  }

  Future<int> getUnreadCount() async {
    var url = "$fullUrl/unread-count";
    var uri = Uri.parse(url);

    var response = await http.get(
      uri,
      headers: createHeaders(),
    );

    if (isValidResponse(response)) {
      return int.parse(response.body);
    }
    throw Exception("Failed to get unread count");
  }
}
