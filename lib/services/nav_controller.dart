import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/app_feature.dart';

/// Single source of truth for the bottom bar:
/// Slot 1 = Home (fixed)
/// Slot 2 = AMUMA (fixed)
/// Slot 3 = Last/currently opened feature (rotates)
/// Slot 4 = More (fixed)
///
/// The bar order is saved in local storage.
class NavController extends ChangeNotifier {
  NavController._();
  static final NavController instance = NavController._();

  static const String _key = 'nav_order';
  static const int slots = 3;

  // Default order:
  // Home, AMUMA, and the initial slot 3 feature.
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
        saved[0] == 'home' &&
        saved[1] == 'amuma' &&
        saved.toSet().length == slots &&
        saved.every(
          (id) => AppFeatures.all.any((f) => f.id == id),
        );

    if (valid) {
      _order = saved;
    } else {
      // Make sure Home and AMUMA are always fixed.
      final defaultBar = List<String>.from(AppFeatures.defaultBar);

      if (defaultBar.length >= slots) {
        _order = [
          'home',
          'amuma',
          defaultBar[2],
        ];
      }
    }

    notifyListeners();
  }

  /// Opens a feature.
  ///
  /// Home and AMUMA are fixed.
  /// Only slot 3 changes when another feature is opened.
  void open(String id) {
    // Home and AMUMA stay in their fixed positions.
    if (id == 'home' || id == 'amuma') {
      _activeId = id;
      notifyListeners();
      return;
    }

    // If the feature is already in slot 3,
    // there is no need to change the navigation order.
    if (_order[2] == id) {
      _activeId = id;
      notifyListeners();
      return;
    }

    // Replace ONLY slot 3.
    _order = [
      _order[0], // Home
      _order[1], // AMUMA
      id,        // Last/current feature
    ];

    _save();

    _activeId = id;
    notifyListeners();
  }

  /// Called when the shell first appears.
  void resetActive() {
    _activeId = 'home';
  }

  /// Saves the current navigation order.
  Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_key, _order);
  }
}
