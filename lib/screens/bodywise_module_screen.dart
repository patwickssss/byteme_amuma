import 'package:flutter/material.dart';

import '../data/bodywise_data.dart';
import '../services/nav_controller.dart';
import '../theme/app_colors.dart';
import '../widgets/back_chip.dart';

/// One BodyWise module: hero, quick takeaways, sections, "when to get help".
/// A thin progress bar under the Back button shows how far you have read.
class BodyWiseModuleScreen extends StatefulWidget {
  final BodyWiseModule module;

  const BodyWiseModuleScreen({super.key, required this.module});

  @override
  State<BodyWiseModuleScreen> createState() => _BodyWiseModuleScreenState();
}

class _BodyWiseModuleScreenState extends State<BodyWiseModuleScreen> {
  static const Color _bodyText = Color(0xFF3A3A3A);
  static const Color _helpDark = Color(0xFF9E2F24);

  final ScrollController _scroll = ScrollController();
  final ValueNotifier<double> _progress = ValueNotifier<double>(0);

  @override
  void initState() {
    super.initState();
    _scroll.addListener(_onScroll);
  }

  void _onScroll() {
    if (!_scroll.hasClients) return;
    final max = _scroll.position.maxScrollExtent;
    _progress.value =
        max <= 0 ? 1 : (_scroll.offset / max).clamp(0.0, 1.0).toDouble();
  }

  @override
  void dispose() {
    _scroll.dispose();
    _progress.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final m = widget.module;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(16, 12, 16, 10),
              child: Align(
                alignment: Alignment.centerLeft,
                child: BackChip(),
              ),
            ),
            ValueListenableBuilder<double>(
              valueListenable: _progress,
              builder: (context, value, _) => LinearProgressIndicator(
                value: value,
                minHeight: 3,
                color: AppColors.pink,
                backgroundColor: const Color(0xFFFCE4EC),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                controller: _scroll,
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _hero(m),
                    const SizedBox(height: 16),
                    _takeaways(m),
                    for (final s in m.sections) _section(s),
                    const SizedBox(height: 28),
                    _helpCard(m),
                    const SizedBox(height: 20),
                    _askAmumaButton(),
                    const SizedBox(height: 16),
                    const Text(
                      'For education only. This does not replace advice from a '
                      'doctor, midwife, or health worker.',
                      style: TextStyle(
                          fontSize: 12, height: 1.4, color: Colors.black54),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _hero(BodyWiseModule m) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: m.tint,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: Icon(m.icon, color: AppColors.maroon, size: 26),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Wrap(
                  spacing: 10,
                  runSpacing: 4,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Text(
                      m.category.toUpperCase(),
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1,
                        color: AppColors.maroon,
                      ),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.schedule_rounded,
                            size: 14, color: AppColors.maroon),
                        const SizedBox(width: 4),
                        Text(
                          '${m.readMinutes} min read',
                          style: const TextStyle(
                              fontSize: 12, color: AppColors.maroon),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            m.title,
            style: const TextStyle(
              fontSize: 24,
              height: 1.2,
              fontWeight: FontWeight.w800,
              color: AppColors.maroon,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            m.summary,
            style: const TextStyle(
                fontSize: 14, height: 1.4, color: _bodyText),
          ),
        ],
      ),
    );
  }

  Widget _takeaways(BodyWiseModule m) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFF0C4D4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.tips_and_updates_outlined,
                  color: AppColors.maroon, size: 22),
              SizedBox(width: 8),
              Text(
                'Quick takeaways',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: AppColors.maroon,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          for (final p in m.keyPoints)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 2),
                    child: Icon(Icons.check_circle_outline_rounded,
                        size: 18, color: AppColors.maroon),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(p,
                        style: const TextStyle(
                            fontSize: 14, height: 1.4, color: _bodyText)),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _section(BodyWiseSection s) {
    return Padding(
      padding: const EdgeInsets.only(top: 26),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            s.title,
            style: const TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.w800,
              color: AppColors.maroon,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            s.body,
            style:
                const TextStyle(fontSize: 14, height: 1.5, color: _bodyText),
          ),
          if (s.points.isNotEmpty) const SizedBox(height: 10),
          for (final p in s.points)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 7),
                    child: Container(
                      width: 7,
                      height: 7,
                      decoration: const BoxDecoration(
                        color: AppColors.pink,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(p,
                        style: const TextStyle(
                            fontSize: 14, height: 1.45, color: _bodyText)),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _helpCard(BodyWiseModule m) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFFFFEFEA),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFF3C9C0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.local_hospital_outlined, color: _helpDark, size: 22),
              SizedBox(width: 8),
              Text(
                'When to get help',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: _helpDark,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          for (final p in m.getHelpWhen)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 2),
                    child: Icon(Icons.arrow_right_rounded,
                        size: 20, color: _helpDark),
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(p,
                        style: const TextStyle(
                            fontSize: 14, height: 1.4, color: _bodyText)),
                  ),
                ],
              ),
            ),
          const Divider(height: 20, color: Color(0xFFF3C9C0)),
          const Text(
            'In an emergency, go to the nearest hospital or call 911.',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: _helpDark,
            ),
          ),
        ],
      ),
    );
  }

  Widget _askAmumaButton() {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: FilledButton.icon(
        onPressed: () {
          NavController.instance.open('amuma');
          Navigator.of(context).popUntil((r) => r.isFirst);
        },
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.maroon,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        icon: const Icon(Icons.chat_bubble_outline_rounded, size: 20),
        label: const Text(
          'Ask Amuma a question',
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
        ),
      ),
    );
  }
}
