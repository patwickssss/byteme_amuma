import 'package:flutter/material.dart';

/// Subtle press (and hover, on web/desktop) feedback for buttons.
/// Uses a Listener so it doesn't interfere with the button's own ripple.
class PressableScale extends StatefulWidget {
  final Widget child;
  final bool enabled;

  const PressableScale({super.key, required this.child, this.enabled = true});

  @override
  State<PressableScale> createState() => _PressableScaleState();
}

class _PressableScaleState extends State<PressableScale> {
  bool _pressed = false;
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    double scale = 1.0;
    if (widget.enabled) {
      if (_pressed) {
        scale = 0.97;
      } else if (_hovered) {
        scale = 1.015;
      }
    }

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: Listener(
        onPointerDown: (_) => setState(() => _pressed = true),
        onPointerUp: (_) => setState(() => _pressed = false),
        onPointerCancel: (_) => setState(() => _pressed = false),
        child: AnimatedScale(
          scale: scale,
          duration: const Duration(milliseconds: 100),
          curve: Curves.easeOut,
          child: widget.child,
        ),
      ),
    );
  }
}
