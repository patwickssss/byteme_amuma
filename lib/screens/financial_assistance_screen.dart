import 'package:flutter/material.dart';

import '../data/planning_data.dart';
import '../theme/app_colors.dart';
import '../widgets/planning/plan_widgets.dart';

/// Browse Philippine assistance programs (MOCK content, general terms only).
/// Tap a card to expand it. Filter by type with the chips.
class FinancialAssistanceScreen extends StatefulWidget {
  const FinancialAssistanceScreen({super.key});

  @override
  State<FinancialAssistanceScreen> createState() =>
      _FinancialAssistanceScreenState();
}

class _FinancialAssistanceScreenState extends State<FinancialAssistanceScreen> {
  String _tag = 'All';
  final Set<String> _expanded = {};

  List<AssistanceProgram> get _filtered => PlanningData.programs
      .where((p) => _tag == 'All' || p.tag == _tag)
      .toList();

  @override
  Widget build(BuildContext context) {
    final programs = _filtered;

    return PlanScaffold(
      title: 'FINANCIAL ASSISTANCE',
      child: ListView(
        padding: const EdgeInsets.only(bottom: 24),
        children: [
          PlanCard(
            color: PlanColors.overBg,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.info_outline_rounded,
                    color: PlanColors.overText, size: 22),
                const SizedBox(width: 10),
                const Expanded(
                  child: Text(
                    'Requirements and amounts change. Confirm with the agency '
                    'or your city or municipal social welfare office before you apply.',
                    style: TextStyle(
                        fontSize: 13, height: 1.4, color: PlanColors.text),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final t in PlanningData.programTags) _tagChip(t),
            ],
          ),
          const SizedBox(height: 16),
          for (final p in programs) _programCard(p),
        ],
      ),
    );
  }

  Widget _tagChip(String label) {
    final active = label == _tag;
    return Semantics(
      button: true,
      selected: active,
      child: GestureDetector(
        onTap: () => setState(() => _tag = label),
        child: Container(
          constraints: const BoxConstraints(minHeight: 40),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: active ? AppColors.pink : Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: active ? AppColors.pink : const Color(0xFFE3B7C8),
            ),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: active ? Colors.white : const Color(0xFFC4849C),
            ),
          ),
        ),
      ),
    );
  }

  Widget _programCard(AssistanceProgram p) {
    final open = _expanded.contains(p.name);
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: PlanColors.border),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => setState(() {
            open ? _expanded.remove(p.name) : _expanded.add(p.name);
          }),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: AnimatedSize(
              duration: const Duration(milliseconds: 200),
              alignment: Alignment.topCenter,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: PlanColors.blush,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child:
                            Icon(p.icon, color: AppColors.maroon, size: 24),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              p.name,
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w800,
                                color: AppColors.maroon,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(p.agency,
                                style: const TextStyle(
                                    fontSize: 12, color: PlanColors.muted)),
                            const SizedBox(height: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 3),
                              decoration: BoxDecoration(
                                color: PlanColors.blush,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                p.tag,
                                style: const TextStyle(
                                  fontSize: 11.5,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.maroon,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      AnimatedRotation(
                        turns: open ? 0.25 : 0,
                        duration: const Duration(milliseconds: 200),
                        child: const Padding(
                          padding: EdgeInsets.only(top: 10),
                          child:
                              Icon(Icons.chevron_right, color: AppColors.pink),
                        ),
                      ),
                    ],
                  ),
                  if (open) ...[
                    const SizedBox(height: 14),
                    _detail('What it offers', p.offers),
                    _detail('Who may qualify', p.whoMay),
                    _detail('Where to ask', p.whereToAsk),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _detail(String title, String body) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                  color: PlanColors.eyebrow)),
          const SizedBox(height: 3),
          Text(body,
              style: const TextStyle(
                  fontSize: 13.5, height: 1.45, color: PlanColors.text)),
        ],
      ),
    );
  }
}
