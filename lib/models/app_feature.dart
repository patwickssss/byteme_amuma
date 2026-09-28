import 'package:flutter/material.dart';

/// One destination that can live in the bottom bar or in the "More" sheet.
class AppFeature {
  final String id;
  final String label; // short label for the bar
  final String fullName; // name shown in the More sheet
  final IconData? icon;
  final bool useLogo; // Amuma tab uses the brand mark instead of an icon

  const AppFeature(
    this.id,
    this.label,
    this.fullName,
    this.icon, {
    this.useLogo = false,
  });
}

class AppFeatures {
  AppFeatures._();

  static const home = AppFeature('home', 'Home', 'Home', Icons.home_rounded);
  static const amuma =
      AppFeature('amuma', 'Amuma', 'Amuma', null, useLogo: true);
  static const community = AppFeature(
      'community', 'Community', 'Parent Community', Icons.groups_rounded);
  static const guide = AppFeature(
      'guide', 'Guide', 'Baby Care Guide', Icons.menu_book_rounded);
  static const records = AppFeature('records', 'Records',
      'Care Records & Reminders', Icons.child_care_rounded);
  static const bodywise = AppFeature(
      'bodywise', 'BodyWise', 'BodyWise', Icons.favorite_rounded);
  static const planning = AppFeature('planning', 'Planning',
      'Family & Budget Planning', Icons.family_restroom_rounded);
  static const emergency = AppFeature(
      'emergency', 'Emergency', 'Emergency Alerts', Icons.add_box_rounded);

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
