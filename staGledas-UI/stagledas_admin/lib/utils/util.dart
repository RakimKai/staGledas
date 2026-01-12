import 'package:flutter/material.dart';

class Authorization {
  static String? username;
  static String? password;
  static int? id;
  static String? fullName;
}

class AppColors {
  static const Color scaffoldBg = Color(0xFFE8F4F8);
  static const Color sidebarBg = Color(0xFFD0EBF1);
  static const Color cardBg = Color(0xFFFFFFFF);

  static const Color primaryBlue = Color(0xFF00A0D0);
  static const Color tableHeader = Color(0xFF4FC3F7);

  static const Color chartBlue = Color(0xFF2196F3);
  static const Color chartTeal = Color(0xFF26A69A);
  static const Color chartPurple = Color(0xFF7E57C2);

  static const Color success = Color(0xFF4CAF50);
  static const Color error = Color(0xFFF44336);

  static const Color textDark = Color(0xFF212121);
  static const Color textMuted = Color(0xFF757575);
}

enum ZalbaStatus {
  pending("Na čekanju", Colors.amber),
  approved("Odobreno", Colors.green),
  rejected("Odbijeno", Colors.red);

  final String naziv;
  final Color boja;
  const ZalbaStatus(this.naziv, this.boja);

  static ZalbaStatus? fromString(String? value) {
    return ZalbaStatus.values.firstWhere(
      (status) => status.name == value,
      orElse: () => ZalbaStatus.pending,
    );
  }
}
