import 'package:flutter/material.dart';

import '../models/care_models.dart';
import '../services/care_storage_service.dart';
import '../theme/app_colors.dart';
import '../utils/age_utils.dart';
import '../widgets/pressable_scale.dart';

/// Add or edit a Reminder (title, date, time). No mockup exists for the
/// form itself — styled to match the rest of Care Records.
class AddEditReminderScreen extends StatefulWidget {
  final String profileId;
  final CareReminder? existing;
  final DateTime? initialDate;

  const AddEditReminderScreen({
    super.key,
    required this.profileId,
    this.existing,
    this.initialDate,
  });

  @override
  State<AddEditReminderScreen> createState() => _AddEditReminderScreenState();
}

class _AddEditReminderScreenState extends State<AddEditReminderScreen> {
  late TextEditingController _titleController;
  late DateTime _date;
  TimeOfDay _time = const TimeOfDay(hour: 10, minute: 0);

  String? _titleError;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    final e = widget.existing;
    _titleController = TextEditingController(text: e?.title ?? '');
    _date = e?.date ?? widget.initialDate ?? DateTime.now();
    if (e != null) {
      _time = _parseTime(e.time) ?? _time;
    }
  }

  TimeOfDay? _parseTime(String text) {
    final match = RegExp(r'(\d{1,2}):(\d{2})\s*(AM|PM)?', caseSensitive: false)
        .firstMatch(text);
    if (match == null) return null;
    var h = int.parse(match.group(1)!);
    final m = int.parse(match.group(2)!);
    final period = match.group(3)?.toUpperCase();
    if (period == 'PM' && h != 12) h += 12;
    if (period == 'AM' && h == 12) h = 0;
    return TimeOfDay(hour: h, minute: m);
  }

  String _formatTime(TimeOfDay t) {
    final hour12 = t.hourOfPeriod == 0 ? 12 : t.hourOfPeriod;
    final period = t.period == DayPeriod.am ? 'AM' : 'PM';
    return '${hour12.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')} $period';
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2015),
      lastDate: DateTime(2100),
    );
    if (picked != null) setState(() => _date = picked);
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(context: context, initialTime: _time);
    if (picked != null) setState(() => _time = picked);
  }

  Future<void> _save() async {
    if (_saving) return;
    if (_titleController.text.trim().isEmpty) {
      setState(() => _titleError = 'Please enter a reminder title.');
      return;
    }
    setState(() => _saving = true);

    final reminder = CareReminder(
      id: widget.existing?.id ?? CareStorageService.newId(),
      profileId: widget.profileId,
      title: _titleController.text.trim(),
      date: DateTime(_date.year, _date.month, _date.day),
      time: _formatTime(_time),
    );

    await CareStorageService.upsertReminder(reminder);
    if (!mounted) return;
    Navigator.of(context).pop(true);
  }

  Future<void> _delete() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete reminder?'),
        content: const Text('This cannot be undone.'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Cancel')),
          TextButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text('Delete',
                  style: TextStyle(color: AppColors.errorRed))),
        ],
      ),
    );
    if (confirmed == true) {
      await CareStorageService.deleteReminder(widget.existing!.id);
      if (!mounted) return;
      Navigator.of(context).pop(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.existing != null;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: const Icon(Icons.chevron_left, size: 26),
                  ),
                  const SizedBox(width: 4),
                  const Text('Back', style: TextStyle(fontSize: 14)),
                  const Spacer(),
                  if (isEdit)
                    IconButton(
                      onPressed: _delete,
                      icon: const Icon(Icons.delete_outline,
                          color: AppColors.errorRed),
                    ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                isEdit ? 'Edit Reminder' : 'Add Reminder',
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: AppColors.maroon,
                ),
              ),
              const SizedBox(height: 20),
              const _FieldLabel('Title'),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: _titleError != null
                            ? AppColors.errorFieldBorder
                            : AppColors.pink,
                      ),
                    ),
                    child: TextField(
                      controller: _titleController,
                      onChanged: (_) {
                        if (_titleError != null) {
                          setState(() => _titleError = null);
                        }
                      },
                      decoration: const InputDecoration(
                        hintText: "e.g. Benny's Check-up",
                        hintStyle: TextStyle(color: AppColors.pink, fontSize: 13),
                        border: InputBorder.none,
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      ),
                    ),
                  ),
                  if (_titleError != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(_titleError!,
                          style: const TextStyle(
                              fontSize: 11, color: AppColors.errorRed)),
                    ),
                ],
              ),
              const SizedBox(height: 16),
              const _FieldLabel('Date'),
              GestureDetector(
                onTap: _pickDate,
                child: Container(
                  height: 50,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.pink),
                  ),
                  alignment: Alignment.centerLeft,
                  child: Text(AgeUtils.formatDate(_date),
                      style: const TextStyle(fontSize: 14)),
                ),
              ),
              const SizedBox(height: 16),
              const _FieldLabel('Time'),
              GestureDetector(
                onTap: _pickTime,
                child: Container(
                  height: 50,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.pink),
                  ),
                  alignment: Alignment.centerLeft,
                  child: Text(_formatTime(_time),
                      style: const TextStyle(fontSize: 14)),
                ),
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: PressableScale(
                  enabled: !_saving,
                  child: ElevatedButton(
                    onPressed: _saving ? null : _save,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.maroon,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: _saving
                        ? const SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(
                                strokeWidth: 2.4, color: Colors.white),
                          )
                        : Text(isEdit ? 'Save Changes' : 'Add Reminder',
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                                fontSize: 16)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  final String text;
  const _FieldLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w700,
          color: AppColors.pink,
        ),
      ),
    );
  }
}
