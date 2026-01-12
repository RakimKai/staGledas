import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:stagledas_admin/models/reports.dart';
import 'package:stagledas_admin/utils/util.dart';

class ReportsProvider with ChangeNotifier {
  static String? _baseUrl;

  ReportsProvider() {
    _baseUrl = const String.fromEnvironment("baseUrl",
        defaultValue: "http://localhost:5284/api/");
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

  Future<DashboardStats> getDashboardStats() async {
    var url = "${_baseUrl}Reports/dashboard";
    var uri = Uri.parse(url);
    var headers = createHeaders();

    var response = await http.get(uri, headers: headers);

    if (response.statusCode < 299) {
      var data = jsonDecode(response.body);
      return DashboardStats.fromJson(data);
    } else {
      throw Exception("Failed to load dashboard stats");
    }
  }

  Future<List<YearlyReport>> getYearlyComparison() async {
    var url = "${_baseUrl}Reports/yearly-comparison";
    var uri = Uri.parse(url);
    var headers = createHeaders();

    var response = await http.get(uri, headers: headers);

    if (response.statusCode < 299) {
      var data = jsonDecode(response.body) as List;
      return data.map((e) => YearlyReport.fromJson(e)).toList();
    } else {
      throw Exception("Failed to load yearly comparison");
    }
  }

  Future<AnalyticsReport> getAnalyticsReport(int year) async {
    var url = "${_baseUrl}Reports/analytics/$year";
    var uri = Uri.parse(url);
    var headers = createHeaders();

    var response = await http.get(uri, headers: headers);

    if (response.statusCode < 299) {
      var data = jsonDecode(response.body);
      return AnalyticsReport.fromJson(data);
    } else {
      throw Exception("Failed to load analytics report");
    }
  }

  Future<UserTypeDistribution> getUserDistribution() async {
    var url = "${_baseUrl}Reports/user-distribution";
    var uri = Uri.parse(url);
    var headers = createHeaders();

    var response = await http.get(uri, headers: headers);

    if (response.statusCode < 299) {
      var data = jsonDecode(response.body);
      return UserTypeDistribution.fromJson(data);
    } else {
      throw Exception("Failed to load user distribution");
    }
  }

  Future<List<int>> exportPdf(int year) async {
    var url = "${_baseUrl}Reports/export-pdf/$year";
    var uri = Uri.parse(url);
    var headers = createHeaders();

    var response = await http.get(uri, headers: headers);

    if (response.statusCode < 299) {
      return response.bodyBytes;
    } else {
      throw Exception("Failed to export PDF");
    }
  }
}
