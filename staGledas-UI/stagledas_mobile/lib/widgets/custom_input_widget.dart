import 'package:flutter/material.dart';

class CustomInputField extends StatelessWidget {
  final String labelText;
  final String? Function(String?)? validator;
  final TextEditingController? controller;
  final IconData? prefixIcon;
  final double fontSize;
  final String fontFamily;
  final Color fillColor;
  final Color borderColor;
  final bool obscuredText;
  final int maxLines;

  const CustomInputField({
    super.key,
    required this.labelText,
    this.validator,
    this.controller,
    this.prefixIcon,
    this.fontSize = 16,
    this.fontFamily = "Inter",
    this.fillColor = Colors.white,
    this.borderColor = const Color(0xFFE2E8F0),
    this.obscuredText = false,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: validator,
      obscureText: obscuredText,
      controller: controller,
      maxLines: maxLines,
      style: TextStyle(
        fontSize: fontSize + 1,
        fontFamily: fontFamily,
        color: const Color(0xFF2D3748),
      ),
      decoration: InputDecoration(
        label: Text(labelText),
        labelStyle: TextStyle(
          fontSize: fontSize,
          fontFamily: fontFamily,
          color: const Color(0xFF718096),
        ),
        prefixIcon: prefixIcon != null
            ? Icon(prefixIcon, color: const Color(0xFF718096))
            : null,
        filled: true,
        fillColor: fillColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: borderColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: borderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFF4AB3EF)),
        ),
      ),
    );
  }
}
