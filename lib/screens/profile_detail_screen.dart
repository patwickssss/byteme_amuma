import 'package:flutter/material.dart';

import '../models/care_models.dart';
import '../services/care_storage_service.dart';
import '../theme/app_colors.dart';
import '../utils/age_utils.dart';
import '../widgets/month_calendar.dart';
import '../widgets/pressable_scale.dart';
import 'add_edit_record_screen.dart';
import 'add_edit_reminder_screen.dart';

/// One child's Records + Reminders (Care_Records___Reminder_Add_Profile(1/2).png).
class ProfileDetailScreen extends StatefulWidget {
  final CareProfile profile;

  const ProfileDetailScreen({super.key, required this.profile});

  @override
  State<ProfileDetailScreen> createState() => _ProfileDetailScreenState();
}

class _ProfileDetailScreenState extends State<ProfileDetailScreen> {
  bool _showRecords = true;
  bool _loading = true;

  List<CareRecord> _records = [];
  List<CareReminder> _reminders = [];

  String _recordFilter = 'Health';
  static const _categories = ['Health', 'Growth', 'Vaccines', 'Nutrition'];

  DateTime _visibleMonth = DateTime(DateTime.now().year, DateTime.now().month);
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final records = await CareStorageService.loadRecords(widget.profile.id);
    final reminders = await CareStorageService.loadReminders(widget.profile.id);
    if (!mounted) return;
    setState(() {
      _records = records;
      _reminders = reminders;
      _loading = false;
    });
  }

  List<CareRecord> get _filteredRecords =>
      _records.where((r) => r.category == _recordFilter).toList();

  List<CareReminder> get _todayReminders => _reminders
      .where((r) => AgeUtils.isSameDay(r.date, DateTime.now()))
      .toList();

  List<CareReminder> get _tomorrowReminders {
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    return _reminders.where((r) => AgeUtils.isSameDay(r.date, tomorrow)).toList();
  }

  Future<void> _openAddRecord() async {
    final saved = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) => AddEditRecordScreen(profileId: widget.profile.id),
      ),
    );
    if (saved == true) _load();
  }

  Future<void> _openEditRecord(CareRecord record) async {
    final saved = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) => AddEditRecordScreen(
          profileId: widget.profile.id,
          existing: record,
        ),
      ),
    );
    if (saved == true) _load();
  }

  Future<void> _openAddReminder() async {
    final saved = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) => AddEditReminderScreen(
          profileId: widget.profile.id,
          initialDate: _selectedDate,
        ),
      ),
    );
    if (saved == true) _load();
  }

  Future<void> _openEditReminder(CareReminder reminder) async {
    final saved = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) => AddEditReminderScreen(
          profileId: widget.profile.id,
          existing: reminder,
        ),
      ),
    );
    if (saved == true) _load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButton: PressableScale(
        child: FloatingActionButton(
          backgroundColor: AppColors.maroon,
          onPressed: _showRecords ? _openAddRecord : _openAddReminder,
          child: const Icon(Icons.add, color: Colors.white),
        ),
      ),
      body: SafeArea(
        child: _loading
            ? const Center(child: CircularProgressIndicator())
            : ListView(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 100),
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.of(context).pop(),
                        child: const Icon(Icons.chevron_left, size: 26),
                      ),
                      const SizedBox(width: 4),
                      const Text('Back', style: TextStyle(fontSize: 14)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const CircleAvatar(
                        radius: 32,
                        backgroundColor: Color(0xFF63263B),
                      ),
                      const SizedBox(width: 14),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.profile.name,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                              color: AppColors.pink,
                            ),
                          ),
                          Text(
                            AgeUtils.describe(widget.profile.birthDate),
                            style: const TextStyle(
                                fontSize: 12, color: AppColors.pink),
                          ),
                          const SizedBox(height: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 3),
                            decoration: BoxDecoration(
                              color: AppColors.pink,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Text('Baby',
                                style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white)),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(child: _toggleButton('Records', true)),
                      const SizedBox(width: 12),
                      Expanded(child: _toggleButton('Reminders', false)),
                    ],
                  ),
                  const SizedBox(height: 20),
                  if (_showRecords) _recordsView() else _remindersView(),
                ],
              ),
      ),
    );
  }

  Widget _toggleButton(String label, bool value) {
    final active = _showRecords == value;
    return PressableScale(
      child: GestureDetector(
        onTap: () => setState(() => _showRecords = value),
        child: Container(
          height: 44,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: active ? AppColors.pink : const Color(0xFFF6D3E0),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: active ? Colors.white : Colors.white70,
            ),
          ),
        ),
      ),
    );
  }

  Widget _recordsView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 36,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: _categories.length,
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemBuilder: (context, i) {
              final c = _categories[i];
              final active = c == _recordFilter;
              return GestureDetector(
                onTap: () => setState(() => _recordFilter = c),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: active ? AppColors.pink : Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                      color: active ? AppColors.pink : const Color(0xFFE3B7C8),
                    ),
                  ),
                  child: Text(
                    c,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: active ? Colors.white : const Color(0xFFE3B7C8),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 16),
        if (_filteredRecords.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 24),
            child: Center(
              child: Text('No records yet. Tap + to add one.',
                  style: TextStyle(color: Colors.black54)),
            ),
          )
        else
          for (final r in _filteredRecords) _recordTile(r),
      ],
    );
  }

  Widget _recordTile(CareRecord record) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
          side: const BorderSide(color: Color(0xFFF0C4D4)),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: () => _openEditRecord(record),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 20,
                  backgroundColor: Color(0xFF63263B),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AgeUtils.formatDate(record.date),
                        style: const TextStyle(fontSize: 11, color: AppColors.pink),
                      ),
                      Text(
                        record.title,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF3A3A3A),
                        ),
                      ),
                      if (record.value.isNotEmpty) Text(record.value),
                      if (record.notes.isNotEmpty)
                        Text('Notes: ${record.notes}',
                            style: const TextStyle(
                                fontSize: 12, fontStyle: FontStyle.italic)),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right, color: AppColors.pink),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _remindersView() {
    final marked = _reminders.map((r) => r.date).toSet();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        MonthCalendar(
          month: _visibleMonth,
          markedDates: marked,
          selectedDate: _selectedDate,
          onDaySelected: (d) => setState(() => _selectedDate = d),
          onPrevMonth: () => setState(() {
            _visibleMonth =
                DateTime(_visibleMonth.year, _visibleMonth.month - 1);
          }),
          onNextMonth: () => setState(() {
            _visibleMonth =
                DateTime(_visibleMonth.year, _visibleMonth.month + 1);
          }),
        ),
        const SizedBox(height: 20),
        const Text(
          'UPCOMING REMINDERS',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w800,
            color: AppColors.pink,
          ),
        ),
        const SizedBox(height: 6),
        Text('Today, ${AgeUtils.formatDate(DateTime.now())}',
            style: const TextStyle(fontSize: 12, color: AppColors.pink)),
        const SizedBox(height: 8),
        if (_todayReminders.isEmpty)
          _emptyReminderRow()
        else
          for (final r in _todayReminders) _reminderTile(r),
        const SizedBox(height: 16),
        const Text(
          'TOMORROW',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w800,
            color: AppColors.pink,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          AgeUtils.formatDate(DateTime.now().add(const Duration(days: 1))),
          style: const TextStyle(fontSize: 12, color: AppColors.pink),
        ),
        const SizedBox(height: 8),
        if (_tomorrowReminders.isEmpty)
          _emptyReminderRow()
        else
          for (final r in _tomorrowReminders) _reminderTile(r),
      ],
    );
  }

  Widget _emptyReminderRow() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFF0C4D4)),
      ),
      child: const Text('No reminders.',
          style: TextStyle(fontSize: 12, color: Colors.black54)),
    );
  }

  Widget _reminderTile(CareReminder reminder) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.pink),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  reminder.title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColors.pink,
                  ),
                ),
                Text(reminder.time,
                    style:
                        const TextStyle(fontSize: 12, color: Colors.black54)),
              ],
            ),
          ),
          GestureDetector(
            onTap: () => _openEditReminder(reminder),
            child: const Text(
              'Edit',
              style: TextStyle(
                fontSize: 13,
                color: AppColors.pink,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
