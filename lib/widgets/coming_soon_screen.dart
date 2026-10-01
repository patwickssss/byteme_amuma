import 'package:flutter/material.dart';

import '../models/app_feature.dart';
import '../services/nav_controller.dart';
import '../theme/app_colors.dart';
import '../widgets/back_chip.dart';

/// Shown for any main-shell tab that isn't built yet (BodyWise, Family &
/// Budget Planning, Emergency Alerts). Friendlier than a dev placeholder.
class ComingSoonScreen extends StatelessWidget {
  final AppFeature feature;

  const ComingSoonScreen({super.key, required this.feature});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BackChip(onTap: () => NavController.instance.open('home')),
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 96,
                        height: 96,
                        decoration: BoxDecoration(
                          color: AppColors.pink.withValues(alpha: 0.12),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(feature.icon,
                            size: 42, color: AppColors.maroon),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        '${feature.fullName} is coming soon',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: AppColors.maroon,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Text(
                          "We're still building this part of AMUMA. "
                          'Check back in a future update.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.black.withValues(alpha: 0.6),
                            height: 1.4,
                          ),
                        ),
                      ),
                      const SizedBox(height: 28),
                      OutlinedButton(
                        onPressed: () => NavController.instance.open('home'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.maroon,
                          side: const BorderSide(color: AppColors.maroon),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 28, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text('Back to Home'),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
