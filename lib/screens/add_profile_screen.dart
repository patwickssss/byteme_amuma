import 'package:flutter/material.dart';

import '../models/care_models.dart';
import '../services/care_storage_service.dart';
import '../theme/app_colors.dart';
import '../widgets/pressable_scale.dart';

/// "Add Child Profile" form (Care_Records___Reminder_Add_Profile*.png).
/// Photo upload is a non-working placeholder button, per spec.
class AddProfileScreen extends StatefulWidget {
  const AddProfileScreen({super.key});

  @override
  State<AddProfileScreen> createState() => _AddProfileScreenState();
}

class _AddProfileScreenState extends State<AddProfileScreen> {
  final _nameController = TextEditingController();
  DateTime? _birthDate;
  String? _gender;
  String? _relationship;

  String? _nameError;
  String? _dobError;
  String? _genderError;
  String? _relationshipError;
  bool _saving = false;

  static const _relationships = ['Parent', 'Guardian', 'Relative', 'Other'];

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime(now.year - 1, now.month, now.day),
      firstDate: DateTime(now.year - 18),
      lastDate: now,
    );
    if (picked != null) {
      setState(() {
        _birthDate = picked;
        _dobError = null;
      });
    }
  }

  bool _validate() {
    setState(() {
      _nameError =
          _nameController.text.trim().isEmpty ? "Please enter the child's name." : null;
      _dobError = _birthDate == null ? 'Please select a date of birth.' : null;
      _genderError = _gender == null ? 'Please select a gender.' : null;
      _relationshipError =
          _relationship == null ? 'Please select a relationship.' : null;
    });
    return _nameError == null &&
        _dobError == null &&
        _genderError == null &&
        _relationshipError == null;
  }

  Future<void> _save() async {
    if (_saving) return;
    if (!_validate()) return;

    setState(() => _saving = true);
    try {
      final profile = CareProfile(
        id: CareStorageService.newId(),
        name: _nameController.text.trim(),
        birthDate: _birthDate!,
        gender: _gender!,
        relationship: _relationship!,
      );
      await CareStorageService.addProfile(profile);
      if (!mounted) return;
      Navigator.of(context).pop(true);
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
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
                ],
              ),
              const SizedBox(height: 12),
              const Center(
                child: Text(
                  'Add Child Profile',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: AppColors.maroon,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              const Center(
                child: Text(
                  "Register your child so you can keep track of their\ngrowth, health and important reminders.",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 12, color: Colors.black54),
                ),
              ),
              const SizedBox(height: 24),
              Center(
                child: Column(
                  children: [
                    const CircleAvatar(
                      radius: 46,
                      backgroundColor: Color(0xFF63263B),
                    ),
                    const SizedBox(height: 14),
                    PressableScale(
                      child: ElevatedButton(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Photo upload coming in a later build.'),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.maroon,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 28, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: const Text(
                          'Add Photo',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),
              _label('Full Name*'),
              _textField(
                controller: _nameController,
                hint: "Enter Child's Name",
                error: _nameError,
                onChanged: (_) {
                  if (_nameError != null) setState(() => _nameError = null);
                },
              ),
              const SizedBox(height: 18),
              _label('Date of Birth*'),
              GestureDetector(
                onTap: _pickDate,
                child: Container(
                  height: 50,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: _dobError != null
                          ? AppColors.errorFieldBorder
                          : AppColors.pink,
                    ),
                  ),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    _birthDate == null
                        ? "Enter Child's Date of Birth"
                        : '${_birthDate!.month}/${_birthDate!.day}/${_birthDate!.year}',
                    style: TextStyle(
                      fontSize: 14,
                      color: _birthDate == null ? AppColors.pink : Colors.black87,
                    ),
                  ),
                ),
              ),
              if (_dobError != null) _errorText(_dobError!),
              const SizedBox(height: 18),
              _label('Gender*'),
              Row(
                children: [
                  _choiceChip('Male'),
                  const SizedBox(width: 10),
                  _choiceChip('Female'),
                  const SizedBox(width: 10),
                  Expanded(child: _choiceChip('Prefer not to say')),
                ],
              ),
              if (_genderError != null) _errorText(_genderError!),
              const SizedBox(height: 18),
              _label('Relationship to you*'),
              Container(
                height: 50,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: _relationshipError != null
                        ? AppColors.errorFieldBorder
                        : AppColors.pink,
                  ),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _relationship,
                    isExpanded: true,
                    hint: const Text('Select Relationship',
                        style: TextStyle(color: AppColors.pink, fontSize: 14)),
                    icon: const Icon(Icons.keyboard_arrow_down,
                        color: AppColors.pink),
                    items: _relationships
                        .map((r) => DropdownMenuItem(value: r, child: Text(r)))
                        .toList(),
                    onChanged: (v) => setState(() {
                      _relationship = v;
                      _relationshipError = null;
                    }),
                  ),
                ),
              ),
              if (_relationshipError != null) _errorText(_relationshipError!),
              const SizedBox(height: 32),
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
                              strokeWidth: 2.4,
                              color: Colors.white,
                            ),
                          )
                        : const Text(
                            'Save Profile',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 16,
                            ),
                          ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _label(String text) => Padding(
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

  Widget _errorText(String text) => Padding(
        padding: const EdgeInsets.only(top: 4),
        child: Text(text,
            style: const TextStyle(fontSize: 11, color: AppColors.errorRed)),
      );

  Widget _textField({
    required TextEditingController controller,
    required String hint,
    String? error,
    ValueChanged<String>? onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 50,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: error != null ? AppColors.errorFieldBorder : AppColors.pink,
            ),
          ),
          child: TextField(
            controller: controller,
            onChanged: onChanged,
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: const TextStyle(color: AppColors.pink, fontSize: 14),
              border: InputBorder.none,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            ),
          ),
        ),
        if (error != null) _errorText(error),
      ],
    );
  }

  Widget _choiceChip(String label) {
    final active = _gender == label;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() {
          _gender = label;
          _genderError = null;
        }),
        child: Container(
          height: 46,
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: 6),
          decoration: BoxDecoration(
            color: active ? AppColors.maroon : Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: active ? AppColors.maroon : AppColors.pink,
            ),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: active ? Colors.white : AppColors.pink,
            ),
          ),
        ),
      ),
    );
  }
}
