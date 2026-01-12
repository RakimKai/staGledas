import 'package:flutter/material.dart';

class LoadingSpinnerWidget extends StatelessWidget {
  const LoadingSpinnerWidget({super.key, required this.height});
  final int height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height.toDouble(),
      child: const Center(
        child: CircularProgressIndicator(
          color: Color(0xFF4AB3EF),
        ),
      ),
    );
  }
}
