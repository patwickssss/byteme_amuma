import 'package:flutter/material.dart';

import '../models/emergency_situation.dart';
import '../theme/app_colors.dart';
import '../widgets/amuma_bottom_bar.dart';
import '../widgets/back_chip.dart';
import '../widgets/emergency_call_dialog.dart';
import '../widgets/pressable_scale.dart';

const Color _bodyText = Color(0xFF333333);

/// Pushed from the Emergency screen. Lists the situations for either
/// "My Baby / Child" or "Me / Myself".
class EmergencyCategoryScreen extends StatelessWidget {
  final String title;
  final String subtitle;
  final List<EmergencySituation> situations;

  const EmergencyCategoryScreen({
    super.key,
    required this.title,
    required this.subtitle,
    required this.situations,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: const AmumaBottomBar(),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
          children: [
            const Align(alignment: Alignment.centerLeft, child: BackChip()),
            const SizedBox(height: 20),
            Text(
              title,
              style: const TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w800,
                color: AppColors.maroon,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: const TextStyle(fontSize: 15, color: _bodyText),
            ),
            const SizedBox(height: 16),
            _FirstRule(),
            const SizedBox(height: 16),
            for (final s in situations) ...[
              _SituationCard(situation: s),
              const SizedBox(height: 12),
            ],
            const SizedBox(height: 4),
            const _Disclaimer(),
          ],
        ),
      ),
    );
  }
}

/// Always-visible reminder at the top of the list.
class _FirstRule extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFFDECEC),
        borderRadius: BorderRadius.circular(14),
      ),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.info_outline_rounded,
              color: AppColors.emergencyRed, size: 22),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              'Not breathing, not responding, or bleeding heavily? '
              'Call 911 first, then read the steps.',
              style: TextStyle(fontSize: 14, height: 1.35, color: _bodyText),
            ),
          ),
        ],
      ),
    );
  }
}

class _Disclaimer extends StatelessWidget {
  const _Disclaimer();

  @override
  Widget build(BuildContext context) {
    return const Text(
      'AI guidance and this content are not a replacement for emergency '
      'medical care.',
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 13,
        fontStyle: FontStyle.italic,
        fontWeight: FontWeight.w600,
        color: AppColors.maroon,
      ),
    );
  }
}

/// Label + icon for each urgency level (not color only).
class _UrgencyStyle {
  final String label;
  final IconData icon;
  final Color background;
  final Color foreground;

  const _UrgencyStyle(this.label, this.icon, this.background, this.foreground);

  static _UrgencyStyle of(EmergencyUrgency u) {
    switch (u) {
      case EmergencyUrgency.callNow:
        return const _UrgencyStyle('Call 911 now', Icons.phone_rounded,
            Color(0xFFFDECEC), AppColors.emergencyRed);
      case EmergencyUrgency.helpToday:
        return const _UrgencyStyle('Get medical help today',
            Icons.medical_services_rounded, Color(0xFFFFF3E0), Color(0xFF8A4B00));
      case EmergencyUrgency.support:
        return const _UrgencyStyle('Reach out for support now',
            Icons.favorite_rounded, Color(0xFFFCE4EF), AppColors.pinkDark);
    }
  }
}

class _UrgencyChip extends StatelessWidget {
  final EmergencyUrgency urgency;
  const _UrgencyChip(this.urgency);

  @override
  Widget build(BuildContext context) {
    final style = _UrgencyStyle.of(urgency);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: style.background,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(style.icon, size: 14, color: style.foreground),
          const SizedBox(width: 5),
          Text(
            style.label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: style.foreground,
            ),
          ),
        ],
      ),
    );
  }
}

class _SituationCard extends StatelessWidget {
  final EmergencySituation situation;
  const _SituationCard({required this.situation});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: '${situation.title}. ${situation.summary}. '
          '${_UrgencyStyle.of(situation.urgency).label}',
      child: ExcludeSemantics(
        child: PressableScale(
          child: Material(
            color: Colors.white,
            elevation: 1.5,
            shadowColor: AppColors.pink.withValues(alpha: 0.4),
            clipBehavior: Clip.antiAlias,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: const BorderSide(color: AppColors.pink, width: 1),
            ),
            child: InkWell(
              onTap: () => showSituationSheet(context, situation),
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Row(
                  children: [
                    Container(
                      width: 52,
                      height: 52,
                      decoration: const BoxDecoration(
                        color: Color(0xFFFCE4EF),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(situation.icon,
                          color: AppColors.pinkDark, size: 26),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            situation.title,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                              color: AppColors.maroon,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            situation.summary,
                            style: const TextStyle(
                                fontSize: 13, color: _bodyText),
                          ),
                          const SizedBox(height: 8),
                          _UrgencyChip(situation.urgency),
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

String _warningTitle(EmergencyUrgency u) {
  switch (u) {
    case EmergencyUrgency.callNow:
      return 'Warning signs';
    case EmergencyUrgency.helpToday:
      return 'Go to a hospital or call 911 if';
    case EmergencyUrgency.support:
      return 'Reach out now if';
  }
}

/// Bottom sheet with the full guidance for one situation.
void showSituationSheet(BuildContext context, EmergencySituation s) {
  showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (sheetContext) => DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.88,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (_, controller) => ListView(
        controller: controller,
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: const Color(0xFFE0E0E0),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            s.title,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w800,
              color: AppColors.maroon,
            ),
          ),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerLeft,
            child: _UrgencyChip(s.urgency),
          ),
          const SizedBox(height: 16),

          // Most important action first.
          if (s.urgency == EmergencyUrgency.callNow)
            _SheetButton(
              label: 'Call 911',
              icon: Icons.phone_rounded,
              color: AppColors.emergencyRed,
              onTap: () => confirmEmergencyCall(sheetContext),
            ),
          if (s.hotlineNumber != null) ...[
            _SheetButton(
              label: 'Call ${s.hotlineName} (${s.hotlineNumber})',
              icon: Icons.phone_in_talk_rounded,
              color: AppColors.maroon,
              onTap: () => confirmEmergencyCall(
                sheetContext,
                number: s.hotlineNumber!,
                label: s.hotlineName!,
              ),
            ),
          ],

          _SectionTitle(_warningTitle(s.urgency)),
          for (final text in s.warningSigns)
            _BulletRow(
              icon: Icons.error_outline_rounded,
              color: AppColors.emergencyRed,
              text: text,
            ),

          const _SectionTitle('What to do now'),
          for (var i = 0; i < s.steps.length; i++)
            _StepRow(number: i + 1, text: s.steps[i]),

          const _SectionTitle('Avoid'),
          for (final text in s.avoid)
            _BulletRow(
              icon: Icons.block_rounded,
              color: AppColors.maroon,
              text: text,
            ),

          if (s.urgency != EmergencyUrgency.callNow) ...[
            const SizedBox(height: 20),
            _SheetButton(
              label: 'Call 911',
              icon: Icons.phone_rounded,
              color: AppColors.emergencyRed,
              onTap: () => confirmEmergencyCall(sheetContext),
            ),
          ],
          const SizedBox(height: 16),
          const _Disclaimer(),
        ],
      ),
    ),
  );
}

class _SheetButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _SheetButton({
    required this.label,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: PressableScale(
        child: SizedBox(
          width: double.infinity,
          height: 54,
          child: FilledButton.icon(
            style: FilledButton.styleFrom(
              backgroundColor: color,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            onPressed: onTap,
            icon: Icon(icon, size: 22),
            label: Text(
              label,
              style:
                  const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
            ),
          ),
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String text;
  const _SectionTitle(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 22, bottom: 10),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.w800,
          color: AppColors.maroon,
        ),
      ),
    );
  }
}

class _BulletRow extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String text;

  const _BulletRow({
    required this.icon,
    required this.color,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: color),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                  fontSize: 15, height: 1.4, color: _bodyText),
            ),
          ),
        ],
      ),
    );
  }
}

class _StepRow extends StatelessWidget {
  final int number;
  final String text;

  const _StepRow({required this.number, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 26,
            height: 26,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              color: AppColors.maroon,
              shape: BoxShape.circle,
            ),
            child: Text(
              '$number',
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 2),
              child: Text(
                text,
                style: const TextStyle(
                    fontSize: 15, height: 1.4, color: _bodyText),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
