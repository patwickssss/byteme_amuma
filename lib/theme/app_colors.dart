import 'package:flutter/material.dart';

/// Colors sampled directly from the Figma PNG exports (Splash / Login).
/// The background is a soft pink-magenta mesh gradient with a subtle
/// fabric-like texture — approximated here with a 3-stop linear gradient
/// since the exact mesh isn't reproducible from a flat color sample.
class AppColors {
  AppColors._();

  static const Color gradientTop = Color(0xFFD478C9);
  static const Color gradientMid = Color(0xFFDD84AE);
  static const Color gradientBottom = Color(0xFFED85B8);
  /// Soft supporting tints for the Home redesign — used behind icons and
  /// as section backgrounds, never replacing the maroon/pink brand colors.
  static const Color cream = Color(0xFFFBF4EF);
  static const Color blush = Color(0xFFFCE4EC);
  static const Color peach = Color(0xFFFFE9DC);
  static const Color lavender = Color(0xFFEDE6F8);
  static const Color mint = Color(0xFFE2F3EC);
  static const Color coral = Color(0xFFC9473A);

  static const Color pinkDark = Color(0xFFC2185B);      // pink text that passes contrast
  static const Color emergencyRed = Color(0xFFC62828);  // emergency actions only

  static const Color textDark = Color(0xFF2E2230);
  static const Color textMuted = Color(0xFF7A6B75);

  static const LinearGradient backgroundGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [gradientTop, gradientMid, gradientBottom],
    stops: [0.0, 0.5, 1.0],
  );

  /// Translucent input field fill (pink glass effect over the gradient).
  static const Color inputFill = Color(0x33FFFFFF);
  static const Color inputBorder = Color(0x59FFFFFF);
  static const Color inputHintText = Color(0xE6FFFFFF);

  /// Light gray primary button (Login / Sign Up).
  static const Color buttonFill = Color(0xFFD9D9D9);
  static const Color buttonText = Color(0xFF1A1A1A);

  static const Color headingWhite = Color(0xFFFFFFFF);
  static const Color subtitleDark = Color(0xFF241B24);
  static const Color linkWhite = Color(0xFFFFFFFF);
  static const Color footerDark = Color(0xFF241B24);

  /// Pink text on the white Yes / No buttons (Account Setup screen).
  static const Color setupChoiceText = Color(0xFFFF8AAE);

  static const Color errorRed = Color(0xFFB3261E);
  static const Color errorFieldBorder = Color(0xFFE57373);

  /// Maroon + pink from the Home / Care Records designs.
  static const Color maroon = Color(0xFF63263B);
  static const Color pink = Color(0xFFFB77B0);
}
