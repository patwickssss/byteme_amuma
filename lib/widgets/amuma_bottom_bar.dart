import 'package:flutter/material.dart';

import '../models/app_feature.dart';
import '../services/nav_controller.dart';
import '../theme/app_colors.dart';

/// Shared bottom bar. Use it in MainShell AND on pushed detail screens
/// so it is always the same 4 items. Tapping a tab pops back to the shell.
class AmumaBottomBar extends StatelessWidget {
  const AmumaBottomBar({super.key});

  static const Color _inactive = Color(0xFFF9B4CF);

  @override
  Widget build(BuildContext context) {
    final nav = NavController.instance;

    return ListenableBuilder(
      listenable: nav,
      builder: (context, _) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            border: Border(top: BorderSide(color: Color(0xFFE3E3E3))),
          ),
          child: SafeArea(
            top: false,
            child: SizedBox(
              height: 64,
              child: Row(
                children: [
                  for (final id in nav.order)
                    Expanded(
                      child: _BarItem(
                        feature: AppFeatures.byId(id),
                        active: id == nav.activeId,
                        onTap: () {
                          nav.open(id);
                          Navigator.of(context).popUntil((r) => r.isFirst);
                        },
                      ),
                    ),
                  Expanded(
                    child: _BarItem(
                      label: 'More',
                      iconData: Icons.menu_rounded,
                      active: false,
                      onTap: () => showMoreSheet(context),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _BarItem extends StatelessWidget {
  final AppFeature? feature;
  final String? label;
  final IconData? iconData;
  final bool active;
  final VoidCallback onTap;

  const _BarItem({
    this.feature,
    this.label,
    this.iconData,
    required this.active,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = active ? AppColors.maroon : AmumaBottomBar._inactive;
    final text = feature?.label ?? label ?? '';
    final semanticLabel = feature?.fullName ?? label ?? '';

    Widget icon;
    if (feature != null && feature!.useLogo) {
      icon = ColorFiltered(
        colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
        child: Image.asset('assets/images/amuma_mark.png',
            width: 22, height: 22, fit: BoxFit.contain),
      );
    } else {
      icon = Icon(feature?.icon ?? iconData, color: color, size: 22);
    }

    return Tooltip(
      message: semanticLabel,
      child: Semantics(
        button: true,
        selected: active,
        label: active ? '$semanticLabel, selected' : semanticLabel,
        child: InkWell(
          onTap: onTap,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 220),
                curve: Curves.easeOut,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
                decoration: BoxDecoration(
                  color: active
                      ? AppColors.maroon.withValues(alpha: 0.10)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: icon,
              ),
              const SizedBox(height: 3),
              Text(
                text,
                style: TextStyle(
                  fontSize: 12,
                  color: color,
                  fontWeight: active ? FontWeight.w700 : FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Bottom sheet listing the features that are not currently in the bar.
void showMoreSheet(BuildContext context) {
  final nav = NavController.instance;
  final remaining =
      AppFeatures.all.where((f) => !nav.order.contains(f.id)).toList();

  showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (sheetContext) {
      return SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE0E0E0),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'More',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: AppColors.maroon,
                  ),
                ),
                const SizedBox(height: 8),
                for (final f in remaining)
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        color: AppColors.pink.withValues(alpha: 0.12),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(f.icon, color: AppColors.maroon, size: 20),
                    ),
                    title: Row(
                      children: [
                        Flexible(
                          child: Text(
                            f.fullName,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              color: AppColors.maroon,
                            ),
                          ),
                        ),
                        if (!f.built) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF4E3C1),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Text(
                              'Coming soon',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF8A6418),
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    subtitle: Text(
                      f.description,
                      style: const TextStyle(fontSize: 12, color: Colors.black54),
                    ),
                    trailing: const Icon(Icons.chevron_right, color: AppColors.pink),
                    onTap: () {
                      Navigator.of(sheetContext).pop();
                      nav.open(f.id);
                      Navigator.of(context).popUntil((r) => r.isFirst);
                    },
                  ),
              ],
            ),
          ),
        ),
      );
    },
  );
}
