import 'package:flutter/material.dart';

import '../models/app_feature.dart';
import '../services/nav_controller.dart';
import '../widgets/amuma_bottom_bar.dart';
import 'home_screen.dart';
import 'placeholder_screen.dart';
import 'amuma_screen.dart';
import 'baby_care_guide_screen.dart';
import 'care_records_screen.dart';
import 'community_screen.dart';

/// Hosts the active main screen above the shared bottom bar.
class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  @override
  void initState() {
    super.initState();
    NavController.instance.resetActive();
  }

  Widget _screenFor(String id) {
    switch (id) {
      case 'home':
        return const HomeScreen();
      case 'amuma':
        return const AmumaScreen();
      case 'guide':
        return const BabyCareGuideScreen();
      case 'records':
        return const CareRecordsScreen();
      case 'community':
        return const CommunityScreen();
      default:
        // Replaced one by one in the next sections.
        return PlaceholderScreen(title: AppFeatures.byId(id).fullName);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: NavController.instance,
      builder: (context, _) {
        return Scaffold(
          backgroundColor: Colors.white,
          body: _screenFor(NavController.instance.activeId),
          bottomNavigationBar: const AmumaBottomBar(),
        );
      },
    );
  }
}
