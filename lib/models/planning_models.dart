/// Prototype data models for Family & Budget Planning.
/// Stored locally via PlanningStorageService (shared_preferences),
/// scoped to the logged-in mock user. No backend.

class BudgetPlan {
  final double income; // monthly, in pesos
  final bool paysRent;
  final String babyStage; // 'expecting' | 'infant' | 'toddler'
  final Map<String, double> amounts; // category id -> pesos per month
  final DateTime createdAt;

  const BudgetPlan({
    required this.income,
    required this.paysRent,
    required this.babyStage,
    required this.amounts,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() => {
        'income': income,
        'paysRent': paysRent,
        'babyStage': babyStage,
        'amounts': amounts,
        'createdAt': createdAt.toIso8601String(),
      };

  factory BudgetPlan.fromJson(Map<String, dynamic> json) => BudgetPlan(
        income: (json['income'] as num).toDouble(),
        paysRent: json['paysRent'] as bool? ?? true,
        babyStage: json['babyStage'] as String? ?? 'infant',
        amounts: (json['amounts'] as Map? ?? {})
            .map((k, v) => MapEntry(k as String, (v as num).toDouble())),
        createdAt: DateTime.parse(json['createdAt'] as String),
      );
}

class ExpenseEntry {
  final String id;
  final String categoryId;
  final double amount;
  final String note;
  final DateTime date;

  const ExpenseEntry({
    required this.id,
    required this.categoryId,
    required this.amount,
    required this.note,
    required this.date,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'categoryId': categoryId,
        'amount': amount,
        'note': note,
        'date': date.toIso8601String(),
      };

  factory ExpenseEntry.fromJson(Map<String, dynamic> json) => ExpenseEntry(
        id: json['id'] as String,
        categoryId: json['categoryId'] as String,
        amount: (json['amount'] as num).toDouble(),
        note: json['note'] as String? ?? '',
        date: DateTime.parse(json['date'] as String),
      );
}

class SavingsGoal {
  final String id;
  final String name;
  final double target;
  final double saved;
  final DateTime targetDate;
  final DateTime createdAt;

  const SavingsGoal({
    required this.id,
    required this.name,
    required this.target,
    required this.saved,
    required this.targetDate,
    required this.createdAt,
  });

  bool get reached => saved >= target;

  SavingsGoal copyWith({double? saved}) => SavingsGoal(
        id: id,
        name: name,
        target: target,
        saved: saved ?? this.saved,
        targetDate: targetDate,
        createdAt: createdAt,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'target': target,
        'saved': saved,
        'targetDate': targetDate.toIso8601String(),
        'createdAt': createdAt.toIso8601String(),
      };

  factory SavingsGoal.fromJson(Map<String, dynamic> json) => SavingsGoal(
        id: json['id'] as String,
        name: json['name'] as String,
        target: (json['target'] as num).toDouble(),
        saved: (json['saved'] as num? ?? 0).toDouble(),
        targetDate: DateTime.parse(json['targetDate'] as String),
        createdAt: DateTime.parse(json['createdAt'] as String),
      );
}
