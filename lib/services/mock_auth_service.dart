import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/mock_user.dart';

/// Local/mock account system for the prototype. No network, no backend.
/// Passwords are stored in plain text on the device — demo data only,
/// never use real credentials. Swap this class for a real auth service later.
class MockAuthService {
  MockAuthService._();

  static const String _accountsKey = 'mock_accounts';
  static const String _sessionKey = 'mock_current_email';
  static const Duration _fakeLatency = Duration(milliseconds: 800);

  static String _normalize(String email) => email.trim().toLowerCase();

  static Future<List<MockUser>> _loadAccounts() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_accountsKey);
    if (raw == null) return [];
    try {
      final list = jsonDecode(raw) as List<dynamic>;
      return list
          .map((e) => MockUser.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList();
    } catch (_) {
      return []; // corrupted data: start clean instead of crashing
    }
  }

  static Future<void> _saveAccounts(List<MockUser> accounts) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _accountsKey,
      jsonEncode(accounts.map((a) => a.toJson()).toList()),
    );
  }

  /// Returns null on success, or a user-facing error message.
  static Future<String?> createAccount({
    required String email,
    required String password,
  }) async {
    await Future.delayed(_fakeLatency);
    final accounts = await _loadAccounts();
    final normalized = _normalize(email);

    if (accounts.any((a) => a.email == normalized)) {
      return 'An account with this email already exists.';
    }

    accounts.add(MockUser(email: normalized, password: password));
    await _saveAccounts(accounts);
    return null;
  }

  /// Returns true if the credentials match a stored account.
  static Future<bool> login({
    required String email,
    required String password,
  }) async {
    await Future.delayed(_fakeLatency);
    final accounts = await _loadAccounts();
    final normalized = _normalize(email);

    final matches = accounts.where(
      (a) => a.email == normalized && a.password == password,
    );
    if (matches.isEmpty) return false;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_sessionKey, matches.first.email);
    return true;
  }

  /// The currently logged-in mock user, or null.
  static Future<MockUser?> getStoredAccount() async {
    final prefs = await SharedPreferences.getInstance();
    final email = prefs.getString(_sessionKey);
    if (email == null) return null;
    final accounts = await _loadAccounts();
    for (final a in accounts) {
      if (a.email == email) return a;
    }
    return null;
  }

  /// Merges [data] into the logged-in user's profile map.
  static Future<void> saveProfile(Map<String, dynamic> data) async {
    final current = await getStoredAccount();
    if (current == null) return;
    final accounts = await _loadAccounts();
    final index = accounts.indexWhere((a) => a.email == current.email);
    if (index == -1) return;
    accounts[index] =
        current.copyWith(profile: {...current.profile, ...data});
    await _saveAccounts(accounts);
  }

  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_sessionKey);
  }
}
