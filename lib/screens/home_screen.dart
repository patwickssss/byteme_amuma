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

/// AMUMA Home tab.
///
/// The Home screen is intentionally frontend/mock focused.
/// Navigation is handled by MainShell and NavController.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static const Color _background = Color(0xFFF7D3E3);
  static const Color _backgroundSoft = Color(0xFFFCEAF2);
  static const Color _surface = Colors.white;
  static const Color _primary = Color(0xFF63263B);
  static const Color _secondary = Color(0xFFA6607C);
  static const Color _mutedText = Color(0xFF7A5664);
  static const Color _border = Color(0xFFE8CBD7);
  static const Color _emergency = Color(0xFFD64545);

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

    if (hour < 12) {
      return 'Good morning';
    }

    if (hour < 18) {
      return 'Good afternoon';
    }

    return 'Good evening';
  }

  Future<void> _loadName() async {
    final user = await MockAuthService.getStoredAccount();
    final name = user?.profile['name'];

    if (!mounted) return;

    if (name is String && name.trim().isNotEmpty) {
      setState(() {
        _name = name.trim();
      });
    }
  }

  Future<void> _loadReminder() async {
    if (mounted) {
      setState(() {
        _loadingReminder = true;
      });
    }

    final all = await CareStorageService.loadAllReminders();

    final today = all.where(
      (entry) => AgeUtils.isSameDay(
        entry.value.date,
        DateTime.now(),
      ),
    );

    if (!mounted) return;

    setState(() {
      _reminderProfile = today.isNotEmpty ? today.first.key : null;
      _reminder = today.isNotEmpty ? today.first.value : null;
      _loadingReminder = false;
    });
  }

  Future<void> _refresh() async {
    await Future.wait([
      _loadName(),
      _loadReminder(),
    ]);
  }

  void _open(String id) {
    NavController.instance.open(id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _background,
      body: SafeArea(
        bottom: false,
        child: RefreshIndicator(
          color: _primary,
          backgroundColor: Colors.white,
          onRefresh: _refresh,
          child: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  _background,
                  _backgroundSoft,
                ],
              ),
            ),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final horizontalPadding =
                    constraints.maxWidth >= 600 ? 32.0 : 20.0;

                return ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.fromLTRB(
                    horizontalPadding,
                    20,
                    horizontalPadding,
                    36,
                  ),
                  children: [
                    _buildHeader(),
                    const SizedBox(height: 22),
                    _buildReminderCard(),
                    const SizedBox(height: 16),
                    _buildDailyTip(),
                    const SizedBox(height: 28),
                    _buildSectionTitle(
                      'Explore AMUMA',
                      'Helpful tools for every step of your journey.',
                    ),
                    const SizedBox(height: 14),
                    _buildFeatureGrid(),
                    const SizedBox(height: 28),
                    _buildSectionTitle(
                      'Quick Access',
                      'Jump back into the things you use most.',
                    ),
                    const SizedBox(height: 14),
                    _buildQuickAccess(),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // HEADER
  // ---------------------------------------------------------------------------

  Widget _buildHeader() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '$_greeting, $_name!',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 27,
                  height: 1.12,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.7,
                  color: _primary,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'How can AMUMA help you today?',
                style: TextStyle(
                  fontSize: 14,
                  height: 1.4,
                  fontWeight: FontWeight.w400,
                  color: _mutedText,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 14),
        _buildHeaderAction(),
      ],
    );
  }

  Widget _buildHeaderAction() {
    return Semantics(
      button: true,
      label: 'Emergency Alerts',
      child: Tooltip(
        message: 'Emergency Alerts',
        child: Material(
          color: _surface,
          shape: const CircleBorder(),
          elevation: 0,
          child: InkWell(
            borderRadius: BorderRadius.circular(30),
            onTap: () => _open('emergency'),
            child: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: _border,
                  width: 1,
                ),
              ),
              child: const Icon(
                Icons.emergency_rounded,
                size: 22,
                color: _emergency,
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // SECTION TITLES
  // ---------------------------------------------------------------------------

  Widget _buildSectionTitle(
    String title,
    String subtitle,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 19,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.3,
            color: _primary,
          ),
        ),
        const SizedBox(height: 3),
        Text(
          subtitle,
          style: const TextStyle(
            fontSize: 12.5,
            height: 1.35,
            color: _mutedText,
          ),
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // TODAY'S REMINDER
  // ---------------------------------------------------------------------------

  Widget _buildReminderCard() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: _surface,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: _border,
          width: 1,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x12000000),
            blurRadius: 18,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: _loadingReminder
          ? _buildReminderSkeleton()
          : _buildReminderContent(),
    );
  }

  Widget _buildReminderSkeleton() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SkeletonBox(
          height: 17,
          width: 145,
        ),
        SizedBox(height: 16),
        SkeletonBox(
          height: 42,
          radius: 14,
        ),
        SizedBox(height: 12),
        SkeletonBox(
          height: 13,
          width: 250,
        ),
        SizedBox(height: 7),
        SkeletonBox(
          height: 13,
          width: 190,
        ),
      ],
    );
  }

  Widget _buildReminderContent() {
    final hasReminder =
        _reminder != null && _reminderProfile != null;

    final reminderTitle = hasReminder
        ? "${_reminderProfile!.name}'s ${_reminder!.title}"
        : 'No reminders today';

    final reminderDescription = hasReminder
        ? 'Scheduled at ${_reminder!.time}.'
        : "You're all caught up. Add a reminder to see it here.";

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: const Color(0xFFF9E7EF),
                borderRadius: BorderRadius.circular(11),
              ),
              child: const Icon(
                Icons.notifications_none_rounded,
                color: _primary,
                size: 20,
              ),
            ),
            const SizedBox(width: 11),
            const Expanded(
              child: Text(
                "Today's Reminder",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: _primary,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 12,
          ),
          decoration: BoxDecoration(
            color: hasReminder
                ? const Color(0xFFF7E8EF)
                : const Color(0xFFF9F5F7),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Row(
            children: [
              Icon(
                hasReminder
                    ? Icons.event_available_rounded
                    : Icons.check_circle_outline_rounded,
                size: 20,
                color: hasReminder ? _secondary : const Color(0xFF7C9A83),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  reminderTitle,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: _primary,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 11),
        Text(
          reminderDescription,
          style: const TextStyle(
            fontSize: 12.5,
            height: 1.45,
            color: _mutedText,
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          height: 44,
          child: ElevatedButton.icon(
            onPressed: () => _open('records'),
            icon: Icon(
              hasReminder
                  ? Icons.arrow_forward_rounded
                  : Icons.add_rounded,
              size: 18,
            ),
            label: Text(
              hasReminder ? 'View Details' : 'Add a Reminder',
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: _primary,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(13),
              ),
              textStyle: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // DAILY TIP
  // ---------------------------------------------------------------------------

  Widget _buildDailyTip() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF7FA),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFFEFD6E1),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: const Color(0xFFF5D8E5),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.lightbulb_outline_rounded,
              color: _primary,
              size: 21,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Expanded(
                      child: Text(
                        'Daily tip for parents',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w800,
                          color: _primary,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF1DFE7),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        'TIP',
                        style: TextStyle(
                          fontSize: 8,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.6,
                          color: _secondary,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                Text(
                  ParentingTips.forToday(),
                  style: const TextStyle(
                    fontSize: 12.5,
                    height: 1.45,
                    color: _mutedText,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // FEATURE GRID
  // ---------------------------------------------------------------------------

  Widget _buildFeatureGrid() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final spacing = 12.0;
        final cardWidth = (constraints.maxWidth - spacing) / 2;

        // Keep cards comfortable on wider layouts without relying on a
        // fixed width.
        final cardHeight = cardWidth < 180 ? 142.0 : 150.0;

        return Wrap(
          spacing: spacing,
          runSpacing: spacing,
          children: [
            for (final id in _featureIds)
              SizedBox(
                width: cardWidth,
                height: cardHeight,
                child: _buildFeatureCard(id),
              ),
          ],
        );
      },
    );
  }

  Widget _buildFeatureCard(String id) {
    final feature = AppFeatures.byId(id);
    final isEmergency = id == 'emergency';

    final description = _featureDescription(id);
    final icon = feature.icon;

    return Semantics(
      button: true,
      label: feature.fullName,
      child: PressableScale(
        child: Material(
          color: isEmergency ? _emergency : _primary,
          borderRadius: BorderRadius.circular(20),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: () => _open(id),
            splashColor: Colors.white.withValues(alpha: 0.10),
            highlightColor: Colors.white.withValues(alpha: 0.06),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 42,
                        height: 42,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.14),
                          borderRadius: BorderRadius.circular(13),
                        ),
                        child: Icon(
                          icon,
                          color: Colors.white,
                          size: 22,
                        ),
                      ),
                      const Spacer(),
                      Container(
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.10),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.arrow_forward_rounded,
                          color: Colors.white,
                          size: 15,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Text(
                    feature.fullName,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 14,
                      height: 1.18,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 10.5,
                      height: 1.25,
                      color: Colors.white.withValues(alpha: 0.78),
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

  String _featureDescription(String id) {
    switch (id) {
      case 'guide':
        return 'Learn about baby care and development.';

      case 'records':
        return 'Keep important care records organized.';

      case 'bodywise':
        return 'Understand your cycle and body better.';

      case 'planning':
        return 'Plan your family needs and budget.';

      case 'community':
        return 'Connect, ask questions, and share.';

      case 'emergency':
        return 'Quick access to emergency support.';

      default:
        return 'Explore this AMUMA feature.';
    }
  }

  // ---------------------------------------------------------------------------
  // QUICK ACCESS
  // ---------------------------------------------------------------------------

  Widget _buildQuickAccess() {
    return Column(
      children: [
        _buildQuickAccessCard(
          icon: Icons.monitor_weight_outlined,
          title: 'Care Record & Reminders',
          subtitle: "Record your baby's weight for this week",
          onTap: () => _open('records'),
        ),
        const SizedBox(height: 10),
        _buildQuickAccessCard(
          icon: Icons.favorite_border_rounded,
          title: 'BodyWise',
          subtitle: 'Track your cycle and keep your body records organized',
          onTap: () => _open('bodywise'),
        ),
      ],
    );
  }

  Widget _buildQuickAccessCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(17),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(17),
        splashColor: const Color(0x1463263B),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 14,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(17),
            border: Border.all(
              color: _border,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: const Color(0xFFF8E8EF),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  size: 21,
                  color: _primary,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                        color: _primary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 11,
                        height: 1.3,
                        color: _mutedText,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  color: const Color(0xFFF8E8EF),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.arrow_forward_rounded,
                  size: 16,
                  color: _primary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
