import 'package:flutter/material.dart';

class PrimaryButton extends StatelessWidget {
  final String text;
  final bool isLoading;
  final VoidCallback onTap;
  final double? size;

  const PrimaryButton({
    required this.text,
    this.isLoading = false,
    required this.onTap,
    this.size,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: isLoading ? null : onTap,
      style: ElevatedButton.styleFrom(
          backgroundColor: Colors.purple,
          foregroundColor: Colors.white,
          minimumSize: Size(size ?? double.infinity, 50)),
      child: isLoading
          ? const SizedBox(
              height: 30,
              width: 30,
              child: CircularProgressIndicator(
                color: Colors.white,
              ))
          : Text(
              text,
              style: TextStyle(fontSize: 18),
            ),
    );
  }
}
