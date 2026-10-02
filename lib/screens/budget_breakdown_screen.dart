import 'package:flutter/material.dart';

import '../data/planning_data.dart';
import '../models/planning_models.dart';
import '../services/planning_storage_service.dart';
import '../theme/app_colors.dart';
import '../utils/age_utils.dart';
import '../utils/money_format.dart';
import '../widgets/planning/plan_widgets.dart';
import 'budget_planner_screen.dart';

/// "Where Does My Money Go?": log spending, compare with the saved budget.
class BudgetBreakdownScreen extends StatefulWidget {
  const BudgetBreakdownScreen({super.key});

  @override
  State<BudgetBreakdownScreen> createState() => _BudgetBreakdownScreenState();
}

class _BudgetBreakdownScreenState extends State<BudgetBreakdownScreen> {
  bool _loading = true;
  BudgetPlan? _plan;
  List<ExpenseEntry> _monthExpenses = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final plan = await PlanningStorageService.loadPlan();
    final all = await PlanningStorageService.loadExpenses();
    final now = DateTime.now();
    if (!mounted) return;
    setState(() {
      _plan = plan;
      _monthExpenses = all
          .where((e) => e.date.year == now.year && e.date.month == now.month)
          .toList();
      _loading = false;
    });
  }

  Map<String, double> get _spentBy {
    final map = <String, double>{};
    for (final e in _monthExpenses) {
      map[e.categoryId] = (map[e.categoryId] ?? 0) + e.amount;
    }
    return map;
  }

  double get _totalSpent =>
      _monthExpenses.fold<double>(0, (sum, e) => sum + e.amount);

  Future<void> _openAddExpense() async {
    final entry = await showModalBottomSheet<ExpenseEntry>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => const _AddExpenseSheet(),
    );
    if (entry == null) return;
    try {
      await PlanningStorageService.addExpense(entry);
      await _load();
    } catch (e) {
      debugPrint('Add expense failed: $e');
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Something went wrong. Please try again.')),
      );
    }
  }

  Future<void> _deleteExpense(ExpenseEntry e) async {
    if (!await confirmDelete(context, 'Delete expense?')) return;
    await PlanningStorageService.deleteExpense(e.id);
    _load();
  }

  Future<void> _goCreateBudget() async {
    await Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const BudgetPlannerScreen()),
    );
    _load();
  }

  @override
  Widget build(BuildContext context) {
    final plan = _plan;
    return PlanScaffold(
      title: 'WHERE MY MONEY GOES',
      floatingActionButton: plan == null || _loading
          ? null
          : FloatingActionButton.extended(
              backgroundColor: AppColors.maroon,
              foregroundColor: Colors.white,
              onPressed: _openAddExpense,
              icon: const Icon(Icons.add),
              label: const Text('Add expense',
                  style: TextStyle(fontWeight: FontWeight.w700)),
            ),
      child: _loading
          ? const Center(child: CircularProgressIndicator())
          : plan == null
              ? PlanEmptyState(
                  icon: Icons.account_balance_wallet_outlined,
                  title: 'No budget yet',
                  message:
                      'Create your family budget first, then track where your money goes.',
                  actionLabel: 'Create my budget',
                  onAction: _goCreateBudget,
                )
              : _content(plan),
    );
  }

  Widget _content(BudgetPlan plan) {
    final now = DateTime.now();
    final spent = _totalSpent;
    final left = plan.income - spent;
    final over = left < 0;
    final insight = _insight();

    return ListView(
      padding: const EdgeInsets.only(bottom: 100),
      children: [
        Text(
          '${AgeUtils.monthNames[now.month - 1]} ${now.year}',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: AppColors.pink,
          ),
        ),
        const SizedBox(height: 10),
        PlanCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Spent this month',
                  style: TextStyle(fontSize: 12, color: PlanColors.muted)),
              Text(
                Money.format(spent),
                style: const TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w800,
                  color: AppColors.maroon,
                ),
              ),
              Text('of ${Money.format(plan.income)} monthly income',
                  style:
                      const TextStyle(fontSize: 13, color: PlanColors.muted)),
              const SizedBox(height: 12),
              PlanProgressBar(
                value: plan.income > 0 ? spent / plan.income : 0,
                color: over ? PlanColors.overText : AppColors.maroon,
              ),
              const SizedBox(height: 8),
              Text(
                over
                    ? 'Over budget by ${Money.format(-left)}'
                    : '${Money.format(left)} left this month',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: over ? PlanColors.overText : AppColors.maroon,
                ),
              ),
            ],
          ),
        ),
        if (insight != null) ...[
          const SizedBox(height: 12),
          PlanCard(
            color: PlanColors.blush,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.lightbulb_outline_rounded,
                    color: AppColors.maroon, size: 22),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(insight,
                      style: const TextStyle(
                          fontSize: 13, height: 1.4, color: PlanColors.text)),
                ),
              ],
            ),
          ),
        ],
        const SizedBox(height: 20),
        const Text('By category',
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: AppColors.maroon)),
        const SizedBox(height: 10),
        for (final c in PlanningData.budgetCategories) _categoryRow(c, plan),
        const SizedBox(height: 12),
        const Text('This month\'s expenses',
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: AppColors.maroon)),
        const SizedBox(height: 10),
        if (_monthExpenses.isEmpty)
          const PlanCard(
            child: Text(
              'No expenses yet. Tap "Add expense" to log your first one.',
              style: TextStyle(fontSize: 13, color: PlanColors.muted),
            ),
          )
        else
          for (final e in _monthExpenses) _expenseTile(e),
      ],
    );
  }

  String? _insight() {
    final total = _totalSpent;
    if (total <= 0) return null;
    final top = _spentBy.entries.reduce((a, b) => a.value >= b.value ? a : b);
    final percent = (top.value / total * 100).round();
    final label = PlanningData.categoryById(top.key).label.toLowerCase();
    return 'Most of your spending this month went to $label ($percent%).';
  }

  Widget _categoryRow(BudgetCategory c, BudgetPlan plan) {
    final budget = plan.amounts[c.id] ?? 0;
    final spent = _spentBy[c.id] ?? 0;
    final over = spent > budget;
    final ratio = budget > 0 ? spent / budget : (spent > 0 ? 1.0 : 0.0);

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: PlanCard(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: c.tint,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(c.icon, color: AppColors.maroon, size: 20),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(c.label,
                      style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: PlanColors.text)),
                ),
              ],
            ),
            const SizedBox(height: 10),
            PlanProgressBar(
              value: ratio,
              color: over ? PlanColors.overText : AppColors.maroon,
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                Expanded(
                  child: Text(
                    '${Money.format(spent)} of ${Money.format(budget)}',
                    style: const TextStyle(
                        fontSize: 12, color: PlanColors.muted),
                  ),
                ),
                Text(
                  over
                      ? 'Over by ${Money.format(spent - budget)}'
                      : '${Money.format(budget - spent)} left',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: over ? PlanColors.overText : AppColors.maroon,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _expenseTile(ExpenseEntry e) {
    final c = PlanningData.categoryById(e.categoryId);
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: PlanCard(
        padding: const EdgeInsets.fromLTRB(14, 10, 6, 10),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: c.tint,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(c.icon, color: AppColors.maroon, size: 20),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    e.note.isEmpty ? c.label : e.note,
                    style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: PlanColors.text),
                  ),
                  Text(
                    '${c.label}  •  ${AgeUtils.formatDate(e.date)}',
                    style: const TextStyle(
                        fontSize: 12, color: PlanColors.muted),
                  ),
                ],
              ),
            ),
            Text(Money.format(e.amount),
                style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: AppColors.maroon)),
            IconButton(
              tooltip: 'Delete expense',
              onPressed: () => _deleteExpense(e),
              icon: const Icon(Icons.delete_outline,
                  color: AppColors.errorRed, size: 22),
            ),
          ],
        ),
      ),
    );
  }
}

/// Bottom sheet form. Pops with a new ExpenseEntry when saved.
class _AddExpenseSheet extends StatefulWidget {
  const _AddExpenseSheet();

  @override
  State<_AddExpenseSheet> createState() => _AddExpenseSheetState();
}

class _AddExpenseSheetState extends State<_AddExpenseSheet> {
  final _amountController = TextEditingController();
  final _noteController = TextEditingController();
  int _categoryIndex = 0;
  DateTime _date = DateTime.now();
  String? _amountError;

  @override
  void dispose() {
    _amountController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(now.year - 1),
      lastDate: now,
    );
    if (picked != null) setState(() => _date = picked);
  }

  void _save() {
    final amount = Money.parse(_amountController.text);
    if (amount == null || amount <= 0) {
      setState(() => _amountError = 'Please enter an amount, for example 350.');
      return;
    }
    Navigator.of(context).pop(
      ExpenseEntry(
        id: PlanningStorageService.newId(),
        categoryId: PlanningData.budgetCategories[_categoryIndex].id,
        amount: amount,
        note: _noteController.text.trim(),
        date: _date,
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
              const Text('Add expense',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: AppColors.maroon)),
              const SizedBox(height: 16),
              const Text('Category',
                  style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: PlanColors.eyebrow)),
              const SizedBox(height: 8),
              PlanChoice(
                options: [
                  for (final c in PlanningData.budgetCategories) c.label
                ],
                selected: _categoryIndex,
                onSelected: (i) => setState(() => _categoryIndex = i),
              ),
              const SizedBox(height: 16),
              PlanField(
                label: 'Amount',
                controller: _amountController,
                hint: 'e.g. 350',
                prefixText: '₱ ',
                keyboardType: TextInputType.number,
                error: _amountError,
                onChanged: (_) {
                  if (_amountError != null) setState(() => _amountError = null);
                },
              ),
              const SizedBox(height: 14),
              PlanField(
                label: 'Note (optional)',
                controller: _noteController,
                hint: 'e.g. Diapers and wipes',
              ),
              const SizedBox(height: 14),
              const Text('Date',
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
              PlanPrimaryButton(label: 'Save expense', onPressed: _save),
            ],
          ),
        ),
      ),
    );
  }
}
