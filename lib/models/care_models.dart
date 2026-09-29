/// Prototype data models for Care Records & Reminders.
/// Everything here is stored locally via CareStorageService (shared_preferences),
/// scoped to the logged-in mock user. No backend.

class CareProfile {
  final String id;
  final String name;
  final DateTime birthDate;
  final String gender; // 'Male' | 'Female' | 'Prefer not to say'
  final String relationship; // e.g. 'Parent', 'Guardian'

  const CareProfile({
    required this.id,
    required this.name,
    required this.birthDate,
    required this.gender,
    required this.relationship,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'birthDate': birthDate.toIso8601String(),
        'gender': gender,
        'relationship': relationship,
      };

  factory CareProfile.fromJson(Map<String, dynamic> json) => CareProfile(
        id: json['id'] as String,
        name: json['name'] as String,
        birthDate: DateTime.parse(json['birthDate'] as String),
        gender: json['gender'] as String? ?? 'Prefer not to say',
        relationship: json['relationship'] as String? ?? 'Parent',
      );
}

/// Health / Growth / Vaccines / Nutrition entry for one profile.
class CareRecord {
  final String id;
  final String profileId;
  final String category; // Health, Growth, Vaccines, Nutrition
  final String title; // e.g. "Weight", "Check-up"
  final String value; // e.g. "6.2 kg"
  final String notes;
  final DateTime date;

  const CareRecord({
    required this.id,
    required this.profileId,
    required this.category,
    required this.title,
    required this.value,
    required this.notes,
    required this.date,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'profileId': profileId,
        'category': category,
        'title': title,
        'value': value,
        'notes': notes,
        'date': date.toIso8601String(),
      };

  factory CareRecord.fromJson(Map<String, dynamic> json) => CareRecord(
        id: json['id'] as String,
        profileId: json['profileId'] as String,
        category: json['category'] as String,
        title: json['title'] as String,
        value: json['value'] as String? ?? '',
        notes: json['notes'] as String? ?? '',
        date: DateTime.parse(json['date'] as String),
      );

  CareRecord copyWith({
    String? category,
    String? title,
    String? value,
    String? notes,
    DateTime? date,
  }) {
    return CareRecord(
      id: id,
      profileId: profileId,
      category: category ?? this.category,
      title: title ?? this.title,
      value: value ?? this.value,
      notes: notes ?? this.notes,
      date: date ?? this.date,
    );
  }
}

class CareReminder {
  final String id;
  final String profileId;
  final String title;
  final DateTime date;
  final String time; // free text e.g. "10:00 AM"

  const CareReminder({
    required this.id,
    required this.profileId,
    required this.title,
    required this.date,
    required this.time,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'profileId': profileId,
        'title': title,
        'date': date.toIso8601String(),
        'time': time,
      };

  factory CareReminder.fromJson(Map<String, dynamic> json) => CareReminder(
        id: json['id'] as String,
        profileId: json['profileId'] as String,
        title: json['title'] as String,
        date: DateTime.parse(json['date'] as String),
        time: json['time'] as String? ?? '',
      );

  CareReminder copyWith({
    String? title,
    DateTime? date,
    String? time,
  }) {
    return CareReminder(
      id: id,
      profileId: profileId,
      title: title ?? this.title,
      date: date ?? this.date,
      time: time ?? this.time,
    );
  }
}
