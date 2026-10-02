import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../data/emergency_data.dart';
import '../theme/app_colors.dart';

/// Asks "Call X?" before dialing, so nobody calls by accidental tap.
/// MOCK: it does not dial. See the TODO for the real version.
Future<void> confirmEmergencyCall(
  BuildContext context, {
  String number = EmergencyData.emergencyNumber,
  String label = 'Emergency Services',
}) async {
  HapticFeedback.mediumImpact();

  final confirmed = await showDialog<bool>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      icon: const Icon(
        Icons.phone_in_talk_rounded,
        size: 36,
        color: AppColors.emergencyRed,
      ),
      title: Text(
        'Call $label?',
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontWeight: FontWeight.w800,
          color: AppColors.maroon,
        ),
      ),
      content: Text(
        'This will dial $number.',
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 15, color: Color(0xFF333333)),
      ),
      actionsAlignment: MainAxisAlignment.center,
      actions: [
        TextButton(
          style: TextButton.styleFrom(minimumSize: const Size(100, 48)),
          onPressed: () => Navigator.of(dialogContext).pop(false),
          child: const Text(
            'Cancel',
            style: TextStyle(color: AppColors.maroon, fontSize: 15),
          ),
        ),
        FilledButton(
          style: FilledButton.styleFrom(
            backgroundColor: AppColors.emergencyRed,
            minimumSize: const Size(120, 48),
          ),
          onPressed: () => Navigator.of(dialogContext).pop(true),
          child: Text('Call $number', style: const TextStyle(fontSize: 15)),
        ),
      ],
    ),
  );

  if (confirmed != true || !context.mounted) return;

  // TODO(later): really dial. Add the url_launcher package, then:
  //   await launchUrl(Uri(scheme: 'tel', path: number));
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text('Demo only: this would dial $number now.')),
  );
}
