import 'package:flutter/material.dart';
import '../services/mock_auth_service.dart';
import '../theme/app_text_styles.dart';
import '../utils/app_routes.dart';
import '../widgets/amuma_button.dart';
import '../widgets/amuma_text_field.dart';
import '../widgets/gradient_background.dart';
import 'account_setup_screen.dart';
import 'sign_up_screen.dart';

/// Login screen — checks credentials against the locally stored mock
/// accounts (prototype only, no backend).
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _obscurePassword = true;
  bool _isLoading = false;

  String? _emailError;
  String? _passwordError;
  String? _authError;

  static final RegExp _emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  bool _validateFields() {
    setState(() {
      _authError = null;

      final email = _emailController.text.trim();
      if (email.isEmpty) {
        _emailError = 'Please enter your email.';
      } else if (!_emailRegex.hasMatch(email)) {
        _emailError = 'Please enter a valid email.';
      } else {
        _emailError = null;
      }

      _passwordError =
          _passwordController.text.isEmpty ? 'Please enter your password.' : null;
    });

    return _emailError == null && _passwordError == null;
  }

  Future<void> _handleLogin() async {
    if (_isLoading) return;
    FocusScope.of(context).unfocus();
    if (!_validateFields()) return;

    setState(() => _isLoading = true);

    try {
      final ok = await MockAuthService.login(
        email: _emailController.text,
        password: _passwordController.text,
      );
      if (!mounted) return;

      if (!ok) {
        setState(() => _authError = 'Invalid email or password.');
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Login successful')),
      );
      Navigator.of(context).pushAndRemoveUntil(
        fadeScaleRoute(const AccountSetupScreen()),
        (route) => false,
      );
    } catch (_) {
      if (!mounted) return;
      setState(() => _authError = 'Something went wrong. Please try again.');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _comingSoon() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Coming in a later build.')),
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('WELCOME,', style: AppTextStyles.heroHeading),
                const SizedBox(height: 4),
                const Text("we're here to help.",
                    style: AppTextStyles.heroSubtitle),
                const SizedBox(height: 40),

                AmumaTextField(
                  controller: _emailController,
                  hintText: 'Email Address',
                  keyboardType: TextInputType.emailAddress,
                  errorText: _emailError,
                  onChanged: (_) {
                    if (_emailError != null || _authError != null) {
                      setState(() {
                        _emailError = null;
                        _authError = null;
                      });
                    }
                  },
                ),
                const SizedBox(height: 18),

                AmumaTextField(
                  controller: _passwordController,
                  hintText: 'Password',
                  obscureText: _obscurePassword,
                  errorText: _passwordError,
                  onChanged: (_) {
                    if (_passwordError != null || _authError != null) {
                      setState(() {
                        _passwordError = null;
                        _authError = null;
                      });
                    }
                  },
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword ? Icons.visibility_off : Icons.visibility,
                      color: Colors.white70,
                    ),
                    onPressed: () =>
                        setState(() => _obscurePassword = !_obscurePassword),
                  ),
                ),

                if (_authError != null) ...[
                  const SizedBox(height: 12),
                  Text(
                    _authError!,
                    style: AppTextStyles.fieldError.copyWith(fontSize: 13),
                  ),
                ],

                const SizedBox(height: 10),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: _comingSoon,
                    child: const Text('Forgot Password?',
                        style: AppTextStyles.linkText),
                  ),
                ),

                const SizedBox(height: 8),
                AmumaPrimaryButton(
                  label: 'Login',
                  isLoading: _isLoading,
                  onPressed: _handleLogin,
                ),

                const SizedBox(height: 32),
                Row(
                  children: [
                    const Expanded(child: Divider(color: Colors.white54)),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      child: Text('Or Login with',
                          style: AppTextStyles.dividerText),
                    ),
                    const Expanded(child: Divider(color: Colors.white54)),
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
                Center(
                  child: Wrap(
                    alignment: WrapAlignment.center,
                    children: [
                      const Text("Don't have an account?  ",
                          style: AppTextStyles.footerText),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).pushReplacement(
                            fadeScaleRoute(const SignUpScreen()),
                          );
                        },
                        child: const Text('Sign Up Now',
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
