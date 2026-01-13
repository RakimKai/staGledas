import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:stagledas_mobile/models/tmdb_movie.dart';
import 'package:stagledas_mobile/utils/auth_util.dart';

class OnboardingProvider with ChangeNotifier {
  static String? _baseUrl;

  OnboardingProvider() {
    _baseUrl = const String.fromEnvironment("baseUrl",
        defaultValue: "http://10.0.2.2:5284/api/");
  }

  Map<String, String> createHeaders() {
    String username = Authorization.username ?? "";
    String password = Authorization.password ?? "";

    String basicAuth =
        "Basic ${base64Encode(utf8.encode('$username:$password'))}";

    return {
      "Content-Type": "application/json",
      "Authorization": basicAuth
    };
  }

  Future<List<TmdbMovie>> getTopMovies() async {
    var url = "${_baseUrl}Korisnici/onboarding/movies";

    var uri = Uri.parse(url);
    var headers = createHeaders();

    var response = await http.get(uri, headers: headers);

    if (response.statusCode < 299) {
      var data = jsonDecode(response.body) as List;
      return data.map((item) => TmdbMovie.fromJson(item)).toList();
    } else {
      throw Exception("Failed to load movies");
    }
  }

  Future<void> processOnboarding(int korisnikId, Map<String, dynamic> request) async {
    var url = "${_baseUrl}Korisnici/$korisnikId/onboarding";

    var uri = Uri.parse(url);
    var headers = createHeaders();

    var jsonRequest = jsonEncode(request);
    var response = await http.post(uri, headers: headers, body: jsonRequest);

    if (response.statusCode >= 299) {
      throw Exception("Failed to process onboarding");
    }
  }
}
