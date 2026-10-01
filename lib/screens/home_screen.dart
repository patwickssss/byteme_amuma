import 'package:flutter/material.dart';

import '../data/parenting_tips.dart';
import '../models/app_feature.dart';
import '../models/care_models.dart';
import '../services/care_storage_service.dart';
import '../services/mock_auth_service.dart';
import '../services/nav_controller.dart';
import '../theme/app_colors.dart';
import '../utils/age_utils.dart';
import '../widgets/pressable_scale.dart';
import '../widgets/skeleton_box.dart';

/// Home tab (Home_Page.png): greeting, Today's Reminder, 6 feature buttons,
/// Quick Access, daily tip. Runs inside MainShell, so the bottom bar comes
/// from the shell.
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
  bool _loadingReminder = true;

  @override
  void initState() {
    super.initState();
    _loadName();
    _loadReminder();
  }

  String get _greeting {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good morning';
    if (hour < 18) return 'Good afternoon';
    return 'Good evening';
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
    setState(() => _loadingReminder = true);
    final all = await CareStorageService.loadAllReminders();
    final today =
        all.where((e) => AgeUtils.isSameDay(e.value.date, DateTime.now()));
    if (!mounted) return;
    setState(() {
      _reminderProfile = today.isNotEmpty ? today.first.key : null;
      _reminder = today.isNotEmpty ? today.first.value : null;
      _loadingReminder = false;
    });
  }

  Future<void> _refresh() async {
    await Future.wait([_loadName(), _loadReminder()]);
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
          child: RefreshIndicator(
            color: AppColors.maroon,
            onRefresh: _refresh,
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '$_greeting, $_name!',
                            style: const TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                          const Text(
                            'How can Amuma help you today?',
                            style: TextStyle(fontSize: 14, color: AppColors.maroon),
                          ),
                        ],
                      ),
                    ),
                    // Emergency stays one tap away from Home at all times,
                    // since quick access to it matters for safety.
                    Tooltip(
                      message: 'Emergency Alerts',
                      child: Semantics(
                        button: true,
                        label: 'Emergency Alerts',
                        child: InkWell(
                          borderRadius: BorderRadius.circular(24),
                          onTap: () => _open('emergency'),
                          child: Container(
                            width: 44,
                            height: 44,
                            decoration: const BoxDecoration(
                              color: Color(0xFFD64545),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.emergency_rounded,
                                color: Colors.white, size: 22),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                _reminderCard(),
                const SizedBox(height: 16),
                _tipCard(),
                const SizedBox(height: 24),
                GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 1.5,
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
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppColors.maroon),
      ),
      child: _loadingReminder
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                SkeletonBox(height: 16, width: 140),
                SizedBox(height: 12),
                SkeletonBox(height: 20, width: 160, radius: 12),
                SizedBox(height: 12),
                SkeletonBox(height: 13),
                SizedBox(height: 6),
                SkeletonBox(height: 13, width: 220),
              ],
            )
          : _reminderContent(),
    );
  }

  Widget _reminderContent() {
    final hasReminder = _reminder != null;
    final chipText = hasReminder
        ? "${_reminderProfile!.name}'s ${_reminder!.title}"
        : 'No reminders today';
    final bodyText = hasReminder
        ? 'Scheduled at ${_reminder!.time}.'
        : "You're all caught up. Add a reminder to see it here.";

    return Column(
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
          style: const TextStyle(fontSize: 13, height: 1.3, color: AppColors.maroon),
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
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: Text(
                hasReminder ? 'View Details' : 'Add a Reminder',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _tipCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.85),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.lightbulb_outline, color: AppColors.maroon, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Daily tip for parents',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: AppColors.maroon,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  ParentingTips.forToday(),
                  style: const TextStyle(fontSize: 12, height: 1.35, color: Colors.black87),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _featureButton(String id) {
    final feature = AppFeatures.byId(id);
    final isEmergency = id == 'emergency';

    return Tooltip(
      message: feature.fullName,
      child: Semantics(
        button: true,
        label: feature.fullName,
        child: PressableScale(
          child: Material(
            color: isEmergency ? const Color(0xFFD64545) : AppColors.maroon,
            borderRadius: BorderRadius.circular(14),
            clipBehavior: Clip.antiAlias,
            child: InkWell(
              onTap: () => _open(id),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: Row(
                  children: [
                    Icon(feature.icon, color: Colors.white, size: 26),
                    const SizedBox(width: 8),
                    Expanded(
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        alignment: Alignment.centerLeft,
                        child: Text(
                          feature.fullName,
                          maxLines: 2,
                          style: const TextStyle(
                            fontSize: 15,
                            height: 1.15,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
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
                    style: const TextStyle(fontSize: 12, color: AppColors.maroon),
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
