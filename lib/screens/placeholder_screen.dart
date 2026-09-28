import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../widgets/back_chip.dart';

/// Temporary screen for tabs that are built in later sections.
class PlaceholderScreen extends StatelessWidget {
  final String title;

  const PlaceholderScreen({super.key, required this.title});

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
              const BackChip(),
              Expanded(
                child: Center(
                  child: Text(
                    '$title\n(coming in a later section)',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 16,
                      color: AppColors.maroon,
                    ),
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
