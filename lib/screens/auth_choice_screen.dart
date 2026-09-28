import 'package:flutter/material.dart';
import '../theme/app_text_styles.dart';
import '../widgets/amuma_button.dart';
import '../widgets/gradient_background.dart';
import '../utils/app_routes.dart';
import 'login_screen.dart';
import 'sign_up_screen.dart';

/// The intermediate screen between Splash and the Login form:
/// AMUMA mark + logotype, with "Login" and "Sign up" entry points.
class AuthChoiceScreen extends StatelessWidget {
  const AuthChoiceScreen({super.key});

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
                ColorFiltered(
                  colorFilter: const ColorFilter.mode(
                    Colors.black,
                    BlendMode.srcIn,
                  ),
                  child: Image.asset(
                    'assets/images/amuma_mark.png',
                    width: 110,
                    height: 110,
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(height: 14),
                Text('AMUMA', style: AppTextStyles.choiceLogotype),
                const Spacer(flex: 3),
                AmumaPrimaryButton(
                  label: 'Login',
                  onPressed: () {
                    Navigator.of(context).push(
                      fadeScaleRoute(const LoginScreen()),
                    );
                  },
                ),
                const SizedBox(height: 14),
                AmumaOutlineButton(
                  label: 'Sign up',
                  onPressed: () {
                    Navigator.of(context).push(
                      fadeScaleRoute(const SignUpScreen()),
                    );
                  },
                ),
                const Spacer(flex: 6),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
