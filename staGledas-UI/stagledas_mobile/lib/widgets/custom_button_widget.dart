import 'package:flutter/material.dart';

class CustomButtonWidget extends StatelessWidget {
  CustomButtonWidget({
    super.key,
    required this.buttonText,
    required this.onPress,
    this.padding = const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
    this.buttonColor = const Color(0xFF4AB3EF),
    this.textColor = const Color(0xFFFFFFFF),
    this.fontSize = 16,
    this.fontWeight = FontWeight.bold,
    this.borderRadius = 8,
    this.isDisabled = false,
    this.isFullWidth = false,
  });

  final String buttonText;
  final void Function()? onPress;
  final EdgeInsetsGeometry padding;
  final Color buttonColor;
  final Color textColor;
  final double fontSize;
  final FontWeight fontWeight;
  final double borderRadius;
  final bool isDisabled;
  final bool isFullWidth;

  @override
  Widget build(BuildContext context) {
    return isFullWidth
        ? SizedBox(
            width: double.infinity,
            child: _buildButton(),
          )
        : IntrinsicWidth(
            child: _buildButton(),
          );
  }

  Widget _buildButton() {
    return ElevatedButton(
      onPressed: isDisabled ? null : onPress,
      style: ElevatedButton.styleFrom(
        foregroundColor: textColor,
        backgroundColor: buttonColor,
        shadowColor: Colors.transparent,
        textStyle: TextStyle(fontSize: fontSize, fontWeight: fontWeight),
        padding: padding,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
      child: Text(
        buttonText,
        style: const TextStyle(fontFamily: "Inter"),
      ),
    );
  }
}
