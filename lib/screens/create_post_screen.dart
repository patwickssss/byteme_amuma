import 'package:flutter/material.dart';

import '../models/community_models.dart';
import '../services/community_storage_service.dart';
import '../services/mock_auth_service.dart';
import '../theme/app_colors.dart';
import '../utils/display_name.dart';
import '../widgets/pressable_scale.dart';

/// Create Post form. No mockup exists for this screen — styled to match
/// the rest of the app.
class CreatePostScreen extends StatefulWidget {
  const CreatePostScreen({super.key});

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  static const _categories = ['Pregnancy', 'Childcare', 'Family'];

  String _category = _categories.first;
  final _titleController = TextEditingController();
  final _bodyController = TextEditingController();

  String? _titleError;
  String? _bodyError;
  bool _saving = false;

  @override
  void dispose() {
    _titleController.dispose();
    _bodyController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_saving) return;
    setState(() {
      _titleError =
          _titleController.text.trim().isEmpty ? 'Please enter a title.' : null;
      _bodyError =
          _bodyController.text.trim().isEmpty ? 'Please write something.' : null;
    });
    if (_titleError != null || _bodyError != null) return;

    setState(() => _saving = true);
    try {
      final user = await MockAuthService.getStoredAccount();
      final email = user?.email ?? 'guest@example.com';

      final post = CommunityPost(
        id: CommunityStorageService.newId(),
        authorEmail: email,
        authorDisplay: DisplayName.fromEmail(email),
        category: _category,
        title: _titleController.text.trim(),
        body: _bodyController.text.trim(),
        date: DateTime.now(),
      );

      await CommunityStorageService.addPost(post);
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
              const SizedBox(height: 8),
              const Text(
                'Create Post',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: AppColors.maroon,
                ),
              ),
              const SizedBox(height: 20),
              const _Label('Category'),
              Wrap(
                spacing: 8,
                children: [
                  for (final c in _categories)
                    GestureDetector(
                      onTap: () => setState(() => _category = c),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color:
                              _category == c ? AppColors.pink : Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: _category == c
                                ? AppColors.pink
                                : const Color(0xFFE3B7C8),
                          ),
                        ),
                        child: Text(
                          c,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: _category == c
                                ? Colors.white
                                : const Color(0xFFE3B7C8),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 18),
              const _Label('Title'),
              _field(
                controller: _titleController,
                hint: 'What do you want to ask or share?',
                error: _titleError,
                onChanged: (_) {
                  if (_titleError != null) setState(() => _titleError = null);
                },
              ),
              const SizedBox(height: 16),
              const _Label('Details'),
              _field(
                controller: _bodyController,
                hint: 'Add more context for other parents...',
                error: _bodyError,
                maxLines: 5,
                onChanged: (_) {
                  if (_bodyError != null) setState(() => _bodyError = null);
                },
              ),
              const SizedBox(height: 28),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: PressableScale(
                  enabled: !_saving,
                  child: ElevatedButton(
                    onPressed: _saving ? null : _submit,
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
                        : const Text(
                            'Post',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                                fontSize: 16),
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

class _Label extends StatelessWidget {
  final String text;
  const _Label(this.text);

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
