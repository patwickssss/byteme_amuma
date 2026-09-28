import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Typography approximated from the Figma exports.
/// "WELCOME," uses a heavy grotesk-style weight; "we're here to help."
/// uses a lighter rounded weight. If your project has the exact Figma
/// font family, set it as the default in ThemeData and these styles
/// will inherit it automatically via fontFamily: null.
class AppTextStyles {
  AppTextStyles._();

  static const TextStyle splashLogotype = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w600,
    letterSpacing: 6,
    color: Colors.black,
  );

  static const TextStyle choiceLogotype = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    letterSpacing: 5,
    color: Colors.black,
  );

  static const TextStyle heroHeading = TextStyle(
    fontSize: 44,
    fontWeight: FontWeight.w900,
    color: AppColors.headingWhite,
    height: 1.0,
  );

  static const TextStyle heroSubtitle = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.w400,
    color: AppColors.subtitleDark,
    height: 1.15,
  );

  static const TextStyle inputText = TextStyle(
    fontSize: 17,
    fontWeight: FontWeight.w400,
    color: Colors.white,
  );

  static const TextStyle linkText = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w500,
    color: AppColors.linkWhite,
  );

  static const TextStyle buttonText = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w700,
    color: AppColors.buttonText,
  );

  static const TextStyle dividerText = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: Colors.white,
  );

  static const TextStyle footerText = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w400,
    color: AppColors.footerDark,
  );

  static const TextStyle footerLink = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w700,
    color: Colors.white,
  );

  static const TextStyle fieldError = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: Color(0xFFFFD9D6),
  );
}
