import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// Pink gradient + faint floral overlay, shared by all auth/onboarding screens.
class GradientBackground extends StatelessWidget {
  final Widget child;

  const GradientBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(
        gradient: AppColors.backgroundGradient,
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset('assets/images/setup_bg.png', fit: BoxFit.cover),
          child,
        ],
      ),
    );
  }
}