import 'package:flutter/material.dart';
import '../services/mock_auth_service.dart';
import '../theme/app_text_styles.dart';
import '../widgets/amuma_button.dart';
import '../widgets/amuma_text_field.dart';
import '../widgets/gradient_background.dart';

/// MOCK password reset flow: enter email -> fake delay -> confirmation.
/// No real email is ever sent. Replace MockAuthService.resetPassword
/// with a real API call later.
class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _emailController = TextEditingController();
  String? _emailError;
  bool _loading = false;
  bool _sent = false;

  static final RegExp _emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_loading) return;
    final email = _emailController.text.trim();
    setState(() {
      _emailError = email.isEmpty
          ? 'Please enter your email.'
          : (!_emailRegex.hasMatch(email) ? 'Please enter a valid email.' : null);
    });
    if (_emailError != null) return;

    setState(() => _loading = true);
    await MockAuthService.resetPassword(email: email);
    if (!mounted) return;
    setState(() {
      _loading = false;
      _sent = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradientBackground(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                ),
                const SizedBox(height: 24),
                if (!_sent) ...[
                  const Text('Forgot Password?', style: AppTextStyles.heroHeading),
                  const SizedBox(height: 8),
                  Text(
                    "Enter the email on your account and we'll send you a "
                    'reset link.',
                    style: AppTextStyles.heroSubtitle.copyWith(fontSize: 16),
                  ),
                  const SizedBox(height: 32),
                  AmumaTextField(
                    controller: _emailController,
                    hintText: 'Email Address',
                    keyboardType: TextInputType.emailAddress,
                    errorText: _emailError,
                    onChanged: (_) {
                      if (_emailError != null) setState(() => _emailError = null);
                    },
                  ),
                  const SizedBox(height: 24),
                  AmumaPrimaryButton(
                    label: 'Send Reset Link',
                    isLoading: _loading,
                    onPressed: _submit,
                  ),
                ] else ...[
                  const Icon(Icons.mark_email_read_rounded,
                      color: Colors.white, size: 56),
                  const SizedBox(height: 20),
                  const Text('Check your email', style: AppTextStyles.heroHeading),
                  const SizedBox(height: 8),
                  Text(
                    "We've sent a reset link to ${_emailController.text.trim()}. "
                    '(Demo only — no real email was sent.)',
                    style: AppTextStyles.heroSubtitle.copyWith(fontSize: 16),
                  ),
                  const SizedBox(height: 32),
                  AmumaPrimaryButton(
                    label: 'Back to Login',
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
