import 'package:flutter/material.dart';

import '../data/planning_data.dart';
import '../models/planning_models.dart';
import '../services/planning_storage_service.dart';
import '../theme/app_colors.dart';
import '../utils/money_format.dart';
import '../widgets/planning/plan_widgets.dart';
import '../widgets/pressable_scale.dart';
import 'budget_breakdown_screen.dart';
import 'budget_planner_screen.dart';
import 'childcare_cost_screen.dart';
import 'financial_assistance_screen.dart';
import 'savings_goal_screen.dart';

/// Family & Budget Planning home (FAMILY___BUDGET_PLANNING.png):
/// search + filter chips + tool cards. Each card opens a working tool.
class PlanningScreen extends StatefulWidget {
  const PlanningScreen({super.key});

  @override
  State<PlanningScreen> createState() => _PlanningScreenState();
}

class _PlanningScreenState extends State<PlanningScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _query = '';
  String _chip = PlanningData.chips.first;

  BudgetPlan? _plan;
  double _spentThisMonth = 0;
  int _goalCount = 0;

  @override
  void initState() {
    super.initState();
    _loadStatus();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  /// Small status lines on the cards. If loading fails the cards still work.
  Future<void> _loadStatus() async {
    try {
      final plan = await PlanningStorageService.loadPlan();
      final expenses = await PlanningStorageService.loadExpenses();
      final goals = await PlanningStorageService.loadGoals();
      final now = DateTime.now();
      final spent = expenses
          .where((e) => e.date.year == now.year && e.date.month == now.month)
          .fold<double>(0, (sum, e) => sum + e.amount);
      if (!mounted) return;
      setState(() {
        _plan = plan;
        _spentThisMonth = spent;
        _goalCount = goals.length;
      });
    } catch (e) {
      debugPrint('Planning status load failed: $e');
    }
  }

  List<PlanningTool> get _filtered {
    final q = _query.trim().toLowerCase();
    return PlanningData.tools.where((t) {
      final matchesChip = _chip == 'For you' || t.chip == _chip;
      final matchesQuery = q.isEmpty || t.searchText.contains(q);
      return matchesChip && matchesQuery;
    }).toList();
  }

  String? _statusFor(PlanningTool t) {
    switch (t.id) {
      case 'budget_planner':
        return _plan == null
            ? 'Not set up yet'
            : 'Budget set: ${Money.format(_plan!.income)} a month';
      case 'breakdown':
        return _plan == null
            ? 'Create a budget first'
            : '${Money.format(_spentThisMonth)} spent this month';
      case 'savings':
        return _goalCount == 0
            ? 'No goals yet'
            : '$_goalCount ${_goalCount == 1 ? 'goal' : 'goals'}';
      case 'assistance':
        return '${PlanningData.programs.length} programs';
      default:
        return null;
    }
  }

  Widget _screenFor(String id) => switch (id) {
        'budget_planner' => const BudgetPlannerScreen(),
        'breakdown' => const BudgetBreakdownScreen(),
        'savings' => const SavingsGoalScreen(),
        'childcare_cost' => const ChildcareCostScreen(),
        _ => const FinancialAssistanceScreen(),
      };

  void _open(PlanningTool tool) {
    FocusScope.of(context).unfocus();
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (_) => _screenFor(tool.id)))
        .then((_) => _loadStatus());
  }

  void _clearSearch() {
    _searchController.clear();
    setState(() => _query = '');
  }

  void _resetFilters() {
    _searchController.clear();
    setState(() {
      _query = '';
      _chip = PlanningData.chips.first;
    });
  }

  @override
  Widget build(BuildContext context) {
    final results = _filtered;
    final heading = _chip == 'For you' ? 'Recommended for you' : _chip;

    return PlanScaffold(
      title: 'FAMILY & BUDGET PLANNING',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _searchField(),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [for (final c in PlanningData.chips) _chipButton(c)],
          ),
          const SizedBox(height: 18),
          Text(
            heading,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: AppColors.pink,
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: results.isEmpty
                ? PlanEmptyState(
                    icon: Icons.search_off_rounded,
                    title: 'No tools found',
                    message: 'Try a different word, or choose another topic.',
                    actionLabel: 'Clear search and filters',
                    onAction: _resetFilters,
                  )
                : ListView(
                    keyboardDismissBehavior:
                        ScrollViewKeyboardDismissBehavior.onDrag,
                    padding: const EdgeInsets.only(bottom: 24),
                    children: [
                      for (final t in results) _toolCard(t),
                      const SizedBox(height: 4),
                      const PlanNote(
                        'Budget and cost numbers are rough guides for planning. '
                        'Your data stays on this phone for now.',
                      ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }

  Widget _searchField() {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.pink),
      ),
      child: TextField(
        controller: _searchController,
        onChanged: (v) => setState(() => _query = v),
        textInputAction: TextInputAction.search,
        style: const TextStyle(fontSize: 14),
        decoration: InputDecoration(
          hintText: 'Search planning tools',
          hintStyle: const TextStyle(color: AppColors.pink, fontSize: 14),
          prefixIcon:
              const Icon(Icons.search, color: AppColors.pink, size: 22),
          suffixIcon: _query.isEmpty
              ? null
              : IconButton(
                  tooltip: 'Clear search',
                  icon: const Icon(Icons.close, color: AppColors.pink),
                  onPressed: _clearSearch,
                ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 13),
        ),
      ),
    );
  }

  Widget _chipButton(String label) {
    final active = label == _chip;
    return Semantics(
      button: true,
      selected: active,
      child: GestureDetector(
        onTap: () => setState(() => _chip = label),
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

  Widget _toolCard(PlanningTool t) {
    final status = _statusFor(t);
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: PressableScale(
        child: Material(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: const BorderSide(color: PlanColors.border),
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: () => _open(t),
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: t.tint,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Icon(t.icon, color: AppColors.maroon, size: 26),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          t.eyebrow,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: PlanColors.eyebrow,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          t.title,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            color: AppColors.maroon,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          t.description,
                          style: const TextStyle(
                            fontSize: 13,
                            height: 1.4,
                            color: Color(0xFF4A4A4A),
                          ),
                        ),
                        if (status != null) ...[
                          const SizedBox(height: 10),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 3),
                            decoration: BoxDecoration(
                              color: PlanColors.blush,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              status,
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: AppColors.maroon,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 12),
                    child: Icon(Icons.chevron_right, color: AppColors.pink),
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
