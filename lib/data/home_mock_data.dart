import 'package:flutter/material.dart';

/// MOCK: local stand-ins for data a real backend would eventually supply.
/// Nothing here is persisted or synced — it only fills the UI so Home
/// looks like a real, populated app.

class SnapshotItem {
  final String label;
  final String value;
  final IconData icon;
  final Color tint;

  const SnapshotItem({
    required this.label,
    required this.value,
    required this.icon,
    required this.tint,
  });
}

class HomeNotification {
  final String title;
  final String time;
  final IconData icon;

  const HomeNotification({
    required this.title,
    required this.time,
    required this.icon,
  });
}

class HomeMockData {
  HomeMockData._();

  // MOCK: shown only when no real child profile exists yet.
  static const List<SnapshotItem> fallbackSnapshot = [
    SnapshotItem(
      label: 'Age',
      value: 'Add a profile',
      icon: Icons.cake_outlined,
      tint: Color(0xFFFCE4EC),
    ),
    SnapshotItem(
      label: 'Next vaccine',
      value: 'Not scheduled',
      icon: Icons.vaccines_outlined,
      tint: Color(0xFFEDE6F8),
    ),
    SnapshotItem(
      label: 'Last weight',
      value: 'No record yet',
      icon: Icons.monitor_weight_outlined,
      tint: Color(0xFFE2F3EC),
    ),
  ];

  // MOCK: replace with real notifications once there's a backend to push them.
  static const List<HomeNotification> notifications = [
    HomeNotification(
      title: "Benny's check-up is coming up this week",
      time: '2h ago',
      icon: Icons.event_available_outlined,
    ),
    HomeNotification(
      title: 'New reply on your Community post',
      time: '5h ago',
      icon: Icons.chat_bubble_outline,
    ),
    HomeNotification(
      title: 'A new Baby Care Guide topic was added',
      time: 'Yesterday',
      icon: Icons.menu_book_outlined,
    ),
  ];
}