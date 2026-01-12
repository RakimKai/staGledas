import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:stagledas_mobile/models/klub_lajkovi.dart';
import 'package:stagledas_mobile/providers/base_provider.dart';

class KlubLajkoviProvider extends BaseProvider<KlubLajkovi> {
  KlubLajkoviProvider() : super("KlubLajkovi");

  @override
  KlubLajkovi fromJson(data) {
    return KlubLajkovi.fromJson(data);
  }

  Future<Map<String, dynamic>> toggleLike(int objavaId) async {
    var url = "$fullUrl/toggle/$objavaId";
    var uri = Uri.parse(url);
    var headers = createHeaders();

    var response = await http.post(uri, headers: headers);

    if (isValidResponse(response)) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Failed to toggle like");
    }
  }

  Future<bool> isLiked(int objavaId) async {
    var url = "$fullUrl/check/$objavaId";
    var uri = Uri.parse(url);
    var headers = createHeaders();

    var response = await http.get(uri, headers: headers);

    if (isValidResponse(response)) {
      var data = jsonDecode(response.body);
      return data['isLiked'] ?? false;
    } else {
      throw Exception("Failed to check like status");
    }
  }

  Future<int> getLikeCount(int objavaId) async {
    var url = "$fullUrl/count/$objavaId";
    var uri = Uri.parse(url);
    var headers = createHeaders();

    var response = await http.get(uri, headers: headers);

    if (isValidResponse(response)) {
      var data = jsonDecode(response.body);
      return data['likeCount'] ?? 0;
    } else {
      throw Exception("Failed to get like count");
    }
  }
}
