import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';
import '../back_chip.dart';
import '../pressable_scale.dart';

/// Shared building blocks for every Family & Budget Planning screen,
/// so each screen stays short and they all look the same.

class PlanColors {
  PlanColors._();
  static const Color text = Color(0xFF3A3A3A);
  static const Color muted = Color(0xFF6B6B6B);
  static const Color border = Color(0xFFF0C4D4);
  static const Color blush = Color(0xFFFCE4EC);
  static const Color eyebrow = Color(0xFFC4457F); // readable pink for labels
  static const Color overText = Color(0xFF9E2F24);
  static const Color overBg = Color(0xFFFFEFEA);
}

/// White page with Back chip + centered title.
class PlanScaffold extends StatelessWidget {
  final String title;
  final Widget child;
  final Widget? floatingActionButton;

  const PlanScaffold({
    super.key,
    required this.title,
    required this.child,
    this.floatingActionButton,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButton: floatingActionButton,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const BackChip(),
              const SizedBox(height: 10),
              Center(
                child: Text(
                  title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: AppColors.maroon,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Expanded(child: child),
            ],
          ),
        ),
      ),
    );
  }
}

/// Labeled text box with the app's pink outline and an optional error.
class PlanField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final String hint;
  final String? error;
  final TextInputType keyboardType;
  final String? prefixText;
  final ValueChanged<String>? onChanged;
  final int maxLines;

  const PlanField({
    super.key,
    required this.label,
    required this.controller,
    required this.hint,
    this.error,
    this.keyboardType = TextInputType.text,
    this.prefixText,
    this.onChanged,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: PlanColors.eyebrow,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: error != null ? AppColors.errorFieldBorder : AppColors.pink,
            ),
          ),
          child: TextField(
            controller: controller,
            keyboardType: keyboardType,
            maxLines: maxLines,
            onChanged: onChanged,
            style: const TextStyle(fontSize: 15),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: const TextStyle(color: AppColors.pink, fontSize: 14),
              prefixText: prefixText,
              prefixStyle: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: AppColors.maroon,
              ),
              border: InputBorder.none,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            ),
          ),
        ),
        if (error != null)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(error!,
                style:
                    const TextStyle(fontSize: 12, color: AppColors.errorRed)),
          ),
      ],
    );
  }
}

/// Pick-one chips (wraps to new lines instead of overflowing).
class PlanChoice extends StatelessWidget {
  final List<String> options;
  final int selected;
  final ValueChanged<int> onSelected;

  const PlanChoice({
    super.key,
    required this.options,
    required this.selected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        for (var i = 0; i < options.length; i++)
          Semantics(
            button: true,
            selected: i == selected,
            label: options[i],
            child: GestureDetector(
              onTap: () => onSelected(i),
              child: Container(
                constraints: const BoxConstraints(minHeight: 40),
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: i == selected ? AppColors.maroon : Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: i == selected ? AppColors.maroon : AppColors.pink,
                  ),
                ),
                child: Text(
                  options[i],
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: i == selected ? Colors.white : PlanColors.eyebrow,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class PlanCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets padding;
  final Color color;

  const PlanCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.color = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: padding,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: PlanColors.border),
      ),
      child: child,
    );
  }
}

class PlanPrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool loading;
  final IconData? icon;

  const PlanPrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.loading = false,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return PressableScale(
      enabled: onPressed != null && !loading,
      child: SizedBox(
        width: double.infinity,
        height: 52,
        child: FilledButton(
          onPressed: loading ? null : onPressed,
          style: FilledButton.styleFrom(
            backgroundColor: AppColors.maroon,
            foregroundColor: Colors.white,
            disabledBackgroundColor: AppColors.maroon.withValues(alpha: 0.6),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
          child: loading
              ? const SizedBox(
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(
                      strokeWidth: 2.4, color: Colors.white),
                )
              : Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (icon != null) ...[
                      Icon(icon, size: 20),
                      const SizedBox(width: 8),
                    ],
                    Text(label,
                        style: const TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w700)),
                  ],
                ),
        ),
      ),
    );
  }
}

class PlanOutlineButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;

  const PlanOutlineButton(
      {super.key, required this.label, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return PressableScale(
      child: SizedBox(
        width: double.infinity,
        height: 52,
        child: OutlinedButton(
          onPressed: onPressed,
          style: OutlinedButton.styleFrom(
            side: const BorderSide(color: AppColors.maroon),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: AppColors.maroon,
            ),
          ),
        ),
      ),
    );
  }
}

class PlanProgressBar extends StatelessWidget {
  final double value; // 0..1
  final Color color;

  const PlanProgressBar(
      {super.key, required this.value, this.color = AppColors.maroon});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(6),
      child: LinearProgressIndicator(
        value: value.clamp(0.0, 1.0).toDouble(),
        minHeight: 10,
        color: color,
        backgroundColor: PlanColors.blush,
      ),
    );
  }
}

class PlanEmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String message;
  final String? actionLabel;
  final VoidCallback? onAction;

  const PlanEmptyState({
    super.key,
    required this.icon,
    required this.title,
    required this.message,
    this.actionLabel,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 48, color: AppColors.pink),
            const SizedBox(height: 12),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppColors.maroon,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  fontSize: 13, height: 1.4, color: PlanColors.muted),
            ),
            if (actionLabel != null && onAction != null) ...[
              const SizedBox(height: 16),
              SizedBox(
                width: 240,
                child: PlanPrimaryButton(
                    label: actionLabel!, onPressed: onAction),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class PlanNote extends StatelessWidget {
  final String text;
  const PlanNote(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(top: 1),
          child: Icon(Icons.info_outline_rounded,
              size: 16, color: PlanColors.muted),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
                fontSize: 12, height: 1.4, color: PlanColors.muted),
          ),
        ),
      ],
    );
  }
}

/// Standard "Delete? This cannot be undone." dialog. Returns true if confirmed.
Future<bool> confirmDelete(BuildContext context, String title) async {
  final result = await showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text(title),
      content: const Text('This cannot be undone.'),
      actions: [
        TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel')),
        TextButton(
          onPressed: () => Navigator.pop(ctx, true),
          child: const Text('Delete',
              style: TextStyle(color: AppColors.errorRed)),
        ),
      ],
    ),
  );
  return result == true;
}
