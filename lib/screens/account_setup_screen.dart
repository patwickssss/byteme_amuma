import 'package:flutter/material.dart';
import '../services/mock_auth_service.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../utils/app_routes.dart';
import '../widgets/amuma_button.dart';
import '../widgets/gradient_background.dart';
import '../widgets/onboarding_progress.dart';
import '../widgets/pressable_scale.dart';
import 'main_shell.dart';

/// "Let's set up your account" — a short 4-step onboarding flow saved
/// into the mock user's profile (local only, no backend):
///   1. First-time parent?
///   2. What should we call you?
///   3. Who are you expecting or caring for?
///   4. Preferred language
/// Every step can be skipped; skipping or finishing both go to the Main
/// Shell, saving whatever was answered so far.
class AccountSetupScreen extends StatefulWidget {
  const AccountSetupScreen({super.key});

  @override
  State<AccountSetupScreen> createState() => _AccountSetupScreenState();
}

class _AccountSetupScreenState extends State<AccountSetupScreen> {
  static const int _totalSteps = 4;

  int _step = 0;
  bool _saving = false;

  bool? _firstTimeParent;
  final TextEditingController _nameController = TextEditingController();
  String? _caringFor;
  String? _language;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _finish() async {
    if (_saving) return;
    setState(() => _saving = true);

    final answers = <String, dynamic>{
      if (_firstTimeParent != null) 'firstTimeParent': _firstTimeParent,
      if (_nameController.text.trim().isNotEmpty)
        'name': _nameController.text.trim(),
      if (_caringFor != null) 'caringFor': _caringFor,
      if (_language != null) 'language': _language,
    };

    try {
      if (answers.isNotEmpty) {
        await MockAuthService.saveProfile(answers);
      }
      if (!mounted) return;
      Navigator.of(context).pushAndRemoveUntil(
        fadeScaleRoute(const MainShell()),
        (route) => false,
      );
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  void _next() {
    if (_step == _totalSteps - 1) {
      _finish();
    } else {
      setState(() => _step++);
    }
  }

  void _back() {
    if (_step > 0) setState(() => _step--);
  }

  bool get _canContinue {
    switch (_step) {
      case 0:
        return _firstTimeParent != null;
      case 1:
        return _nameController.text.trim().isNotEmpty;
      case 2:
        return _caringFor != null;
      case 3:
        return _language != null;
      default:
        return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradientBackground(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                const SizedBox(height: 16),
                Row(
                  children: [
                    SizedBox(
                      width: 40,
                      child: _step > 0
                          ? IconButton(
                              onPressed: _saving ? null : _back,
                              icon: const Icon(Icons.arrow_back, color: Colors.white),
                            )
                          : null,
                    ),
                    Expanded(
                      child: OnboardingProgress(
                        totalSteps: _totalSteps,
                        currentStep: _step,
                      ),
                    ),
                    const SizedBox(width: 40),
                  ],
                ),
                Expanded(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 280),
                    transitionBuilder: (child, animation) => FadeTransition(
                      opacity: animation,
                      child: SlideTransition(
                        position: Tween<Offset>(
                          begin: const Offset(0.08, 0),
                          end: Offset.zero,
                        ).animate(animation),
                        child: child,
                      ),
                    ),
                    child: KeyedSubtree(
                      key: ValueKey(_step),
                      child: _stepContent(),
                    ),
                  ),
                ),
                AmumaPrimaryButton(
                  label: _step == _totalSteps - 1 ? 'Finish' : 'Continue',
                  isLoading: _saving,
                  onPressed: _canContinue ? _next : null,
                ),
                const SizedBox(height: 14),
                Padding(
                  padding: const EdgeInsets.only(bottom: 24),
                  child: GestureDetector(
                    onTap: _saving ? null : _finish,
                    child: const Text(
                      'Skip for now',
                      style: AppTextStyles.footerLink,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _stepContent() {
    switch (_step) {
      case 0:
        return _choiceStep(
          title: "Let's set up\nyour account",
          subtitle: 'Are you a first-time parent?',
          options: const ['Yes', 'No'],
          selected: _firstTimeParent == null
              ? null
              : (_firstTimeParent! ? 'Yes' : 'No'),
          onSelect: (v) => setState(() => _firstTimeParent = v == 'Yes'),
        );
      case 1:
        return _nameStep();
      case 2:
        return _choiceStep(
          title: 'Tell us a bit\nmore',
          subtitle: 'Who are you expecting or caring for?',
          options: const ['Expecting', 'Newborn', 'Toddler', 'Not sure'],
          selected: _caringFor,
          onSelect: (v) => setState(() => _caringFor = v),
          vertical: true,
        );
      case 3:
        return _choiceStep(
          title: 'Almost\ndone',
          subtitle: 'Preferred language',
          options: const ['English', 'Tagalog', 'Taglish'],
          selected: _language,
          onSelect: (v) => setState(() => _language = v),
          vertical: true,
        );
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _heading(String title, String subtitle) {
    return Column(
      children: [
        const SizedBox(height: 24),
        Text(
          title,
          textAlign: TextAlign.center,
          style: AppTextStyles.heroHeading.copyWith(
            fontSize: 36,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 24),
        Text(
          subtitle,
          textAlign: TextAlign.center,
          style: AppTextStyles.heroSubtitle.copyWith(
            fontSize: 22,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }

  Widget _nameStep() {
    return SingleChildScrollView(
      child: Column(
        children: [
          _heading('Nice to\nmeet you', 'What should we call you?'),
          const SizedBox(height: 32),
          TextField(
            controller: _nameController,
            textAlign: TextAlign.center,
            textInputAction: TextInputAction.done,
            onChanged: (_) => setState(() {}),
            onSubmitted: (_) => _canContinue ? _next() : null,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.w600,
            ),
            decoration: InputDecoration(
              hintText: 'Your name',
              hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.6)),
              enabledBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white54),
              ),
              focusedBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white, width: 2),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _choiceStep({
    required String title,
    required String subtitle,
    required List<String> options,
    required String? selected,
    required ValueChanged<String> onSelect,
    bool vertical = false,
  }) {
    final buttons = [
      for (final option in options)
        _choiceButton(option, selected == option, () => onSelect(option)),
    ];

    return SingleChildScrollView(
      child: Column(
        children: [
          _heading(title, subtitle),
          const SizedBox(height: 32),
          if (vertical)
            Column(
              children: [
                for (final b in buttons)
                  Padding(padding: const EdgeInsets.only(bottom: 12), child: b),
              ],
            )
          else
            Row(
              children: [
                for (var i = 0; i < buttons.length; i++) ...[
                  if (i > 0) const SizedBox(width: 16),
                  Expanded(child: buttons[i]),
                ],
              ],
            ),
        ],
      ),
    );
  }

  Widget _choiceButton(String label, bool active, VoidCallback onTap) {
    return PressableScale(
      child: SizedBox(
        width: double.infinity,
        height: 56,
        child: ElevatedButton(
          onPressed: onTap,
          style: ElevatedButton.styleFrom(
            backgroundColor: active ? AppColors.maroon : Colors.white,
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
              side: BorderSide(
                color: active ? AppColors.maroon : Colors.transparent,
                width: 1.5,
              ),
            ),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w700,
              color: active ? Colors.white : AppColors.setupChoiceText,
            ),
          ),
        ),
      ),
    );
  }
}
