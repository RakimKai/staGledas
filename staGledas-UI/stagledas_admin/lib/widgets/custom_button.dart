import 'package:flutter/material.dart';
import 'package:stagledas_admin/utils/util.dart';

class CustomButton extends StatelessWidget {
  final String buttonText;
  final VoidCallback? onPress;
  final Color? buttonColor;
  final Color? textColor;
  final bool isDisabled;
  final IconData? icon;

  const CustomButton({
    super.key,
    required this.buttonText,
    this.onPress,
    this.buttonColor,
    this.textColor,
    this.isDisabled = false,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return IntrinsicWidth(
      child: ElevatedButton(
        onPressed: isDisabled ? null : onPress,
        style: ElevatedButton.styleFrom(
          backgroundColor: buttonColor ?? AppColors.primaryBlue,
          foregroundColor: textColor ?? Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          disabledBackgroundColor: Colors.grey[300],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 18),
              const SizedBox(width: 8),
            ],
            Text(
              buttonText,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
