import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:stagledas_mobile/models/film.dart';
import 'package:stagledas_mobile/models/tmdb_movie.dart';
import 'package:stagledas_mobile/utils/auth_util.dart';

class TmdbProvider {
  String baseUrl = const String.fromEnvironment("baseUrl", defaultValue: "http://10.0.2.2:5284/api/");

  String get fullUrl => "${baseUrl}TMDb";

  Map<String, String> createHeaders() {
    var headers = {
      "Content-Type": "application/json",
    };

    if (Authorization.username != null && Authorization.password != null) {
      var credentials = base64Encode(
          utf8.encode('${Authorization.username}:${Authorization.password}'));
      headers["Authorization"] = "Basic $credentials";
    }

    return headers;
  }

  Future<List<TmdbMovie>> searchMovies(String query) async {
    var url = "$fullUrl/search?query=${Uri.encodeComponent(query)}";

    var uri = Uri.parse(url);
    var headers = createHeaders();

    var response = await http.get(uri, headers: headers);

    if (response.statusCode < 299) {
      var data = jsonDecode(response.body);
      var results = data['results'] as List;
      return results.map((item) => TmdbMovie.fromJson(item)).toList();
    } else {
      throw Exception("Failed to search TMDb");
    }
  }

  Future<Film> getOrImportMovie(int tmdbId) async {
    var url = "$fullUrl/movie/$tmdbId/local";

    var uri = Uri.parse(url);
    var headers = createHeaders();

    var response = await http.get(uri, headers: headers);

    if (response.statusCode < 299) {
      var data = jsonDecode(response.body);
      return Film.fromJson(data);
    } else {
      throw Exception("Failed to import movie");
    }
  }

  Future<List<TmdbMovie>> getTrending({int page = 1}) async {
    var url = "$fullUrl/trending?page=$page";

    var uri = Uri.parse(url);
    var headers = createHeaders();

    var response = await http.get(uri, headers: headers);

    if (response.statusCode < 299) {
      var data = jsonDecode(response.body) as List;
      return data.map((item) => TmdbMovie.fromJson(item)).toList();
    } else {
      throw Exception("Failed to get trending movies");
    }
  }

  Future<List<TmdbMovie>> getPopular({int page = 1}) async {
    var url = "$fullUrl/popular?page=$page";

    var uri = Uri.parse(url);
    var headers = createHeaders();

    var response = await http.get(uri, headers: headers);

    if (response.statusCode < 299) {
      var data = jsonDecode(response.body) as List;
      return data.map((item) => TmdbMovie.fromJson(item)).toList();
    } else {
      throw Exception("Failed to get popular movies");
    }
  }
}
