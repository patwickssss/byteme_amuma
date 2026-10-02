import 'package:flutter/material.dart';

import '../data/planning_data.dart';
import '../models/planning_models.dart';
import '../services/planning_storage_service.dart';
import '../theme/app_colors.dart';
import '../utils/money_format.dart';
import '../widgets/planning/plan_widgets.dart';
import 'budget_breakdown_screen.dart';

/// "Create My Family Budget": income + 2 quick questions -> suggested split.
/// MOCK: the "smart" part is simple rules (PlanningData.suggestSplit).
class BudgetPlannerScreen extends StatefulWidget {
  const BudgetPlannerScreen({super.key});

  @override
  State<BudgetPlannerScreen> createState() => _BudgetPlannerScreenState();
}

class _BudgetPlannerScreenState extends State<BudgetPlannerScreen> {
  static const _stages = ['expecting', 'infant', 'toddler'];
  static const _stageLabels = ['Expecting', 'Baby under 1', 'Toddler 1-3'];

  final _incomeController = TextEditingController();
  bool _paysRent = true;
  int _stageIndex = 1;

  String? _incomeError;
  bool _loading = true;
  bool _saving = false;
  bool _showForm = true;
  BudgetPlan? _plan;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _incomeController.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    final plan = await PlanningStorageService.loadPlan();
    if (!mounted) return;
    setState(() {
      _plan = plan;
      if (plan != null) {
        _incomeController.text = plan.income.round().toString();
        _paysRent = plan.paysRent;
        final i = _stages.indexOf(plan.babyStage);
        _stageIndex = i < 0 ? 1 : i;
      }
      _showForm = plan == null;
      _loading = false;
    });
  }

  Future<void> _create() async {
    if (_saving) return;
    FocusScope.of(context).unfocus();

    final income = Money.parse(_incomeController.text);
    if (income == null || income <= 0) {
      setState(() => _incomeError =
          'Please enter your monthly income, for example 25000.');
      return;
    }
    if (income > 10000000) {
      setState(() => _incomeError = 'That amount looks too high. Please check it.');
      return;
    }

    setState(() => _saving = true);
    try {
      // MOCK: short delay so it feels like the planner is "thinking".
      await Future.delayed(const Duration(milliseconds: 600));
      final plan = BudgetPlan(
        income: income,
        paysRent: _paysRent,
        babyStage: _stages[_stageIndex],
        amounts: PlanningData.suggestSplit(
          income: income,
          paysRent: _paysRent,
          babyStage: _stages[_stageIndex],
        ),
        createdAt: DateTime.now(),
      );
      await PlanningStorageService.savePlan(plan);
      if (!mounted) return;
      setState(() {
        _plan = plan;
        _showForm = false;
      });
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Budget saved.')));
    } catch (e) {
      debugPrint('Budget save failed: $e');
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Something went wrong. Please try again.')),
      );
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return PlanScaffold(
      title: 'FAMILY BUDGET',
      child: _loading
          ? const Center(child: CircularProgressIndicator())
          : (_showForm || _plan == null ? _form() : _result(_plan!)),
    );
  }

  // ---------------- Form ----------------

  Widget _form() {
    return ListView(
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      padding: const EdgeInsets.only(bottom: 24),
      children: [
        const Text(
          "Tell us a little about your family and we'll suggest a monthly budget.",
          style: TextStyle(fontSize: 14, height: 1.4, color: PlanColors.muted),
        ),
        const SizedBox(height: 20),
        PlanField(
          label: 'Monthly household income',
          controller: _incomeController,
          hint: 'e.g. 25000',
          prefixText: '₱ ',
          keyboardType: TextInputType.number,
          error: _incomeError,
          onChanged: (_) {
            if (_incomeError != null) setState(() => _incomeError = null);
          },
        ),
        const SizedBox(height: 20),
        const _Label('Do you pay rent or a housing loan?'),
        PlanChoice(
          options: const ['Yes', 'No, I live with family'],
          selected: _paysRent ? 0 : 1,
          onSelected: (i) => setState(() => _paysRent = i == 0),
        ),
        const SizedBox(height: 20),
        const _Label('Where are you in your parenting journey?'),
        PlanChoice(
          options: _stageLabels,
          selected: _stageIndex,
          onSelected: (i) => setState(() => _stageIndex = i),
        ),
        const SizedBox(height: 28),
        PlanPrimaryButton(
          label: 'Create my budget',
          icon: Icons.auto_awesome_rounded,
          loading: _saving,
          onPressed: _create,
        ),
        const SizedBox(height: 14),
        const PlanNote(
          'Suggestions use simple rules for now (demo). They are a starting '
          'point, not a rule. Adjust to fit your family.',
        ),
      ],
    );
  }

  // ---------------- Result ----------------

  Widget _result(BudgetPlan plan) {
    final stageIndex = _stages.indexOf(plan.babyStage);
    final stageLabel = _stageLabels[stageIndex < 0 ? 1 : stageIndex];

    return ListView(
      padding: const EdgeInsets.only(bottom: 24),
      children: [
        PlanCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Monthly income',
                  style: TextStyle(fontSize: 12, color: PlanColors.muted)),
              Text(
                Money.format(plan.income),
                style: const TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w800,
                  color: AppColors.maroon,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Based on: ${plan.paysRent ? 'paying rent' : 'living with family'}, '
                '${stageLabel.toLowerCase()}',
                style: const TextStyle(fontSize: 12, color: PlanColors.muted),
              ),
              const SizedBox(height: 16),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: SizedBox(
                  height: 14,
                  child: Row(
                    children: [
                      for (final c in PlanningData.budgetCategories)
                        _segment(c, plan),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        PlanCard(
          child: Column(
            children: [
              for (final c in PlanningData.budgetCategories) _row(c, plan),
            ],
          ),
        ),
        const SizedBox(height: 16),
        PlanPrimaryButton(
          label: 'Track my spending',
          icon: Icons.pie_chart_outline_rounded,
          onPressed: () => Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const BudgetBreakdownScreen()),
          ),
        ),
        const SizedBox(height: 10),
        PlanOutlineButton(
          label: 'Recalculate',
          onPressed: () => setState(() => _showForm = true),
        ),
        const SizedBox(height: 14),
        const PlanNote(
          'This is a starting point, not a rule. Suggestions use simple rules '
          'for now (demo).',
        ),
      ],
    );
  }

  Widget _segment(BudgetCategory c, BudgetPlan plan) {
    final share = ((plan.amounts[c.id] ?? 0) / plan.income * 1000).round();
    return Expanded(
      flex: share < 1 ? 1 : share,
      child: Container(color: c.color),
    );
  }

  Widget _row(BudgetCategory c, BudgetPlan plan) {
    final amount = plan.amounts[c.id] ?? 0;
    final percent = (amount / plan.income * 100).round();
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: c.tint,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(c.icon, color: AppColors.maroon, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                          color: c.color, shape: BoxShape.circle),
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        c.label,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: PlanColors.text,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(c.hint,
                    style: const TextStyle(
                        fontSize: 12, color: PlanColors.muted)),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                Money.format(amount),
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  color: AppColors.maroon,
                ),
              ),
              Text('$percent%',
                  style: const TextStyle(
                      fontSize: 12, color: PlanColors.muted)),
            ],
          ),
        ],
      ),
    );
  }
}

class _Label extends StatelessWidget {
  final String text;
  const _Label(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w700,
          color: PlanColors.eyebrow,
        ),
      ),
    );
  }
}
