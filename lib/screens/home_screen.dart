import 'package:flutter/material.dart';

import '../models/app_feature.dart';
import '../models/care_models.dart';
import '../services/care_storage_service.dart';
import '../services/mock_auth_service.dart';
import '../services/nav_controller.dart';
import '../theme/app_colors.dart';
import '../utils/age_utils.dart';
import '../widgets/pressable_scale.dart';

/// Home tab (Home_Page.png): greeting, Today's Reminder, 6 feature buttons,
/// Quick Access. Runs inside MainShell, so the bottom bar comes from the shell.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static const Color _chipColor = Color(0xFFA6607C);

  static const List<String> _featureIds = [
    'guide',
    'records',
    'bodywise',
    'planning',
    'community',
    'emergency',
  ];

  String _name = 'there';

  CareProfile? _reminderProfile;
  CareReminder? _reminder;
  bool _loadedReminder = false;

  @override
  void initState() {
    super.initState();
    _loadName();
    _loadReminder();
  }

  Future<void> _loadName() async {
    final user = await MockAuthService.getStoredAccount();
    final name = user?.profile['name'];
    if (!mounted) return;
    if (name is String && name.trim().isNotEmpty) {
      setState(() => _name = name.trim());
    }
  }

  Future<void> _loadReminder() async {
    final all = await CareStorageService.loadAllReminders();
    final today = all.where((e) => AgeUtils.isSameDay(e.value.date, DateTime.now()));
    if (!mounted) return;
    setState(() {
      if (today.isNotEmpty) {
        _reminderProfile = today.first.key;
        _reminder = today.first.value;
      }
      _loadedReminder = true;
    });
  }

  void _open(String id) => NavController.instance.open(id);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment(0.5, 0.0),
            radius: 1.1,
            colors: [Color(0xFFF6D0E5), Color(0xFFF6AEC7)],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Hello, $_name!',
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                const Text(
                  'How can Amuma help you today?',
                  style: TextStyle(fontSize: 15, color: AppColors.maroon),
                ),
                const SizedBox(height: 20),
                _reminderCard(),
                const SizedBox(height: 24),
                GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 1.65,
                  children: [
                    for (final id in _featureIds) _featureButton(id),
                  ],
                ),
                const SizedBox(height: 24),
                const Text(
                  'Quick Access',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.maroon,
                  ),
                ),
                const SizedBox(height: 10),
                _quickCard(
                  'Care Record & Reminders',
                  "Record your baby's weight for this week",
                  () => _open('records'),
                ),
                _quickCard(
                  'BodyWise',
                  'Input your record and track your menstrual cycle!',
                  () => _open('bodywise'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _reminderCard() {
    final hasReminder = _loadedReminder && _reminder != null;
    final chipText = hasReminder
        ? "${_reminderProfile!.name}'s ${_reminder!.title}"
        : 'No reminders today';
    final bodyText = hasReminder
        ? 'Scheduled at ${_reminder!.time}.'
        : "You're all caught up. Add reminders in Care Records & Reminders.";

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppColors.maroon),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Today's Reminder",
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w700,
              color: AppColors.maroon,
            ),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: _chipColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              '• $chipText',
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            bodyText,
            style: const TextStyle(
              fontSize: 13,
              height: 1.3,
              color: AppColors.maroon,
            ),
          ),
          const SizedBox(height: 10),
          Center(
            child: SizedBox(
              height: 28,
              child: ElevatedButton(
                onPressed: () => _open('records'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.maroon,
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'View Details',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _featureButton(String id) {
    final feature = AppFeatures.byId(id);
    return PressableScale(
      child: Material(
        color: AppColors.maroon,
        borderRadius: BorderRadius.circular(14),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () => _open(id),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: [
                Icon(feature.icon, color: Colors.white, size: 30),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    feature.fullName,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 15,
                      height: 1.15,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _quickCard(String title, String subtitle, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Material(
        color: Colors.white,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: const BorderSide(color: AppColors.maroon),
        ),
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: SizedBox(
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: AppColors.maroon,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 11,
                      color: AppColors.maroon,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}