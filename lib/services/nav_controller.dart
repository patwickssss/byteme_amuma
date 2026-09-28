import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/app_feature.dart';

/// Single source of truth for the bottom bar: which 3 features are in it
/// (More is always the fixed 4th item) and which one is active.
/// The bar order is saved in local storage.
class NavController extends ChangeNotifier {
  NavController._();
  static final NavController instance = NavController._();

  static const String _key = 'nav_order';
  static const int slots = 3;

  List<String> _order = List.of(AppFeatures.defaultBar);
  String _activeId = 'home';

  List<String> get order => List.unmodifiable(_order);
  String get activeId => _activeId;

  /// Call once before runApp.
  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getStringList(_key);
    final valid = saved != null &&
        saved.length == slots &&
        saved.first == 'home' &&
        saved.toSet().length == slots &&
        saved.every((id) => AppFeatures.all.any((f) => f.id == id));
    if (valid) _order = saved;
    notifyListeners();
  }

  /// Opens a feature. If it has no bar slot it takes slot 2 (right after Home)
  /// and the last slot's feature moves back into the More sheet.
  void open(String id) {
    if (!_order.contains(id)) {
      _order = [_order.first, id, ..._order.sublist(1, slots - 1)];
      _save();
    }
    _activeId = id;
    notifyListeners();
  }

  /// Called when the shell first appears (no rebuild needed).
  void resetActive() => _activeId = 'home';

  Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_key, _order);
  }
}
