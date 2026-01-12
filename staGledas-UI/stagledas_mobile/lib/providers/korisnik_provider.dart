import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:stagledas_mobile/models/korisnik.dart';
import 'package:stagledas_mobile/providers/base_provider.dart';

class KorisnikProvider extends BaseProvider<Korisnik> {
  KorisnikProvider() : super("Korisnici");

  @override
  Korisnik fromJson(data) {
    return Korisnik.fromJson(data);
  }

  Future<Korisnik> login(String username, String password) async {
    var url = "$fullUrl/login";

    var uri = Uri.parse(url);
    var headers = {"Content-Type": "application/json"};

    var body = jsonEncode({
      "username": username,
      "password": password,
    });

    var response = await http.post(uri, headers: headers, body: body);

    if (isValidResponse(response)) {
      var data = jsonDecode(response.body);
      return fromJson(data);
    } else {
      throw Exception("Unknown error");
    }
  }

  Future<Korisnik> register(Map<String, dynamic> request) async {
    var url = "$fullUrl/register";

    var uri = Uri.parse(url);
    var headers = {"Content-Type": "application/json"};

    var jsonRequest = jsonEncode(request);
    var response = await http.post(uri, headers: headers, body: jsonRequest);

    if (isValidResponse(response)) {
      var data = jsonDecode(response.body);
      return fromJson(data);
    } else {
      throw Exception("Unknown error");
    }
  }

  Future<Map<String, dynamic>> getProfile(int id) async {
    var url = "$fullUrl/$id/profil";

    var uri = Uri.parse(url);
    var headers = createHeaders();

    var response = await http.get(uri, headers: headers);

    if (isValidResponse(response)) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Unknown error");
    }
  }

  Future<Map<String, dynamic>> getStatistics(int id) async {
    var url = "$fullUrl/$id/statistike";

    var uri = Uri.parse(url);
    var headers = createHeaders();

    var response = await http.get(uri, headers: headers);

    if (isValidResponse(response)) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Unknown error");
    }
  }

  Future<Korisnik> uploadImage(int id, String base64Image) async {
    var url = "$fullUrl/$id";

    var uri = Uri.parse(url);
    var headers = createHeaders();

    var body = jsonEncode({
      "slika": base64Image,
    });

    var response = await http.put(uri, headers: headers, body: body);

    if (isValidResponse(response)) {
      var data = jsonDecode(response.body);
      return fromJson(data);
    } else {
      throw Exception("Failed to upload image");
    }
  }

  Future<void> changePassword(int id, String currentPassword, String newPassword, String confirmPassword) async {
    var url = "$fullUrl/$id/change-password";

    var uri = Uri.parse(url);
    var headers = createHeaders();

    var body = jsonEncode({
      "currentPassword": currentPassword,
      "newPassword": newPassword,
      "confirmPassword": confirmPassword,
    });

    var response = await http.post(uri, headers: headers, body: body);

    if (!isValidResponse(response)) {
      throw Exception("Failed to change password");
    }
  }

  Future<void> deleteAccount(int id, String password) async {
    var url = "$fullUrl/$id/delete-account";

    var uri = Uri.parse(url);
    var headers = createHeaders();

    var body = jsonEncode({
      "password": password,
    });

    var response = await http.post(uri, headers: headers, body: body);

    if (!isValidResponse(response)) {
      throw Exception("Failed to delete account");
    }
  }
}
