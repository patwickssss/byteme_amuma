import 'dart:convert';
import 'dart:math';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/care_models.dart';
import 'mock_auth_service.dart';

/// Local-only storage for Care Records & Reminders, scoped per logged-in
/// user (by email) so different mock accounts don't share data.
/// Everything is one JSON blob per user — plenty for a prototype's worth
/// of profiles/records/reminders.
class CareStorageService {
  CareStorageService._();

  static final _rand = Random();

  static String newId() =>
      '${DateTime.now().microsecondsSinceEpoch}_${_rand.nextInt(99999)}';

  static Future<String> _userKey() async {
    final user = await MockAuthService.getStoredAccount();
    final email = user?.email ?? 'guest';
    return 'care_data:$email';
  }

  static Future<Map<String, dynamic>> _loadRaw() async {
    final prefs = await SharedPreferences.getInstance();
    final key = await _userKey();
    final raw = prefs.getString(key);
    if (raw == null) return {'profiles': [], 'records': [], 'reminders': []};
    try {
      return Map<String, dynamic>.from(jsonDecode(raw) as Map);
    } catch (_) {
      return {'profiles': [], 'records': [], 'reminders': []};
    }
  }

  static Future<void> _saveRaw(Map<String, dynamic> data) async {
    final prefs = await SharedPreferences.getInstance();
    final key = await _userKey();
    await prefs.setString(key, jsonEncode(data));
  }

  // ---------------- Profiles ----------------

  static Future<List<CareProfile>> loadProfiles() async {
    final data = await _loadRaw();
    return (data['profiles'] as List<dynamic>? ?? [])
        .map((e) => CareProfile.fromJson(Map<String, dynamic>.from(e as Map)))
        .toList();
  }

  static Future<void> addProfile(CareProfile profile) async {
    final data = await _loadRaw();
    final profiles = (data['profiles'] as List<dynamic>? ?? []);
    profiles.add(profile.toJson());
    data['profiles'] = profiles;
    await _saveRaw(data);
  }

  // ---------------- Records ----------------

  static Future<List<CareRecord>> loadRecords(String profileId) async {
    final data = await _loadRaw();
    return (data['records'] as List<dynamic>? ?? [])
        .map((e) => CareRecord.fromJson(Map<String, dynamic>.from(e as Map)))
        .where((r) => r.profileId == profileId)
        .toList()
      ..sort((a, b) => b.date.compareTo(a.date));
  }

  static Future<void> upsertRecord(CareRecord record) async {
    final data = await _loadRaw();
    final list = (data['records'] as List<dynamic>? ?? [])
        .map((e) => Map<String, dynamic>.from(e as Map))
        .toList();
    final index = list.indexWhere((e) => e['id'] == record.id);
    if (index == -1) {
      list.add(record.toJson());
    } else {
      list[index] = record.toJson();
    }
    data['records'] = list;
    await _saveRaw(data);
  }

  static Future<void> deleteRecord(String recordId) async {
    final data = await _loadRaw();
    final list = (data['records'] as List<dynamic>? ?? [])
        .map((e) => Map<String, dynamic>.from(e as Map))
        .toList();
    list.removeWhere((e) => e['id'] == recordId);
    data['records'] = list;
    await _saveRaw(data);
  }

  // ---------------- Reminders ----------------

  static Future<List<CareReminder>> loadReminders(String profileId) async {
    final data = await _loadRaw();
    return (data['reminders'] as List<dynamic>? ?? [])
        .map(
            (e) => CareReminder.fromJson(Map<String, dynamic>.from(e as Map)))
        .where((r) => r.profileId == profileId)
        .toList()
      ..sort((a, b) => a.date.compareTo(b.date));
  }

  /// All reminders for the logged-in user across every profile
  /// (used by Home's "Today's Reminder" card).
  static Future<List<MapEntry<CareProfile, CareReminder>>>
      loadAllReminders() async {
    final data = await _loadRaw();
    final profiles = (data['profiles'] as List<dynamic>? ?? [])
        .map((e) => CareProfile.fromJson(Map<String, dynamic>.from(e as Map)))
        .toList();
    final reminders = (data['reminders'] as List<dynamic>? ?? [])
        .map(
            (e) => CareReminder.fromJson(Map<String, dynamic>.from(e as Map)))
        .toList();

    final result = <MapEntry<CareProfile, CareReminder>>[];
    for (final r in reminders) {
      final profile = profiles.where((p) => p.id == r.profileId);
      if (profile.isNotEmpty) {
        result.add(MapEntry(profile.first, r));
      }
    }
    result.sort((a, b) => a.value.date.compareTo(b.value.date));
    return result;
  }

  static Future<void> upsertReminder(CareReminder reminder) async {
    final data = await _loadRaw();
    final list = (data['reminders'] as List<dynamic>? ?? [])
        .map((e) => Map<String, dynamic>.from(e as Map))
        .toList();
    final index = list.indexWhere((e) => e['id'] == reminder.id);
    if (index == -1) {
      list.add(reminder.toJson());
    } else {
      list[index] = reminder.toJson();
    }
    data['reminders'] = list;
    await _saveRaw(data);
  }

  static Future<void> deleteReminder(String reminderId) async {
    final data = await _loadRaw();
    final list = (data['reminders'] as List<dynamic>? ?? [])
        .map((e) => Map<String, dynamic>.from(e as Map))
        .toList();
    list.removeWhere((e) => e['id'] == reminderId);
    data['reminders'] = list;
    await _saveRaw(data);
  }
}
