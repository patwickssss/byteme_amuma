import 'package:flutter/material.dart';
import '../services/mock_auth_service.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../utils/app_routes.dart';
import '../widgets/amuma_button.dart';
import '../widgets/amuma_text_field.dart';
import '../widgets/gradient_background.dart';
import '../widgets/social_login_button.dart';
import 'login_screen.dart';

/// Sign Up screen — fields match Figma (email, password, confirm password).
/// Creates a mock account in local storage, then goes to Login.
class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

enum _PasswordStrength { weak, fair, strong }

class _SignUpScreenState extends State<SignUpScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();

  final _passwordFocus = FocusNode();
  final _confirmFocus = FocusNode();

  bool _obscurePassword = true;
  bool _obscureConfirm = true;
  bool _isLoading = false;

  String? _emailError;
  String? _passwordError;
  String? _confirmError;
  String? _formError;

  static final RegExp _emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    _passwordFocus.dispose();
    _confirmFocus.dispose();
    super.dispose();
  }

  _PasswordStrength _strengthOf(String password) {
    if (password.isEmpty) return _PasswordStrength.weak;
    var score = 0;
    if (password.length >= 8) score++;
    if (RegExp(r'[A-Z]').hasMatch(password)) score++;
    if (RegExp(r'[0-9]').hasMatch(password)) score++;
    if (RegExp(r'[^A-Za-z0-9]').hasMatch(password)) score++;
    if (score >= 3) return _PasswordStrength.strong;
    if (score >= 1) return _PasswordStrength.fair;
    return _PasswordStrength.weak;
  }

  bool _validate() {
    setState(() {
      _formError = null;

      final email = _emailController.text.trim();
      if (email.isEmpty) {
        _emailError = 'Please enter your email.';
      } else if (!_emailRegex.hasMatch(email)) {
        _emailError = 'Please enter a valid email.';
      } else {
        _emailError = null;
      }

      final password = _passwordController.text;
      _passwordError = password.isEmpty ? 'Please enter a password.' : null;

      final confirm = _confirmController.text;
      if (confirm.isEmpty) {
        _confirmError = 'Please confirm your password.';
      } else if (confirm != password) {
        _confirmError = 'Passwords do not match.';
      } else {
        _confirmError = null;
      }
    });

    return _emailError == null &&
        _passwordError == null &&
        _confirmError == null;
  }

  Future<void> _handleSignUp() async {
    if (_isLoading) return;
    FocusScope.of(context).unfocus();
    if (!_validate()) return;

    setState(() => _isLoading = true);

    try {
      final error = await MockAuthService.createAccount(
        email: _emailController.text,
        password: _passwordController.text,
      );
      if (!mounted) return;

      if (error != null) {
        setState(() => _emailError = error);
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: AppColors.maroon,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          content: const Row(
            children: [
              Icon(Icons.check_circle, color: Colors.white, size: 20),
              SizedBox(width: 10),
              Text('Account created — you can log in now.'),
            ],
          ),
        ),
      );
      Navigator.of(context).pushReplacement(
        fadeScaleRoute(const LoginScreen()),
      );
    } catch (_) {
      if (!mounted) return;
      setState(() => _formError = 'Something went wrong. Please try again.');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Widget _visibilityToggle(bool obscure, VoidCallback onTap) {
    return IconButton(
      icon: Icon(
        obscure ? Icons.visibility_off : Icons.visibility,
        color: Colors.white70,
      ),
      onPressed: onTap,
    );
  }

  Widget _strengthHint() {
    if (_passwordController.text.isEmpty) return const SizedBox.shrink();
    final strength = _strengthOf(_passwordController.text);
    final (label, color) = switch (strength) {
      _PasswordStrength.weak => ('Weak — try adding a number or symbol', const Color(0xFFFFD9D6)),
      _PasswordStrength.fair => ('Fair — a little longer helps', const Color(0xFFFFE9C2)),
      _PasswordStrength.strong => ('Strong password', const Color(0xFFCFF3D8)),
    };
    return Padding(
      padding: const EdgeInsets.only(top: 6, left: 4),
      child: Text(label, style: TextStyle(fontSize: 12, color: color)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradientBackground(
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 40, 24, 24),
            child: Column(
              children: [
                const Text(
                  'CREATE\nACCOUNT',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.heroHeading,
                ),
                const SizedBox(height: 8),
                Text(
                  'to get started now!',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.heroSubtitle.copyWith(fontSize: 26),
                ),
                const SizedBox(height: 40),

                AmumaTextField(
                  controller: _emailController,
                  hintText: 'Email Address',
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  onSubmitted: (_) => _passwordFocus.requestFocus(),
                  errorText: _emailError,
                  onChanged: (_) {
                    if (_emailError != null) setState(() => _emailError = null);
                  },
                ),
                const SizedBox(height: 16),

                AmumaTextField(
                  controller: _passwordController,
                  focusNode: _passwordFocus,
                  hintText: 'Password',
                  obscureText: _obscurePassword,
                  textInputAction: TextInputAction.next,
                  onSubmitted: (_) => _confirmFocus.requestFocus(),
                  errorText: _passwordError,
                  onChanged: (_) {
                    setState(() {
                      if (_passwordError != null) _passwordError = null;
                    });
                  },
                  suffixIcon: _visibilityToggle(
                    _obscurePassword,
                    () => setState(() => _obscurePassword = !_obscurePassword),
                  ),
                ),
                Align(alignment: Alignment.centerLeft, child: _strengthHint()),
                const SizedBox(height: 16),

                AmumaTextField(
                  controller: _confirmController,
                  focusNode: _confirmFocus,
                  hintText: 'Confirm Password',
                  obscureText: _obscureConfirm,
                  textInputAction: TextInputAction.done,
                  onSubmitted: (_) => _handleSignUp(),
                  errorText: _confirmError,
                  onChanged: (_) {
                    if (_confirmError != null) {
                      setState(() => _confirmError = null);
                    }
                  },
                  suffixIcon: _visibilityToggle(
                    _obscureConfirm,
                    () => setState(() => _obscureConfirm = !_obscureConfirm),
                  ),
                ),

                if (_formError != null) ...[
                  const SizedBox(height: 12),
                  Text(
                    _formError!,
                    style: AppTextStyles.fieldError.copyWith(fontSize: 13),
                  ),
                ],

                const SizedBox(height: 28),
                AmumaPrimaryButton(
                  label: 'Sign Up',
                  isLoading: _isLoading,
                  onPressed: _handleSignUp,
                ),
                const SizedBox(height: 14),
                Text(
                  'By signing up you agree to our Terms of Service and '
                  'Privacy Policy.',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.footerText.copyWith(
                    fontSize: 12,
                    color: Colors.white70,
                  ),
                ),

                const SizedBox(height: 32),
                const Row(
                  children: [
                    Expanded(child: Divider(color: Colors.white54)),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      child: Text('Or Login with',
                          style: AppTextStyles.dividerText),
                    ),
                    Expanded(child: Divider(color: Colors.white54)),
                  ],
                ),
                const SizedBox(height: 20),
                const Row(
                  children: [
                    Expanded(
                      child: SocialLoginButton(
                        label: 'Google',
                        icon: Icons.g_mobiledata_rounded,
                        iconColor: Color(0xFFDB4437),
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: SocialLoginButton(
                        label: 'Facebook',
                        icon: Icons.facebook,
                        iconColor: Color(0xFF1877F2),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 48),
                Wrap(
                  alignment: WrapAlignment.center,
                  children: [
                    const Text('Already have an account?  ',
                        style: AppTextStyles.footerText),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pushReplacement(
                          fadeScaleRoute(const LoginScreen()),
                        );
                      },
                      child: const Text('Login Now',
                          style: AppTextStyles.footerLink),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
