import 'package:flutter/material.dart';

/// How fast the person needs to act. Drives the label + icon on each card
/// (we never rely on color alone).
enum EmergencyUrgency { callNow, helpToday, support }

/// One situation the user can open, e.g. "Choking" or "Fever".
/// Content is static/mock for now (see lib/data/emergency_data.dart).
class EmergencySituation {
  final String id;
  final String title;
  final String summary;
  final IconData icon;
  final EmergencyUrgency urgency;

  /// Warning signs, or "go to hospital if" conditions.
  final List<String> warningSigns;

  /// What to do right now, in order.
  final List<String> steps;

  /// Common mistakes to avoid.
  final List<String> avoid;

  /// Optional extra hotline (e.g. a mental health crisis line).
  final String? hotlineName;
  final String? hotlineNumber;

  const EmergencySituation({
    required this.id,
    required this.title,
    required this.summary,
    required this.icon,
    required this.urgency,
    required this.warningSigns,
    required this.steps,
    required this.avoid,
    this.hotlineName,
    this.hotlineNumber,
  });
}
