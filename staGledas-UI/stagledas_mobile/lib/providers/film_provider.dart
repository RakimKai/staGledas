import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:stagledas_mobile/models/film.dart';
import 'package:stagledas_mobile/providers/base_provider.dart';

class FilmProvider extends BaseProvider<Film> {
  FilmProvider() : super("Filmovi");

  @override
  Film fromJson(data) {
    return Film.fromJson(data);
  }

  Future<List<Film>> getRecommendations(int filmId) async {
    var url = "$fullUrl/$filmId/preporuke";

    var uri = Uri.parse(url);
    var headers = createHeaders();

    var response = await http.get(uri, headers: headers);

    if (isValidResponse(response)) {
      var data = jsonDecode(response.body) as List;
      return data.map((item) => Film.fromJson(item)).toList();
    } else {
      throw Exception("Unknown error");
    }
  }

  Future<List<Film>> getUserRecommendations(int korisnikId) async {
    var url = "$fullUrl/preporuke/$korisnikId";

    var uri = Uri.parse(url);
    var headers = createHeaders();

    var response = await http.get(uri, headers: headers);

    if (response.statusCode < 299) {
      var data = jsonDecode(response.body) as List;
      return data.map((item) => Film.fromJson(item)).toList();
    } else {
      throw Exception("Unknown error");
    }
  }

  Future<List<Film>> getPopular() async {
    var url = "$fullUrl/popular";

    var uri = Uri.parse(url);
    var headers = createHeaders();

    var response = await http.get(uri, headers: headers);

    if (isValidResponse(response)) {
      var data = jsonDecode(response.body) as List;
      return data.map((item) => Film.fromJson(item)).toList();
    } else {
      throw Exception("Unknown error");
    }
  }

  Future<Film> importFromTmdb(int tmdbId) async {
    var url = "$fullUrl/import/$tmdbId";

    var uri = Uri.parse(url);
    var headers = createHeaders();

    var response = await http.post(uri, headers: headers);

    if (isValidResponse(response)) {
      var data = jsonDecode(response.body);
      return fromJson(data);
    } else {
      throw Exception("Unknown error");
    }
  }

  Future<bool> isLiked(int filmId) async {
    var baseUrl = fullUrl.replaceAll('Filmovi', 'FilmoviLajkovi');
    var url = "$baseUrl/check/$filmId";

    var uri = Uri.parse(url);
    var headers = createHeaders();

    var response = await http.get(uri, headers: headers);

    if (response.statusCode < 299) {
      var data = jsonDecode(response.body);
      return data['isLiked'] ?? data['IsLiked'] ?? false;
    }
    return false;
  }

  Future<bool> toggleLike(int filmId) async {
    var baseUrl = fullUrl.replaceAll('Filmovi', 'FilmoviLajkovi');
    var url = "$baseUrl/toggle/$filmId";

    var uri = Uri.parse(url);
    var headers = createHeaders();

    var response = await http.post(uri, headers: headers);

    if (response.statusCode < 299) {
      var data = jsonDecode(response.body);
      return data['isLiked'] ?? data['IsLiked'] ?? false;
    }
    throw Exception("Failed to toggle like");
  }

  Future<bool> isFavorite(int filmId) async {
    var baseUrl = fullUrl.replaceAll('Filmovi', 'Favoriti');
    var url = "$baseUrl/check/$filmId";

    var uri = Uri.parse(url);
    var headers = createHeaders();

    var response = await http.get(uri, headers: headers);

    if (response.statusCode < 299) {
      var data = jsonDecode(response.body);
      return data['isFavorit'] ?? data['IsFavorit'] ?? false;
    }
    return false;
  }

  Future<bool> toggleFavorite(int filmId) async {
    var baseUrl = fullUrl.replaceAll('Filmovi', 'Favoriti');
    var url = "$baseUrl/toggle/$filmId";

    var uri = Uri.parse(url);
    var headers = createHeaders();

    var response = await http.post(uri, headers: headers);

    if (response.statusCode < 299) {
      var data = jsonDecode(response.body);
      return data['isFavorit'] ?? data['IsFavorit'] ?? false;
    }
    throw Exception("Failed to toggle favorite");
  }

  Future<bool> isInWatchlist(int filmId) async {
    var baseUrl = fullUrl.replaceAll('Filmovi', 'Watchlist');
    var url = "$baseUrl/check/$filmId";

    var uri = Uri.parse(url);
    var headers = createHeaders();

    var response = await http.get(uri, headers: headers);

    if (response.statusCode < 299) {
      var data = jsonDecode(response.body);
      return data['isInWatchlist'] ?? data['IsInWatchlist'] ?? false;
    }
    return false;
  }

  Future<bool> toggleWatchlist(int filmId) async {
    var baseUrl = fullUrl.replaceAll('Filmovi', 'Watchlist');
    var url = "$baseUrl/toggle/$filmId";

    var uri = Uri.parse(url);
    var headers = createHeaders();

    var response = await http.post(uri, headers: headers);

    if (response.statusCode < 299) {
      var data = jsonDecode(response.body);
      return data['isInWatchlist'] ?? data['IsInWatchlist'] ?? false;
    }
    throw Exception("Failed to toggle watchlist");
  }

  Future<bool> markAsWatched(int filmId) async {
    var baseUrl = fullUrl.replaceAll('Filmovi', 'Watchlist');
    var url = "$baseUrl/markWatched/$filmId";

    var uri = Uri.parse(url);
    var headers = createHeaders();

    var response = await http.post(uri, headers: headers);

    if (response.statusCode < 299) {
      var data = jsonDecode(response.body);
      return data['isWatched'] ?? data['IsWatched'] ?? false;
    }
    throw Exception("Failed to toggle watched status");
  }

  Future<bool> isWatched(int filmId) async {
    var baseUrl = fullUrl.replaceAll('Filmovi', 'Watchlist');
    var url = "$baseUrl/isWatched/$filmId";

    var uri = Uri.parse(url);
    var headers = createHeaders();

    var response = await http.get(uri, headers: headers);

    if (response.statusCode < 299) {
      var data = jsonDecode(response.body);
      return data['isWatched'] ?? data['IsWatched'] ?? false;
    }
    return false;
  }
}
