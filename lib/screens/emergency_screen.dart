import 'package:flutter/material.dart';

import '../data/emergency_data.dart';
import '../models/emergency_situation.dart';
import '../theme/app_colors.dart';
import '../utils/app_routes.dart';
import '../widgets/back_chip.dart';
import '../widgets/emergency_call_dialog.dart';
import '../widgets/pressable_scale.dart';
import 'emergency_category_screen.dart';

const Color _bodyText = Color(0xFF333333);

/// Emergency tab (EMERGENCY_HELP.png). Runs inside MainShell, so the bottom
/// bar comes from the shell. All content is mock/static for now.
class EmergencyScreen extends StatelessWidget {
  const EmergencyScreen({super.key});

  void _openCategory(
    BuildContext context, {
    required String title,
    required String subtitle,
    required List<EmergencySituation> situations,
  }) {
    Navigator.of(context).push(
      fadeScaleRoute(
        EmergencyCategoryScreen(
          title: title,
          subtitle: subtitle,
          situations: situations,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: TweenAnimationBuilder<double>(
                tween: Tween(begin: 0, end: 1),
                duration: const Duration(milliseconds: 400),
                curve: Curves.easeOut,
                builder: (context, t, child) => Opacity(
                  opacity: t,
                  child: Transform.translate(
                    offset: Offset(0, (1 - t) * 12),
                    child: child,
                  ),
                ),
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
                  children: [
                    const Align(
                        alignment: Alignment.centerLeft, child: BackChip()),
                    const SizedBox(height: 12),
                    const Center(
                      child: Text(
                        'EMERGENCY HELP',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w900,
                          color: AppColors.maroon,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'ARE YOU ALRIGHT?',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                        color: AppColors.pinkDark,
                      ),
                    ),
                    const Text(
                      'What do you need help with?',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: AppColors.maroon,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _CategoryCard(
                      icon: Icons.child_care_rounded,
                      title: 'My Baby / Child',
                      subtitle:
                          'Choking, fever, breathing trouble, injuries and more.',
                      onTap: () => _openCategory(
                        context,
                        title: 'My Baby / Child',
                        subtitle: 'Choose what is happening.',
                        situations: EmergencyData.child,
                      ),
                    ),
                    const SizedBox(height: 14),
                    _CategoryCard(
                      icon: Icons.pregnant_woman_rounded,
                      title: 'Me / Myself',
                      subtitle:
                          'Heavy bleeding, severe pain, feeling overwhelmed and more.',
                      onTap: () => _openCategory(
                        context,
                        title: 'Me / Myself',
                        subtitle: 'Choose what is happening.',
                        situations: EmergencyData.parent,
                      ),
                    ),
                    const SizedBox(height: 28),
                    const _SectionDivider(label: 'Quick Actions'),
                    const SizedBox(height: 16),
                    _CallButton(
                      onTap: () => confirmEmergencyCall(context),
                    ),
                    const SizedBox(height: 10),
                    _QuickActionTile(
                      icon: Icons.medical_services_rounded,
                      label: 'Contact My Doctor',
                      showPro: true,
                      onTap: () => _showDoctorSheet(context),
                    ),
                    const SizedBox(height: 10),
                    _QuickActionTile(
                      icon: Icons.local_hospital_rounded,
                      label: 'Find Nearby Hospital',
                      onTap: () => _showHospitalSheet(context),
                    ),
                  ],
                ),
              ),
            ),
            const _PinnedDisclaimer(),
          ],
        ),
      ),
    );
  }
}

class _CategoryCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _CategoryCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: '$title. $subtitle',
      child: ExcludeSemantics(
        child: PressableScale(
          child: Material(
            color: Colors.white,
            elevation: 2,
            shadowColor: AppColors.pink.withValues(alpha: 0.45),
            clipBehavior: Clip.antiAlias,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: const BorderSide(color: AppColors.pink, width: 1.2),
            ),
            child: InkWell(
              onTap: onTap,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Container(
                      width: 68,
                      height: 68,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: const Color(0xFFFCE4EF),
                        border:
                            Border.all(color: AppColors.pink, width: 1.2),
                      ),
                      // Swap for Image.asset(...) once you export the
                      // illustrations from Figma.
                      child: Icon(icon, size: 36, color: AppColors.maroon),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w800,
                              color: AppColors.pinkDark,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            subtitle,
                            style: const TextStyle(
                              fontSize: 13,
                              height: 1.35,
                              color: _bodyText,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Icon(Icons.chevron_right_rounded,
                        color: AppColors.pinkDark),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SectionDivider extends StatelessWidget {
  final String label;
  const _SectionDivider({required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(child: Divider(color: AppColors.pink, thickness: 1.2)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w800,
              color: AppColors.maroon,
            ),
          ),
        ),
        const Expanded(child: Divider(color: AppColors.pink, thickness: 1.2)),
      ],
    );
  }
}

/// The most important quick action gets the strongest visual weight.
class _CallButton extends StatelessWidget {
  final VoidCallback onTap;
  const _CallButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: 'Call Emergency Services, 911',
      child: ExcludeSemantics(
        child: PressableScale(
          child: Material(
            color: AppColors.emergencyRed,
            borderRadius: BorderRadius.circular(16),
            elevation: 3,
            shadowColor: AppColors.emergencyRed.withValues(alpha: 0.4),
            clipBehavior: Clip.antiAlias,
            child: InkWell(
              onTap: onTap,
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 22,
                      backgroundColor: Colors.white,
                      child: Icon(Icons.phone_rounded,
                          color: AppColors.emergencyRed, size: 24),
                    ),
                    SizedBox(width: 14),
                    Expanded(
                      child: Text(
                        'Call Emergency Services',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Text(
                      '911',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
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
}

class _QuickActionTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool showPro;
  final VoidCallback onTap;

  const _QuickActionTile({
    required this.icon,
    required this.label,
    required this.onTap,
    this.showPro = false,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: showPro ? '$label, PRO feature' : label,
      child: ExcludeSemantics(
        child: PressableScale(
          child: Material(
            color: Colors.white,
            clipBehavior: Clip.antiAlias,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
              side: const BorderSide(color: Color(0xFFF3C6D8)),
            ),
            child: InkWell(
              onTap: onTap,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundColor: const Color(0xFFF3A6C4),
                      child: Icon(icon, color: AppColors.maroon, size: 22),
                    ),
                    const SizedBox(width: 14),
                    Flexible(
                      child: Text(
                        label,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: _bodyText,
                        ),
                      ),
                    ),
                    if (showPro) ...[
                      const SizedBox(width: 8),
                      const _ProBadge(),
                    ],
                    const Spacer(),
                    const Icon(Icons.chevron_right_rounded,
                        color: AppColors.pinkDark),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ProBadge extends StatelessWidget {
  const _ProBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: const Color(0xFFFCE4EF),
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Text(
        'PRO',
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w800,
          fontStyle: FontStyle.italic,
          color: AppColors.pinkDark,
        ),
      ),
    );
  }
}

class _PinnedDisclaimer extends StatelessWidget {
  const _PinnedDisclaimer();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(24, 10, 24, 12),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: AppColors.pink)),
      ),
      child: const Text(
        'AI guidance is not a replacement for emergency medical care.',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 13,
          height: 1.3,
          fontStyle: FontStyle.italic,
          fontWeight: FontWeight.w700,
          color: AppColors.maroon,
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// MOCK bottom sheets for the two quick actions that need a real backend.
// ---------------------------------------------------------------------------

void _showDoctorSheet(BuildContext context) {
  showModalBottomSheet<void>(
    context: context,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (sheetContext) => SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 24, 24, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircleAvatar(
              radius: 30,
              backgroundColor: Color(0xFFFCE4EF),
              child: Icon(Icons.workspace_premium_rounded,
                  size: 32, color: AppColors.pinkDark),
            ),
            const SizedBox(height: 14),
            const Text(
              'Contact My Doctor is a PRO feature',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.w800,
                color: AppColors.maroon,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'With PRO you can save your doctor and reach them in one tap. '
              'This is a preview only. Nothing is charged.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, height: 1.4, color: _bodyText),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: FilledButton(
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.maroon,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                onPressed: () => Navigator.of(sheetContext).pop(),
                child: const Text('Got it',
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

void _showHospitalSheet(BuildContext context) {
  // Sample data only. A real version needs location permission + a maps or
  // places API, which we are skipping at this stage.
  const sample = [
    ('Sample Hospital A', '2.1 km away', 'Open 24 hours'),
    ('Sample Health Center B', '3.4 km away', 'Open until 5:00 PM'),
    ('Sample Hospital C', '5.8 km away', 'Open 24 hours'),
  ];

  showModalBottomSheet<void>(
    context: context,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (sheetContext) => SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Nearby hospitals',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: AppColors.maroon,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Sample data for the demo. Real nearby search comes later.',
              style: TextStyle(fontSize: 13, color: _bodyText),
            ),
            const SizedBox(height: 12),
            for (final h in sample)
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const CircleAvatar(
                  backgroundColor: Color(0xFFF3A6C4),
                  child: Icon(Icons.local_hospital_rounded,
                      color: AppColors.maroon),
                ),
                title: Text(h.$1,
                    style: const TextStyle(
                        fontWeight: FontWeight.w700, color: _bodyText)),
                subtitle: Text('${h.$2} · ${h.$3}'),
                trailing: const Icon(Icons.directions_rounded,
                    color: AppColors.pinkDark),
                onTap: () {
                  Navigator.of(sheetContext).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text('Demo only: directions to ${h.$1}.')),
                  );
                },
              ),
          ],
        ),
      ),
    ),
  );
}
