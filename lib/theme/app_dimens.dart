/// Central spacing / radius / shadow / type-scale constants.
/// Use these instead of hardcoded numbers so screens stay visually
/// consistent and easy to re-tune later.
import 'package:flutter/material.dart';

class AppSpacing {
  AppSpacing._();
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 16;
  static const double lg = 24;
  static const double xl = 32;
  static const double xxl = 48;
}

class AppRadius {
  AppRadius._();
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 22;
  static const double pill = 999;
}

class AppShadows {
  AppShadows._();

  static const List<BoxShadow> card = [
    BoxShadow(
      color: Color(0x1A000000),
      blurRadius: 10,
      offset: Offset(0, 3),
    ),
  ];

  static const List<BoxShadow> floating = [
    BoxShadow(
      color: Color(0x33000000),
      blurRadius: 6,
      offset: Offset(0, 2),
    ),
  ];
}

/// Minimum sizes so text stays legible and buttons stay tappable.
class AppA11y {
  AppA11y._();
  static const double minTouchTarget = 48;
  static const double minTextSize = 12;
}
