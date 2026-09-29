import 'package:flutter/material.dart';

/// Empty rounded placeholder standing in for a real photo/illustration.
/// Same size/shape/border everywhere so swapping in real images later
/// is a one-line change per call site.
class BlankImageBox extends StatelessWidget {
  final double? width;
  final double height;
  final double radius;
  final Color borderColor;

  const BlankImageBox({
    super.key,
    this.width,
    this.height = 190,
    this.radius = 16,
    this.borderColor = const Color(0xFFB98A5A),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: const Color(0xFFF2E2D0),
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(color: borderColor, width: 2),
      ),
    );
  }
}
