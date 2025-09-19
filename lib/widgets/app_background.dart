import 'package:flutter/material.dart';

class AppBackground extends StatelessWidget {
  final Widget child;

  const AppBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF0D47A1),
            Color(0xFF1976D2),
            Color(0xFF42A5F5),
          ],
        ),
      ),
      child: child,
    );
  }
}

import 'package:flutter/material.dart';

class AppBackground extends StatelessWidget {
  final Widget child;
  final List<Color> colors;
  final String? imageAsset;
  final double overlayOpacity;

  const AppBackground({
    super.key,
    required this.child,
    this.colors = const [
      Color(0xFF0F2027),
      Color(0xFF203A43),
      Color(0xFF2C5364),
    ],
    this.imageAsset,
    this.overlayOpacity = 0.35,
  });

  @override
  Widget build(BuildContext context) {
    if (imageAsset == null) {
      return Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: colors,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: child,
      );
    }

    return Stack(
      fit: StackFit.expand,
      children: [
        Image.asset(
          imageAsset!,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: colors,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            );
          },
        ),
        Container(color: Colors.black.withOpacity(overlayOpacity)),
        child,
      ],
    );
  }
}
