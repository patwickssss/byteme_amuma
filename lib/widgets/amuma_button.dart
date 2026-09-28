import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import 'pressable_scale.dart';

/// The light-gray filled button used for "Login" / "Sign Up" in Figma.
class AmumaPrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;

  const AmumaPrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final disabled = onPressed == null || isLoading;

    return PressableScale(
      enabled: !disabled,
      child: SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: disabled ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.buttonFill,
          disabledBackgroundColor: AppColors.buttonFill.withValues(alpha: 0.7),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          elevation: 2,
        ),
        child: isLoading
            ? const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2.4,
                  color: AppColors.buttonText,
                ),
              )
            : Text(label, style: AppTextStyles.buttonText),
      ),
      ),
    );
  }
}

/// The white-outline button used for "Sign up" on the Auth Choice screen.
class AmumaOutlineButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;

  const AmumaOutlineButton({
    super.key,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return PressableScale(
      child: SizedBox(
      width: double.infinity,
      height: 56,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: Colors.white, width: 1.4),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        child: Text(
          label,
          style: AppTextStyles.buttonText.copyWith(color: Colors.white),
        ),
      ),
      ),
    );
  }
}

/// Plain gray placeholder box used for the two unlabeled "Or Login with"
/// social buttons in Figma. No icons were identifiable in the export,
/// so this stays a neutral placeholder rather than guessing a provider.
class AmumaSocialPlaceholderButton extends StatelessWidget {
  final VoidCallback? onPressed;

  const AmumaSocialPlaceholderButton({super.key, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return PressableScale(
      child: SizedBox(
      height: 52,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.buttonFill,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 1,
        ),
        child: const SizedBox.shrink(),
      ),
      ),
    );
  }
}
