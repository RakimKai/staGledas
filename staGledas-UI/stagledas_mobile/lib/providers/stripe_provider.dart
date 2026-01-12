import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:stagledas_mobile/models/pretplate.dart';
import 'package:stagledas_mobile/utils/auth_util.dart';

class StripeProvider with ChangeNotifier {
  static String? _baseUrl;

  StripeProvider() {
    _baseUrl = const String.fromEnvironment("baseUrl",
        defaultValue: "http://localhost:5284/api/");
  }

  Map<String, String> _createHeaders() {
    String username = Authorization.username ?? "";
    String password = Authorization.password ?? "";
    String basicAuth =
        "Basic ${base64Encode(utf8.encode('$username:$password'))}";

    return {
      "Content-Type": "application/json",
      "Authorization": basicAuth
    };
  }

  Future<Map<String, dynamic>> createPaymentSheet() async {
    var url = "${_baseUrl}Stripe/payment-sheet";
    var uri = Uri.parse(url);
    var headers = _createHeaders();

    var response = await http.post(uri, headers: headers);

    if (response.statusCode < 299) {
      return jsonDecode(response.body);
    } else if (response.statusCode == 400) {
      var data = jsonDecode(response.body);
      var errorMsg = data['errors']?['userError']?[0] ??
                     data['message'] ??
                     'Greška';
      throw Exception(errorMsg);
    } else {
      throw Exception("Greška pri kreiranju payment sheet-a");
    }
  }

  Future<bool> confirmSubscription() async {
    var url = "${_baseUrl}Stripe/confirm";
    var uri = Uri.parse(url);
    var headers = _createHeaders();

    var response = await http.post(uri, headers: headers);

    if (response.statusCode < 299) {
      var data = jsonDecode(response.body);
      return data['isPremium'] ?? data['IsPremium'] ?? false;
    }
    return false;
  }

  Future<Map<String, dynamic>> createCheckoutSession({
    required String successUrl,
    required String cancelUrl,
  }) async {
    var url = "${_baseUrl}Stripe/checkout";
    var uri = Uri.parse(url);
    var headers = _createHeaders();

    var response = await http.post(
      uri,
      headers: headers,
      body: jsonEncode({
        'successUrl': successUrl,
        'cancelUrl': cancelUrl,
      }),
    );

    if (response.statusCode < 299) {
      return jsonDecode(response.body);
    } else if (response.statusCode == 400) {
      var data = jsonDecode(response.body);
      throw Exception(data['message'] ?? data['errors']?.values?.first?.first ?? 'Greška');
    } else {
      throw Exception("Greška pri kreiranju checkout sesije");
    }
  }

  Future<Pretplate?> getSubscription() async {
    var url = "${_baseUrl}Stripe/subscription";
    var uri = Uri.parse(url);
    var headers = _createHeaders();

    var response = await http.get(uri, headers: headers);

    if (response.statusCode < 299) {
      return Pretplate.fromJson(jsonDecode(response.body));
    } else if (response.statusCode == 404) {
      return null;
    } else {
      throw Exception("Greška pri dohvaćanju pretplate");
    }
  }

  Future<void> cancelSubscription() async {
    var url = "${_baseUrl}Stripe/cancel";
    var uri = Uri.parse(url);
    var headers = _createHeaders();

    var response = await http.post(uri, headers: headers);

    if (response.statusCode >= 299) {
      var data = jsonDecode(response.body);
      throw Exception(data['message'] ?? 'Greška pri otkazivanju pretplate');
    }
  }

  Future<bool> syncSubscription() async {
    var url = "${_baseUrl}Stripe/sync";
    var uri = Uri.parse(url);
    var headers = _createHeaders();

    var response = await http.post(uri, headers: headers);

    if (response.statusCode < 299) {
      var data = jsonDecode(response.body);
      return data['isPremium'] ?? data['IsPremium'] ?? false;
    }
    return false;
  }
}
