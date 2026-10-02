import 'package:flutter/material.dart';

import '../data/planning_data.dart';
import '../models/planning_models.dart';
import '../services/planning_storage_service.dart';
import '../theme/app_colors.dart';
import '../utils/money_format.dart';
import '../widgets/planning/plan_widgets.dart';

class _CostLine {
  final String label;
  final IconData icon;
  final CostRange range;
  const _CostLine(this.label, this.icon, this.range);
}

/// Childcare cost estimator. The result updates live as you change a choice.
/// MOCK: ranges come from PlanningData (demo values, not real prices).
class ChildcareCostScreen extends StatefulWidget {
  const ChildcareCostScreen({super.key});

  @override
  State<ChildcareCostScreen> createState() => _ChildcareCostScreenState();
}

class _ChildcareCostScreenState extends State<ChildcareCostScreen> {
  int _age = 0;
  int _feeding = 2;
  int _diapers = 0;
  int _health = 0;
  int _care = 0;
  BudgetPlan? _plan;

  @override
  void initState() {
    super.initState();
    _loadPlan();
  }

  Future<void> _loadPlan() async {
    final plan = await PlanningStorageService.loadPlan();
    if (!mounted) return;
    setState(() => _plan = plan);
  }

  List<_CostLine> get _lines => [
        _CostLine('Milk and food', Icons.restaurant_rounded,
            PlanningData.feedingCosts[_age][_feeding]),
        _CostLine('Diapers and hygiene', Icons.child_care_rounded,
            PlanningData.diaperCosts[_age][_diapers]),
        _CostLine('Health care', Icons.medical_services_outlined,
            PlanningData.healthCosts[_health]),
        _CostLine('Clothes and gear', Icons.checkroom_rounded,
            PlanningData.gearCosts[_age]),
        _CostLine('Childcare', Icons.family_restroom_rounded,
            PlanningData.careCosts[_care]),
      ];

  CostRange _sum(List<_CostLine> lines) => CostRange(
        lines.fold<int>(0, (s, l) => s + l.range.low),
        lines.fold<int>(0, (s, l) => s + l.range.high),
      );

  String _range(CostRange r) => r.low == r.high
      ? Money.format(r.low)
      : '${Money.format(r.low)} - ${Money.format(r.high)}';

  /// Compares the saved "Baby essentials" budget with the estimate
  /// (everything except childcare, since that is a separate choice).
  String? _comparison(CostRange essentials) {
    final plan = _plan;
    if (plan == null) return null;
    final budget = plan.amounts['baby'] ?? 0;
    final b = Money.format(budget);
    if (budget < essentials.low) {
      return 'Your baby essentials budget ($b) may be short by at least '
          '${Money.format(essentials.low - budget)}. You may want to adjust your budget.';
    }
    if (budget <= essentials.high) {
      return 'Your baby essentials budget ($b) falls within this estimate. '
          'It looks workable, but keep an eye on spending.';
    }
    return 'Your baby essentials budget ($b) covers the higher end of this estimate.';
  }

  @override
  Widget build(BuildContext context) {
    final lines = _lines;
    final total = _sum(lines);
    final essentials = _sum(lines.sublist(0, 4));
    final comparison = _comparison(essentials);

    return PlanScaffold(
      title: 'CHILDCARE COSTS',
      child: ListView(
        padding: const EdgeInsets.only(bottom: 24),
        children: [
          PlanCard(
            color: PlanColors.blush,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Estimated monthly cost',
                    style: TextStyle(fontSize: 12, color: PlanColors.muted)),
                const SizedBox(height: 2),
                Text(
                  _range(total),
                  style: const TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w800,
                    color: AppColors.maroon,
                  ),
                ),
                const SizedBox(height: 12),
                for (final l in lines)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: Row(
                      children: [
                        Icon(l.icon, size: 20, color: AppColors.maroon),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(l.label,
                              style: const TextStyle(
                                  fontSize: 13, color: PlanColors.text)),
                        ),
                        Text(_range(l.range),
                            style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: AppColors.maroon)),
                      ],
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          if (comparison != null)
            PlanCard(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.compare_arrows_rounded,
                      color: AppColors.maroon, size: 22),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(comparison,
                        style: const TextStyle(
                            fontSize: 13,
                            height: 1.4,
                            color: PlanColors.text)),
                  ),
                ],
              ),
            )
          else
            const PlanNote(
              'Create a family budget first to see how this estimate compares with your plan.',
            ),
          const SizedBox(height: 22),
          const Text('Adjust to match your family',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: AppColors.maroon)),
          const SizedBox(height: 14),
          _group('Baby\'s age', PlanningData.ageGroups, _age,
              (i) => setState(() => _age = i)),
          _group('Feeding', PlanningData.feedingOptions, _feeding,
              (i) => setState(() => _feeding = i)),
          _group('Diapers', PlanningData.diaperOptions, _diapers,
              (i) => setState(() => _diapers = i)),
          _group('Check-ups and vaccines', PlanningData.healthOptions, _health,
              (i) => setState(() => _health = i)),
          _group('Who looks after baby while you work?', PlanningData.careOptions,
              _care, (i) => setState(() => _care = i)),
          const SizedBox(height: 4),
          const PlanNote(
            'Rough ranges for planning only (demo numbers). Real costs depend '
            'on your area, brands, and your baby\'s needs. Routine vaccines '
            'are free at government health centers.',
          ),
        ],
      ),
    );
  }

  Widget _group(
    String label,
    List<String> options,
    int selected,
    ValueChanged<int> onSelected,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(label,
                style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: PlanColors.eyebrow)),
          ),
          PlanChoice(
              options: options, selected: selected, onSelected: onSelected),
        ],
      ),
    );
  }
}
