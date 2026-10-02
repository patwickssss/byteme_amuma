import 'dart:convert';
import 'dart:math';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/planning_models.dart';
import 'mock_auth_service.dart';

/// Local-only storage for Family & Budget Planning, one JSON blob per
/// logged-in mock user (by email). Prototype only: shared_preferences is
/// NOT encrypted, so keep demo numbers here, never real financial data.
class PlanningStorageService {
  PlanningStorageService._();

  static final _rand = Random();

  static String newId() =>
      '${DateTime.now().microsecondsSinceEpoch}_${_rand.nextInt(99999)}';

  static Future<String> _userKey() async {
    final user = await MockAuthService.getStoredAccount();
    return 'planning_data:${user?.email ?? 'guest'}';
  }

  static Map<String, dynamic> _empty() =>
      {'plan': null, 'expenses': [], 'goals': []};

  static Future<Map<String, dynamic>> _loadRaw() async {
    final key = await _userKey();
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(key);
    if (raw == null) return _empty();
    try {
      return Map<String, dynamic>.from(jsonDecode(raw) as Map);
    } catch (_) {
      return _empty(); // corrupted data: start clean instead of crashing
    }
  }

  static Future<void> _saveRaw(Map<String, dynamic> data) async {
    final key = await _userKey();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, jsonEncode(data));
  }

  static List<Map<String, dynamic>> _list(
      Map<String, dynamic> data, String key) {
    return (data[key] as List<dynamic>? ?? [])
        .map((e) => Map<String, dynamic>.from(e as Map))
        .toList();
  }

  // ---------------- Budget plan ----------------

  static Future<BudgetPlan?> loadPlan() async {
    final data = await _loadRaw();
    final raw = data['plan'];
    if (raw == null) return null;
    try {
      return BudgetPlan.fromJson(Map<String, dynamic>.from(raw as Map));
    } catch (_) {
      return null;
    }
  }

  static Future<void> savePlan(BudgetPlan plan) async {
    final data = await _loadRaw();
    data['plan'] = plan.toJson();
    await _saveRaw(data);
  }

  // ---------------- Expenses ----------------

  static Future<List<ExpenseEntry>> loadExpenses() async {
    final data = await _loadRaw();
    return _list(data, 'expenses').map(ExpenseEntry.fromJson).toList()
      ..sort((a, b) => b.date.compareTo(a.date));
  }

  static Future<void> addExpense(ExpenseEntry entry) async {
    final data = await _loadRaw();
    final list = _list(data, 'expenses')..add(entry.toJson());
    data['expenses'] = list;
    await _saveRaw(data);
  }

  static Future<void> deleteExpense(String id) async {
    final data = await _loadRaw();
    final list = _list(data, 'expenses')..removeWhere((e) => e['id'] == id);
    data['expenses'] = list;
    await _saveRaw(data);
  }

  // ---------------- Savings goals ----------------

  static Future<List<SavingsGoal>> loadGoals() async {
    final data = await _loadRaw();
    return _list(data, 'goals').map(SavingsGoal.fromJson).toList()
      ..sort((a, b) => a.targetDate.compareTo(b.targetDate));
  }

  static Future<void> addGoal(SavingsGoal goal) async {
    final data = await _loadRaw();
    final list = _list(data, 'goals')..add(goal.toJson());
    data['goals'] = list;
    await _saveRaw(data);
  }

  static Future<void> addToGoal(String id, double amount) async {
    final data = await _loadRaw();
    final list = _list(data, 'goals');
    final index = list.indexWhere((g) => g['id'] == id);
    if (index == -1) return;
    final goal = SavingsGoal.fromJson(list[index]);
    list[index] = goal.copyWith(saved: goal.saved + amount).toJson();
    data['goals'] = list;
    await _saveRaw(data);
  }

  static Future<void> deleteGoal(String id) async {
    final data = await _loadRaw();
    final list = _list(data, 'goals')..removeWhere((g) => g['id'] == id);
    data['goals'] = list;
    await _saveRaw(data);
  }
}
