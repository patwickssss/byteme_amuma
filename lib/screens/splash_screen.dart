import 'package:flutter/material.dart';
import '../theme/app_text_styles.dart';
import '../utils/app_routes.dart';
import '../widgets/gradient_background.dart';
import 'auth_choice_screen.dart';

/// Animated splash: mark fades/scales in, logotype follows with a soft
/// slide-up, short pause, then a fade/scale transition to the auth screen.
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _markFade;
  late final Animation<double> _markScale;
  late final Animation<double> _textFade;
  late final Animation<Offset> _textSlide;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _markFade = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
    );
    _markScale = Tween<double>(begin: 0.85, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.7, curve: Curves.fastOutSlowIn),
      ),
    );
    _textFade = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.45, 1.0, curve: Curves.easeOut),
    );
    _textSlide = Tween<Offset>(
      begin: const Offset(0, 0.4),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.45, 1.0, curve: Curves.easeOut),
      ),
    );

    _run();
  }

  Future<void> _run() async {
    await _controller.forward();
    await Future.delayed(const Duration(milliseconds: 600));
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      fadeScaleRoute(const AuthChoiceScreen()),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradientBackground(
        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                FadeTransition(
                  opacity: _markFade,
                  child: ScaleTransition(
                    scale: _markScale,
                    child: ColorFiltered(
                      colorFilter: const ColorFilter.mode(
                        Colors.black,
                        BlendMode.srcIn,
                      ),
                      child: Image.asset(
                        'assets/images/amuma_mark.png',
                        width: 140,
                        height: 140,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                FadeTransition(
                  opacity: _textFade,
                  child: SlideTransition(
                    position: _textSlide,
                    child: const Text(
                      'AMUMA',
                      style: AppTextStyles.splashLogotype,
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
}
