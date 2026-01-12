import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:stagledas_mobile/models/klub_filmova.dart';
import 'package:stagledas_mobile/models/klub_filmova_clanovi.dart';
import 'package:stagledas_mobile/providers/base_provider.dart';

class KlubFilmovaProvider extends BaseProvider<KlubFilmova> {
  KlubFilmovaProvider() : super("KlubFilmova");

  @override
  KlubFilmova fromJson(data) {
    return KlubFilmova.fromJson(data);
  }

  Future<KlubFilmova> join(int klubId) async {
    var url = "$fullUrl/$klubId/join";
    var uri = Uri.parse(url);
    var headers = createHeaders();

    var response = await http.post(uri, headers: headers);

    if (isValidResponse(response)) {
      var data = jsonDecode(response.body);
      return KlubFilmova.fromJson(data);
    } else {
      throw Exception("Failed to join club");
    }
  }

  Future<Map<String, dynamic>> leave(int klubId) async {
    var url = "$fullUrl/$klubId/leave";
    var uri = Uri.parse(url);
    var headers = createHeaders();

    var response = await http.post(uri, headers: headers);

    if (isValidResponse(response)) {
      var data = jsonDecode(response.body);
      return data;
    } else {
      throw Exception("Failed to leave club");
    }
  }

  Future<List<KlubFilmovaClanovi>> getMembers(int klubId) async {
    var url = "$fullUrl/$klubId/members";
    var uri = Uri.parse(url);
    var headers = createHeaders();

    var response = await http.get(uri, headers: headers);

    if (isValidResponse(response)) {
      var data = jsonDecode(response.body) as List;
      return data.map((item) => KlubFilmovaClanovi.fromJson(item)).toList();
    } else {
      throw Exception("Failed to get members");
    }
  }

  Future<void> deleteClub(int klubId) async {
    var url = "$fullUrl/$klubId";
    var uri = Uri.parse(url);
    var headers = createHeaders();

    var response = await http.delete(uri, headers: headers);

    if (!isValidResponse(response)) {
      throw Exception("Failed to delete club");
    }
  }

  Future<void> kickMember(int klubId, int memberId) async {
    var url = "$fullUrl/$klubId/kick/$memberId";
    var uri = Uri.parse(url);
    var headers = createHeaders();

    var response = await http.post(uri, headers: headers);

    if (!isValidResponse(response)) {
      throw Exception("Failed to kick member");
    }
  }
}
