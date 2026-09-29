import 'package:flutter/material.dart';

import '../data/baby_guide_data.dart';
import '../services/nav_controller.dart';
import '../theme/app_colors.dart';
import 'guide_topic_screen.dart';

/// Baby Care Guide list (BABY_CARE_GUIDE_DEFAULT.png): search + age chips
/// + topic list. Content is local/static — no storage needed.
class BabyCareGuideScreen extends StatefulWidget {
  const BabyCareGuideScreen({super.key});

  @override
  State<BabyCareGuideScreen> createState() => _BabyCareGuideScreenState();
}

class _BabyCareGuideScreenState extends State<BabyCareGuideScreen> {
  AgeGroup _selectedAge = AgeGroup.m0to6;
  String _query = '';

  List<GuideTopic> get _filtered {
    final q = _query.trim().toLowerCase();
    return BabyGuideData.topics.where((t) {
      final matchesAge = t.ages.contains(_selectedAge);
      final matchesQuery = q.isEmpty ||
          t.title.toLowerCase().contains(q) ||
          t.blurb.toLowerCase().contains(q);
      return matchesAge && matchesQuery;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  GestureDetector(
                    onTap: () => NavController.instance.open('home'),
                    child: const Icon(Icons.chevron_left, size: 26),
                  ),
                  const SizedBox(width: 4),
                  const Text('Back', style: TextStyle(fontSize: 14)),
                  const Spacer(),
                  const Text(
                    'BABY CARE GUIDE',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      color: AppColors.maroon,
                    ),
                  ),
                  const Spacer(),
                  const SizedBox(width: 46), // balance the back button
                ],
              ),
              const SizedBox(height: 16),
              _searchField(),
              const SizedBox(height: 14),
              _ageChips(),
              const SizedBox(height: 16),
              const Text(
                'Topics',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColors.pink,
                ),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: _filtered.isEmpty
                    ? const Center(
                        child: Text(
                          'No topics match your search.',
                          style: TextStyle(color: Colors.black54),
                        ),
                      )
                    : ListView.separated(
                        padding: const EdgeInsets.only(bottom: 16),
                        itemCount: _filtered.length,
                        separatorBuilder: (_, __) =>
                            const SizedBox(height: 12),
                        itemBuilder: (context, i) =>
                            _topicTile(_filtered[i]),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _searchField() {
    return Container(
      height: 46,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.pink),
      ),
      child: TextField(
        onChanged: (v) => setState(() => _query = v),
        style: const TextStyle(fontSize: 14),
        decoration: const InputDecoration(
          hintText: 'Search topics (e.g breastfeeding....)',
          hintStyle: TextStyle(color: AppColors.pink, fontSize: 13),
          prefixIcon: Icon(Icons.search, color: AppColors.pink, size: 20),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 12),
        ),
      ),
    );
  }

  Widget _ageChips() {
    return SizedBox(
      height: 36,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: AgeGroup.values.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, i) {
          final age = AgeGroup.values[i];
          final active = age == _selectedAge;
          return GestureDetector(
            onTap: () => setState(() => _selectedAge = age),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: active ? AppColors.pink : Colors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: active ? AppColors.pink : const Color(0xFFE3B7C8),
                ),
              ),
              child: Text(
                age.chipLabel,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: active ? Colors.white : const Color(0xFFE3B7C8),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _topicTile(GuideTopic topic) {
    return Material(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: const BorderSide(color: Color(0xFFF0C4D4)),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) =>
                  GuideTopicScreen(topic: topic, age: _selectedAge),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0xFFF0C4D4)),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      topic.title,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF3A3A3A),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      topic.blurb,
                      style:
                          const TextStyle(fontSize: 12, color: Colors.black54),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: AppColors.pink),
            ],
          ),
        ),
      ),
    );
  }
}
