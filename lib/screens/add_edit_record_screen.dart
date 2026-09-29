import 'package:flutter/material.dart';

import '../models/care_models.dart';
import '../services/care_storage_service.dart';
import '../theme/app_colors.dart';
import '../utils/age_utils.dart';
import '../widgets/pressable_scale.dart';

/// Add or edit one Care Record (weight, height, check-up, vaccine, notes...).
/// No mockup exists for this — styled to match the rest of Care Records.
class AddEditRecordScreen extends StatefulWidget {
  final String profileId;
  final CareRecord? existing;

  const AddEditRecordScreen({super.key, required this.profileId, this.existing});

  @override
  State<AddEditRecordScreen> createState() => _AddEditRecordScreenState();
}

class _AddEditRecordScreenState extends State<AddEditRecordScreen> {
  static const _categories = ['Health', 'Growth', 'Vaccines', 'Nutrition'];

  late String _category;
  late TextEditingController _titleController;
  late TextEditingController _valueController;
  late TextEditingController _notesController;
  late DateTime _date;

  String? _titleError;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    final e = widget.existing;
    _category = e?.category ?? _categories.first;
    _titleController = TextEditingController(text: e?.title ?? '');
    _valueController = TextEditingController(text: e?.value ?? '');
    _notesController = TextEditingController(text: e?.notes ?? '');
    _date = e?.date ?? DateTime.now();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _valueController.dispose();
    _notesController.dispose();
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

  Future<void> _save() async {
    if (_saving) return;
    if (_titleController.text.trim().isEmpty) {
      setState(() => _titleError = 'Please enter a title, e.g. "Weight".');
      return;
    }
    setState(() => _saving = true);

    final record = CareRecord(
      id: widget.existing?.id ?? CareStorageService.newId(),
      profileId: widget.profileId,
      category: _category,
      title: _titleController.text.trim(),
      value: _valueController.text.trim(),
      notes: _notesController.text.trim(),
      date: _date,
    );

    await CareStorageService.upsertRecord(record);
    if (!mounted) return;
    Navigator.of(context).pop(true);
  }

  Future<void> _delete() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete record?'),
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
      await CareStorageService.deleteRecord(widget.existing!.id);
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
                      icon:
                          const Icon(Icons.delete_outline, color: AppColors.errorRed),
                    ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                isEdit ? 'Edit Record' : 'Add Record',
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: AppColors.maroon,
                ),
              ),
              const SizedBox(height: 20),
              const _FieldLabel('Category'),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final c in _categories)
                    GestureDetector(
                      onTap: () => setState(() => _category = c),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color:
                              _category == c ? AppColors.maroon : Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: _category == c
                                ? AppColors.maroon
                                : AppColors.pink,
                          ),
                        ),
                        child: Text(
                          c,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: _category == c ? Colors.white : AppColors.pink,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 18),
              const _FieldLabel('Title'),
              _field(
                controller: _titleController,
                hint: 'e.g. Weight, Check-up, MMR Vaccine',
                error: _titleError,
                onChanged: (_) {
                  if (_titleError != null) setState(() => _titleError = null);
                },
              ),
              const SizedBox(height: 16),
              const _FieldLabel('Value (optional)'),
              _field(controller: _valueController, hint: 'e.g. 6.2 kg, 60 cm'),
              const SizedBox(height: 16),
              const _FieldLabel('Notes (optional)'),
              _field(
                controller: _notesController,
                hint: 'e.g. On Track',
                maxLines: 3,
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
                        : Text(isEdit ? 'Save Changes' : 'Add Record',
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

  Widget _field({
    required TextEditingController controller,
    required String hint,
    String? error,
    int maxLines = 1,
    ValueChanged<String>? onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: error != null ? AppColors.errorFieldBorder : AppColors.pink,
            ),
          ),
          child: TextField(
            controller: controller,
            maxLines: maxLines,
            onChanged: onChanged,
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: const TextStyle(color: AppColors.pink, fontSize: 13),
              border: InputBorder.none,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            ),
          ),
        ),
        if (error != null)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(error,
                style: const TextStyle(fontSize: 11, color: AppColors.errorRed)),
          ),
      ],
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
