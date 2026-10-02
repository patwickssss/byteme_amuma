import 'package:flutter/material.dart';

import '../data/bodywise_data.dart';
import '../services/nav_controller.dart';
import '../theme/app_colors.dart';
import '../widgets/back_chip.dart';
import '../widgets/pressable_scale.dart';
import 'bodywise_module_screen.dart';

/// BodyWise module list (BodyWise.png): search + topic chips + module cards.
/// Content is local/mock (lib/data/bodywise_data.dart). No storage needed.
class BodyWiseScreen extends StatefulWidget {
  const BodyWiseScreen({super.key});

  @override
  State<BodyWiseScreen> createState() => _BodyWiseScreenState();
}

class _BodyWiseScreenState extends State<BodyWiseScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _query = '';
  String _category = 'All';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<BodyWiseModule> get _filtered {
    final q = _query.trim().toLowerCase();
    return BodyWiseData.modules.where((m) {
      final matchesCategory = _category == 'All' || m.category == _category;
      final matchesQuery = q.isEmpty || m.searchText.contains(q);
      return matchesCategory && matchesQuery;
    }).toList();
  }

  void _clearSearch() {
    _searchController.clear();
    setState(() => _query = '');
  }

  void _resetFilters() {
    _searchController.clear();
    setState(() {
      _query = '';
      _category = 'All';
    });
  }

  void _openModule(BodyWiseModule module) {
    FocusScope.of(context).unfocus();
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => BodyWiseModuleScreen(module: module)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final results = _filtered;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const BackChip(),
              const SizedBox(height: 10),
              const Center(
                child: Text(
                  'BODYWISE',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: AppColors.maroon,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              _searchField(),
              const SizedBox(height: 12),
              _categoryChips(),
              const SizedBox(height: 16),
              Row(
                children: [
                  const Text(
                    'Modules',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: AppColors.pink,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    '${results.length} ${results.length == 1 ? 'module' : 'modules'}',
                    style:
                        const TextStyle(fontSize: 12, color: Colors.black54),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Expanded(
                child: results.isEmpty
                    ? _emptyState()
                    : ListView(
                        keyboardDismissBehavior:
                            ScrollViewKeyboardDismissBehavior.onDrag,
                        padding: const EdgeInsets.only(bottom: 24),
                        children: [
                          for (final m in results) _moduleCard(m),
                          const SizedBox(height: 4),
                          _askAmumaCard(),
                          const SizedBox(height: 14),
                          _disclaimer(),
                        ],
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
      height: 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.pink),
      ),
      child: TextField(
        controller: _searchController,
        onChanged: (v) => setState(() => _query = v),
        textInputAction: TextInputAction.search,
        style: const TextStyle(fontSize: 14),
        decoration: InputDecoration(
          hintText: 'Search module',
          hintStyle: const TextStyle(color: AppColors.pink, fontSize: 14),
          prefixIcon:
              const Icon(Icons.search, color: AppColors.pink, size: 22),
          suffixIcon: _query.isEmpty
              ? null
              : IconButton(
                  tooltip: 'Clear search',
                  icon: const Icon(Icons.close, color: AppColors.pink),
                  onPressed: _clearSearch,
                ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 13),
        ),
      ),
    );
  }

  Widget _categoryChips() {
    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: BodyWiseData.categories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, i) {
          final c = BodyWiseData.categories[i];
          final active = c == _category;
          return GestureDetector(
            onTap: () => setState(() => _category = c),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: active ? AppColors.pink : Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: active ? AppColors.pink : const Color(0xFFE3B7C8),
                ),
              ),
              child: Text(
                c,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: active ? Colors.white : const Color(0xFFC4849C),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _moduleCard(BodyWiseModule m) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: PressableScale(
        child: Material(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: const BorderSide(color: Color(0xFFF0C4D4)),
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: () => _openModule(m),
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: m.tint,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Icon(m.icon, color: AppColors.maroon, size: 26),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          m.title,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                            color: AppColors.maroon,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          m.summary,
                          style: const TextStyle(
                            fontSize: 13,
                            height: 1.4,
                            color: Color(0xFF4A4A4A),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Wrap(
                          spacing: 10,
                          runSpacing: 6,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 3),
                              decoration: BoxDecoration(
                                color: m.tint,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                m.category,
                                style: const TextStyle(
                                  fontSize: 11.5,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.maroon,
                                ),
                              ),
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.schedule_rounded,
                                    size: 14, color: Colors.black54),
                                const SizedBox(width: 4),
                                Text(
                                  '${m.readMinutes} min read',
                                  style: const TextStyle(
                                      fontSize: 12, color: Colors.black54),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 12),
                    child: Icon(Icons.chevron_right, color: AppColors.pink),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _askAmumaCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFCE4EC),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          const Icon(Icons.chat_bubble_outline_rounded,
              color: AppColors.maroon, size: 26),
          const SizedBox(width: 12),
          const Expanded(
            child: Text(
              'Still have a question? Chat with Amuma.',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: AppColors.maroon,
              ),
            ),
          ),
          const SizedBox(width: 8),
          SizedBox(
            height: 40,
            child: FilledButton(
              onPressed: () => NavController.instance.open('amuma'),
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.maroon,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('Ask',
                  style: TextStyle(fontWeight: FontWeight.w700)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _disclaimer() {
    return const Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(Icons.info_outline_rounded, size: 16, color: Colors.black54),
        SizedBox(width: 8),
        Expanded(
          child: Text(
            'For education only. This does not replace advice from a doctor, '
            'midwife, or health worker. For personal care, visit your '
            'Barangay Health Station, Rural Health Unit, or hospital.',
            style: TextStyle(fontSize: 12, height: 1.4, color: Colors.black54),
          ),
        ),
      ],
    );
  }

  Widget _emptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.search_off_rounded,
                size: 48, color: AppColors.pink),
            const SizedBox(height: 12),
            const Text(
              'No modules found',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppColors.maroon,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Try a different word, or choose another topic.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13, color: Colors.black54),
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: _resetFilters,
              child: const Text('Clear search and filters'),
            ),
          ],
        ),
      ),
    );
  }
}
