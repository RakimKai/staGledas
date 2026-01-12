import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:stagledas_admin/models/zalba.dart';
import 'package:stagledas_admin/providers/base_provider.dart';

class ZalbaProvider extends BaseProvider<Zalba> {
  ZalbaProvider() : super("Zalbe");

  @override
  Zalba fromJson(data) {
    return Zalba.fromJson(data);
  }

  Future<Zalba> approve(int id) async {
    var url = "${fullUrl}/$id/approve";
    var uri = Uri.parse(url);
    var headers = createHeaders();

    var response = await http.put(uri, headers: headers);

    if (isValidResponse(response)) {
      var data = jsonDecode(response.body);
      return fromJson(data);
    } else {
      throw Exception("Failed to approve");
    }
  }

  Future<Zalba> reject(int id) async {
    var url = "${fullUrl}/$id/reject";
    var uri = Uri.parse(url);
    var headers = createHeaders();

    var response = await http.put(uri, headers: headers);

    if (isValidResponse(response)) {
      var data = jsonDecode(response.body);
      return fromJson(data);
    } else {
      throw Exception("Failed to reject");
    }
  }
}
