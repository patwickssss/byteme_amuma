import 'package:flutter/material.dart';

/// One destination that can live in the bottom bar or in the "More" sheet.
class AppFeature {
  final String id;
  final String label; // short label for the bar
  final String fullName; // name shown in the More sheet
  final String description; // one-line blurb shown in the More sheet
  final IconData? icon;
  final bool useLogo; // Amuma tab uses the brand mark instead of an icon
  final bool built; // false shows a "Coming soon" badge and screen

  const AppFeature(
    this.id,
    this.label,
    this.fullName,
    this.description,
    this.icon, {
    this.useLogo = false,
    this.built = true,
  });
}

class AppFeatures {
  AppFeatures._();

  static const home =
      AppFeature('home', 'Home', 'Home', 'Your daily overview', Icons.home_rounded);
  static const amuma = AppFeature(
      'amuma', 'Amuma', 'Amuma', 'Chat with your AI companion', null,
      useLogo: true);
  static const community = AppFeature('community', 'Community',
      'Parent Community', 'Ask questions, share with other parents', Icons.groups_rounded);
  static const guide = AppFeature('guide', 'Guide', 'Baby Care Guide',
      'Tips on feeding, sleep, safety and more', Icons.menu_book_rounded);
  static const records = AppFeature(
      'records',
      'Records',
      'Care Records & Reminders',
      "Track your child's growth and appointments",
      Icons.child_care_rounded);
  static const bodywise = AppFeature('bodywise', 'BodyWise', 'BodyWise',
      'Track your own health and cycle', Icons.favorite_rounded,
      built: false);
  static const planning = AppFeature(
      'planning',
      'Planning',
      'Family & Budget Planning',
      'Plan expenses for your family',
      Icons.family_restroom_rounded,
      built: false);
  static const emergency = AppFeature(
      'emergency',
      'Emergency',
      'Emergency Alerts',
      'Quick access to emergency contacts',
      Icons.add_box_rounded,
      built: false);

  static const List<AppFeature> all = [
    home,
    amuma,
    community,
    guide,
    records,
    bodywise,
    planning,
    emergency,
  ];

  /// Bar contents before the user picks anything from More (More is the 4th, fixed).
  static const List<String> defaultBar = ['home', 'amuma', 'community'];

  static AppFeature byId(String id) =>
      all.firstWhere((f) => f.id == id, orElse: () => home);
}
