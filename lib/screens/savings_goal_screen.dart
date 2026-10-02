import 'package:flutter/material.dart';

import '../data/planning_data.dart';
import '../models/planning_models.dart';
import '../services/planning_storage_service.dart';
import '../theme/app_colors.dart';
import '../utils/age_utils.dart';
import '../utils/money_format.dart';
import '../widgets/planning/plan_widgets.dart';

/// Savings goals: create a goal, add savings, see the monthly amount needed.
class SavingsGoalScreen extends StatefulWidget {
  const SavingsGoalScreen({super.key});

  @override
  State<SavingsGoalScreen> createState() => _SavingsGoalScreenState();
}

class _SavingsGoalScreenState extends State<SavingsGoalScreen> {
  bool _loading = true;
  List<SavingsGoal> _goals = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final goals = await PlanningStorageService.loadGoals();
    if (!mounted) return;
    setState(() {
      _goals = goals;
      _loading = false;
    });
  }

  Future<void> _openAddGoal() async {
    final goal = await showModalBottomSheet<SavingsGoal>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => const _AddGoalSheet(),
    );
    if (goal == null) return;
    await PlanningStorageService.addGoal(goal);
    _load();
  }

  Future<void> _addSavings(SavingsGoal goal) async {
    final amount = await showDialog<double>(
      context: context,
      builder: (_) => const _AddAmountDialog(),
    );
    if (amount == null) return;
    await PlanningStorageService.addToGoal(goal.id, amount);
    _load();
  }

  Future<void> _delete(SavingsGoal goal) async {
    if (!await confirmDelete(context, 'Delete goal?')) return;
    await PlanningStorageService.deleteGoal(goal.id);
    _load();
  }

  @override
  Widget build(BuildContext context) {
    return PlanScaffold(
      title: 'SAVINGS GOALS',
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColors.maroon,
        foregroundColor: Colors.white,
        onPressed: _openAddGoal,
        icon: const Icon(Icons.add),
        label: const Text('New goal',
            style: TextStyle(fontWeight: FontWeight.w700)),
      ),
      child: _loading
          ? const Center(child: CircularProgressIndicator())
          : _goals.isEmpty
              ? PlanEmptyState(
                  icon: Icons.savings_outlined,
                  title: 'No savings goals yet',
                  message:
                      "Start with something small, like an emergency fund or your baby's check-ups.",
                  actionLabel: 'Set my first goal',
                  onAction: _openAddGoal,
                )
              : ListView(
                  padding: const EdgeInsets.only(bottom: 100),
                  children: [for (final g in _goals) _goalCard(g)],
                ),
    );
  }

  Widget _goalCard(SavingsGoal g) {
    final today = DateTime.now();
    final daysLeft = g.targetDate.difference(today).inDays;
    final remaining = g.target - g.saved;
    final months = daysLeft <= 0 ? 1 : (daysLeft / 30).ceil();

    String hint;
    if (g.reached) {
      hint = 'Goal reached. Well done!';
    } else if (daysLeft < 0) {
      hint = 'Target date has passed. ${Money.format(remaining)} still to go.';
    } else {
      hint = 'Set aside about ${Money.format(remaining / months)} a month '
          'to reach it by ${AgeUtils.formatDate(g.targetDate)}.';
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: PlanCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    g.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: AppColors.maroon,
                    ),
                  ),
                ),
                IconButton(
                  tooltip: 'Delete goal',
                  onPressed: () => _delete(g),
                  icon: const Icon(Icons.delete_outline,
                      color: AppColors.errorRed, size: 22),
                ),
              ],
            ),
            Text(
              '${Money.format(g.saved)} of ${Money.format(g.target)}',
              style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: PlanColors.text),
            ),
            const SizedBox(height: 10),
            PlanProgressBar(value: g.target > 0 ? g.saved / g.target : 0),
            const SizedBox(height: 8),
            Text(hint,
                style: const TextStyle(
                    fontSize: 13, height: 1.4, color: PlanColors.muted)),
            if (!g.reached) ...[
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () => _addSavings(g),
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size.fromHeight(46),
                    side: const BorderSide(color: AppColors.maroon),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  icon: const Icon(Icons.add, color: AppColors.maroon),
                  label: const Text('Add savings',
                      style: TextStyle(
                          fontWeight: FontWeight.w700,
                          color: AppColors.maroon)),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _AddGoalSheet extends StatefulWidget {
  const _AddGoalSheet();

  @override
  State<_AddGoalSheet> createState() => _AddGoalSheetState();
}

class _AddGoalSheetState extends State<_AddGoalSheet> {
  final _nameController = TextEditingController(text: 'Emergency fund');
  final _targetController = TextEditingController();
  int _presetIndex = 0;
  late DateTime _date;
  String? _nameError;
  String? _targetError;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _date = DateTime(now.year, now.month + 6, now.day);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _targetController.dispose();
    super.dispose();
  }

  void _pickPreset(int i) {
    setState(() {
      _presetIndex = i;
      final label = PlanningData.goalPresets[i];
      _nameController.text = label == 'Other' ? '' : label;
      _nameError = null;
    });
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: now,
      lastDate: DateTime(now.year + 10),
    );
    if (picked != null) setState(() => _date = picked);
  }

  void _save() {
    final name = _nameController.text.trim();
    final target = Money.parse(_targetController.text);
    setState(() {
      _nameError = name.isEmpty ? 'Please name your goal.' : null;
      _targetError = (target == null || target <= 0)
          ? 'Please enter an amount, for example 20000.'
          : null;
    });
    if (_nameError != null || _targetError != null) return;

    Navigator.of(context).pop(
      SavingsGoal(
        id: PlanningStorageService.newId(),
        name: name,
        target: target!,
        saved: 0,
        targetDate: _date,
        createdAt: DateTime.now(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
          20, 12, 20, MediaQuery.of(context).viewInsets.bottom + 20),
      child: SafeArea(
        top: false,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
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
              const Text('New savings goal',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: AppColors.maroon)),
              const SizedBox(height: 16),
              PlanChoice(
                options: PlanningData.goalPresets,
                selected: _presetIndex,
                onSelected: _pickPreset,
              ),
              const SizedBox(height: 16),
              PlanField(
                label: 'Goal name',
                controller: _nameController,
                hint: 'e.g. Emergency fund',
                error: _nameError,
                onChanged: (_) {
                  if (_nameError != null) setState(() => _nameError = null);
                },
              ),
              const SizedBox(height: 14),
              PlanField(
                label: 'Target amount',
                controller: _targetController,
                hint: 'e.g. 20000',
                prefixText: '₱ ',
                keyboardType: TextInputType.number,
                error: _targetError,
                onChanged: (_) {
                  if (_targetError != null) setState(() => _targetError = null);
                },
              ),
              const SizedBox(height: 14),
              const Text('Reach it by',
                  style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: PlanColors.eyebrow)),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: _pickDate,
                child: Container(
                  height: 50,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.pink),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                          child: Text(AgeUtils.formatDate(_date),
                              style: const TextStyle(fontSize: 14))),
                      const Icon(Icons.calendar_today_outlined,
                          size: 18, color: AppColors.pink),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 22),
              PlanPrimaryButton(label: 'Save goal', onPressed: _save),
            ],
          ),
        ),
      ),
    );
  }
}

class _AddAmountDialog extends StatefulWidget {
  const _AddAmountDialog();

  @override
  State<_AddAmountDialog> createState() => _AddAmountDialogState();
}

class _AddAmountDialogState extends State<_AddAmountDialog> {
  final _controller = TextEditingController();
  String? _error;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _save() {
    final amount = Money.parse(_controller.text);
    if (amount == null || amount <= 0) {
      setState(() => _error = 'Please enter an amount, for example 500.');
      return;
    }
    Navigator.of(context).pop(amount);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add savings'),
      content: PlanField(
        label: 'Amount',
        controller: _controller,
        hint: 'e.g. 500',
        prefixText: '₱ ',
        keyboardType: TextInputType.number,
        error: _error,
        onChanged: (_) {
          if (_error != null) setState(() => _error = null);
        },
      ),
      actions: [
        TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel')),
        TextButton(onPressed: _save, child: const Text('Add')),
      ],
    );
  }
}
