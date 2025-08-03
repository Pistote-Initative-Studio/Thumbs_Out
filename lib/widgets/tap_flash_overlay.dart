import 'package:flutter/material.dart';

class TapFlashOverlay extends StatelessWidget {
  final bool active;
  final Color color;
  final Alignment alignment;

  const TapFlashOverlay({
    super.key,
    required this.active,
    required this.color,
    required this.alignment,
  });

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: AnimatedOpacity(
        opacity: active ? 1 : 0,
        duration: const Duration(milliseconds: 300),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: alignment,
              end: Alignment.center,
              colors: [
                color.withOpacity(0.6),
                color.withOpacity(0.0),
              ],
              stops: const [0.0, 0.15],
            ),
          ),
        ),
      ),
    );
  }
}
