import 'package:flutter/material.dart';
import '../services/nav_controller.dart';

/// The round "< Back" chip at the top-left of every screen in the designs.
/// Pops a pushed screen; on a main tab it goes back to Home.
class BackChip extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;

  const BackChip({super.key, this.label = 'Back', this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap ??
          () {
            final nav = Navigator.of(context);
            if (nav.canPop()) {
              nav.pop();
            } else {
              NavController.instance.open('home');
            }
          },
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Color(0x33000000),
                  blurRadius: 4,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: const Icon(Icons.chevron_left, size: 22, color: Colors.black),
          ),
          const SizedBox(width: 8),
          Text(label,
              style: const TextStyle(fontSize: 13, color: Colors.black87)),
        ],
      ),
    );
  }
}
