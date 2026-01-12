import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:stagledas_admin/models/korisnik.dart';
import 'package:stagledas_admin/providers/base_provider.dart';

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
      throw Exception("Neispravni kredencijali");
    }
  }
}
