import 'package:flutter/material.dart';
import '../services/mock_auth_service.dart';
import '../theme/app_text_styles.dart';
import '../utils/app_routes.dart';
import '../widgets/amuma_button.dart';
import '../widgets/amuma_text_field.dart';
import '../widgets/gradient_background.dart';
import 'login_screen.dart';

/// Sign Up screen — fields match Figma (email, password, confirm password).
/// Creates a mock account in local storage, then goes to Login.
class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();

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
    super.dispose();
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
        const SnackBar(content: Text('Account created successfully.')),
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

  void _comingSoon() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Coming in a later build.')),
    );
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
                  errorText: _emailError,
                  onChanged: (_) {
                    if (_emailError != null) setState(() => _emailError = null);
                  },
                ),
                const SizedBox(height: 16),

                AmumaTextField(
                  controller: _passwordController,
                  hintText: 'Password',
                  obscureText: _obscurePassword,
                  errorText: _passwordError,
                  onChanged: (_) {
                    if (_passwordError != null) {
                      setState(() => _passwordError = null);
                    }
                  },
                  suffixIcon: _visibilityToggle(
                    _obscurePassword,
                    () => setState(() => _obscurePassword = !_obscurePassword),
                  ),
                ),
                const SizedBox(height: 16),

                AmumaTextField(
                  controller: _confirmController,
                  hintText: 'Confirm Password',
                  obscureText: _obscureConfirm,
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

                const SizedBox(height: 32),
                AmumaPrimaryButton(
                  label: 'Sign Up',
                  isLoading: _isLoading,
                  onPressed: _handleSignUp,
                ),

                const SizedBox(height: 40),
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
                Row(
                  children: [
                    Expanded(
                      child: AmumaSocialPlaceholderButton(onPressed: _comingSoon),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: AmumaSocialPlaceholderButton(onPressed: _comingSoon),
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
