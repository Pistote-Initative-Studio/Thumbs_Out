import 'package:flutter/material.dart';

class CountdownOverlay extends StatelessWidget {
  final String text;
  const CountdownOverlay({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        color: Colors.black54,
        alignment: Alignment.center,
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 64,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
