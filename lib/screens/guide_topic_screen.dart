import 'package:flutter/material.dart';

import '../data/baby_guide_data.dart';
import '../theme/app_colors.dart';
import '../widgets/blank_image_box.dart';

/// Topic detail (BABY_CARE_GUIDE_DEFAULT — Sleep layout), reused for every
/// topic. The hamburger icon opens the "Quick Access" section drawer.
class GuideTopicScreen extends StatelessWidget {
  final GuideTopic topic;
  final AgeGroup age;

  const GuideTopicScreen({super.key, required this.topic, required this.age});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: ValueKey(topic.id),
      backgroundColor: Colors.white,
      endDrawer: _QuickAccessDrawer(topic: topic),
      body: Builder(
        builder: (context) => SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: const Icon(Icons.chevron_left, size: 26),
                    ),
                    const SizedBox(width: 4),
                    const Text('Back', style: TextStyle(fontSize: 14)),
                    const Spacer(),
                    GestureDetector(
                      onTap: () => Scaffold.of(context).openEndDrawer(),
                      child: Container(
                        width: 34,
                        height: 34,
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
                        child: const Icon(Icons.menu, size: 18),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        topic.title,
                        style: const TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.w800,
                          color: AppColors.pink,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        age.subtitle,
                        style: const TextStyle(
                          fontSize: 13,
                          color: Colors.black54,
                        ),
                      ),
                      const SizedBox(height: 16),
                      const BlankImageBox(width: double.infinity, height: 190),
                      const SizedBox(height: 14),
                      Text(
                        topic.introFor(age),
                        style: const TextStyle(
                          fontSize: 13,
                          height: 1.4,
                          color: Color(0xFFE49BB4),
                        ),
                      ),
                      for (final section in topic.sections)
                        _sectionBlock(section),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _sectionBlock(GuideSection section) {
    return Padding(
      padding: const EdgeInsets.only(top: 26),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            section.title.toUpperCase(),
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: AppColors.pink,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            section.body,
            style: const TextStyle(
              fontSize: 13,
              height: 1.4,
              color: Color(0xFFE49BB4),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const BlankImageBox(width: 96, height: 96, radius: 12),
              const SizedBox(width: 10),
              const BlankImageBox(width: 96, height: 96, radius: 12),
              const SizedBox(width: 10),
              const BlankImageBox(width: 96, height: 96, radius: 12),
            ],
          ),
        ],
      ),
    );
  }
}

class _QuickAccessDrawer extends StatelessWidget {
  final GuideTopic topic;

  const _QuickAccessDrawer({required this.topic});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Quick Access',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppColors.pink,
                ),
              ),
              const SizedBox(height: 20),
              for (final section in topic.sections) ...[
                Text(
                  section.title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF3A3A3A),
                  ),
                ),
                const SizedBox(height: 6),
                for (final point in section.points)
                  Padding(
                    padding: const EdgeInsets.only(left: 8, bottom: 4),
                    child: Text('•  $point',
                        style: const TextStyle(fontSize: 12.5)),
                  ),
                const SizedBox(height: 14),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
