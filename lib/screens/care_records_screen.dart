import 'package:flutter/material.dart';

import '../models/care_models.dart';
import '../services/care_storage_service.dart';
import '../services/nav_controller.dart';
import '../theme/app_colors.dart';
import '../utils/age_utils.dart';
import 'add_profile_screen.dart';
import 'profile_detail_screen.dart';

/// Care Records & Reminders — profile picker
/// (Care_Records___Reminder_Select_Profile.png).
class CareRecordsScreen extends StatefulWidget {
  const CareRecordsScreen({super.key});

  @override
  State<CareRecordsScreen> createState() => _CareRecordsScreenState();
}

class _CareRecordsScreenState extends State<CareRecordsScreen> {
  List<CareProfile> _profiles = [];
  String _query = '';
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final profiles = await CareStorageService.loadProfiles();
    if (!mounted) return;
    setState(() {
      _profiles = profiles;
      _loading = false;
    });
  }

  List<CareProfile> get _filtered {
    final q = _query.trim().toLowerCase();
    if (q.isEmpty) return _profiles;
    return _profiles.where((p) => p.name.toLowerCase().contains(q)).toList();
  }

  Future<void> _goToAddProfile() async {
    final created = await Navigator.of(context).push<bool>(
      MaterialPageRoute(builder: (_) => const AddProfileScreen()),
    );
    if (created == true) _load();
  }

  void _openProfile(CareProfile profile) {
    Navigator.of(context)
        .push(
          MaterialPageRoute(
            builder: (_) => ProfileDetailScreen(profile: profile),
          ),
        )
        .then((_) => _load());
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
                ],
              ),
              const SizedBox(height: 10),
              const Text(
                'CARE RECORDS & REMINDER',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: AppColors.maroon,
                ),
              ),
              const SizedBox(height: 16),
              Container(
                height: 46,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.pink),
                ),
                child: TextField(
                  onChanged: (v) => setState(() => _query = v),
                  style: const TextStyle(fontSize: 14),
                  decoration: const InputDecoration(
                    hintText: 'Search Baby Profile',
                    hintStyle: TextStyle(color: AppColors.pink, fontSize: 13),
                    prefixIcon:
                        Icon(Icons.search, color: AppColors.pink, size: 20),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Profiles',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColors.pink,
                ),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: _loading
                    ? const Center(child: CircularProgressIndicator())
                    : ListView(
                        padding: const EdgeInsets.only(bottom: 16),
                        children: [
                          for (final p in _filtered) _profileTile(p),
                          _addProfileTile(),
                        ],
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _profileTile(CareProfile profile) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Material(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
          side: const BorderSide(color: Color(0xFFF0C4D4)),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: () => _openProfile(profile),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 24,
                  backgroundColor: Color(0xFFD9D9D9),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        profile.name,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: AppColors.pink,
                        ),
                      ),
                      Text(
                        AgeUtils.describe(profile.birthDate),
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.pink,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right, color: AppColors.pink),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _addProfileTile() {
    return Material(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: const BorderSide(color: Color(0xFFF0C4D4)),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: _goToAddProfile,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: const BoxDecoration(
                  color: AppColors.maroon,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.add, color: Colors.white),
              ),
              const SizedBox(width: 14),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Add Profile',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      color: AppColors.maroon,
                    ),
                  ),
                  Text(
                    'Register another child',
                    style: TextStyle(fontSize: 12, color: Colors.black54),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
