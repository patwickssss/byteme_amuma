import 'package:flutter/material.dart';
import '../services/mock_auth_service.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../widgets/gradient_background.dart';
import '../widgets/pressable_scale.dart';
import '../utils/app_routes.dart';
import 'main_shell.dart';

/// "Let's set up your account" — first onboarding question from Figma
/// (Get_Info.png): first-time parent? Yes / No, or skip.
/// The answer is saved to the mock user's profile (local only).
class AccountSetupScreen extends StatefulWidget {
  const AccountSetupScreen({super.key});

  @override
  State<AccountSetupScreen> createState() => _AccountSetupScreenState();
}

class _AccountSetupScreenState extends State<AccountSetupScreen> {
  bool _isSaving = false;

  Future<void> _answer(bool? firstTimeParent) async {
    if (_isSaving) return;
    setState(() => _isSaving = true);

    try {
      await MockAuthService.saveProfile({'firstTimeParent': firstTimeParent});
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Saved. Next setup screens are coming in a later build.'),
        ),
      );
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Something went wrong. Please try again.')),
      );
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  void _skip() {
    Navigator.of(context).pushReplacement(
      fadeScaleRoute(const MainShell()),
    );
  }

  Widget _choiceButton(String label, bool value) {
    return Expanded(
      child: PressableScale(
        enabled: !_isSaving,
        child: SizedBox(
          height: 56,
          child: ElevatedButton(
            onPressed: _isSaving ? null : () => _answer(value),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              disabledBackgroundColor: Colors.white.withValues(alpha: 0.7),
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: AppColors.setupChoiceText,
              ),
            ),
          ),
        ),
      ),
    );
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
                const Spacer(flex: 4),
                Text(
                  "Let's set up\nyour account",
                  textAlign: TextAlign.center,
                  style: AppTextStyles.heroHeading.copyWith(
                    fontSize: 44,
                    fontWeight: FontWeight.w600,
                    letterSpacing: -1.5,
                  ),
                ),
                const SizedBox(height: 56),
                Text(
                  'Are you a first-time\nparent?',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.heroSubtitle.copyWith(
                    fontSize: 28,
                    fontWeight: FontWeight.w300,
                  ),
                ),
                const SizedBox(height: 40),
                Row(
                  children: [
                    _choiceButton('Yes', true),
                    const SizedBox(width: 16),
                    _choiceButton('No', false),
                  ],
                ),
                const Spacer(flex: 7),
                Padding(
                  padding: const EdgeInsets.only(bottom: 24),
                  child: Wrap(
                    alignment: WrapAlignment.center,
                    children: [
                      const Text('Do this later?  ',
                          style: AppTextStyles.footerText),
                      GestureDetector(
                        onTap: _skip,
                        child: const Text('Click Skip',
                            style: AppTextStyles.footerLink),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}