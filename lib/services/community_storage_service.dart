import 'dart:convert';
import 'dart:math';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/community_models.dart';

/// Local-only storage for the Community feed. One shared feed for the
/// prototype (all mock accounts on this device see the same posts);
/// each post/comment records its author's email so likes and
/// "delete own post" are per-user. No backend.
class CommunityStorageService {
  CommunityStorageService._();

  static const String _key = 'community_posts';
  static final _rand = Random();

  static String newId() =>
      '${DateTime.now().microsecondsSinceEpoch}_${_rand.nextInt(99999)}';

  static Future<List<CommunityPost>> loadPosts() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key);

    if (raw == null) {
      final seeded = _seedPosts();
      await _savePosts(seeded);
      return seeded;
    }

    try {
      final list = jsonDecode(raw) as List<dynamic>;
      final posts = list
          .map((e) => CommunityPost.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList();
      posts.sort((a, b) => b.date.compareTo(a.date));
      return posts;
    } catch (_) {
      final seeded = _seedPosts();
      await _savePosts(seeded);
      return seeded;
    }
  }

  static Future<void> _savePosts(List<CommunityPost> posts) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _key,
      jsonEncode(posts.map((p) => p.toJson()).toList()),
    );
  }

  static Future<void> addPost(CommunityPost post) async {
    final posts = await loadPosts();
    posts.insert(0, post);
    await _savePosts(posts);
  }

  static Future<void> deletePost(String postId, String requestingEmail) async {
    final posts = await loadPosts();
    posts.removeWhere(
      (p) => p.id == postId && p.authorEmail == requestingEmail,
    );
    await _savePosts(posts);
  }

  static Future<void> toggleLike(String postId, String email) async {
    final posts = await loadPosts();
    final index = posts.indexWhere((p) => p.id == postId);
    if (index == -1) return;
    final post = posts[index];
    final liked = Set<String>.from(post.likedBy);
    if (liked.contains(email)) {
      liked.remove(email);
    } else {
      liked.add(email);
    }
    posts[index] = post.copyWith(likedBy: liked);
    await _savePosts(posts);
  }

  static Future<void> addComment(String postId, CommunityComment comment) async {
    final posts = await loadPosts();
    final index = posts.indexWhere((p) => p.id == postId);
    if (index == -1) return;
    final post = posts[index];
    posts[index] =
        post.copyWith(comments: [...post.comments, comment]);
    await _savePosts(posts);
  }

  static List<CommunityPost> _seedPosts() {
    final now = DateTime.now();
    return [
      CommunityPost(
        id: newId(),
        authorEmail: 'seed_mommy_pinty@example.com',
        authorDisplay: 'Mommy Pinty',
        category: 'Childcare',
        title: 'Tips for breastfeeding?',
        body:
            "First-time mom here — my latch feels off and it's getting sore. Any tips that worked for you in the early weeks?",
        date: now.subtract(const Duration(hours: 3)),
        likedBy: {'seed_liker1@example.com', 'seed_liker2@example.com'},
        comments: [
          CommunityComment(
            id: newId(),
            authorEmail: 'seed_ana@example.com',
            authorDisplay: 'Ana R.',
            text:
                'A lactation consultant helped me so much with positioning — worth asking your clinic!',
            date: now.subtract(const Duration(hours: 2)),
          ),
        ],
      ),
      CommunityPost(
        id: newId(),
        authorEmail: 'seed_jen@example.com',
        authorDisplay: 'Jen Aguilar',
        category: 'Pregnancy',
        title: 'Second trimester energy dip?',
        body:
            "I thought energy was supposed to come back in the second trimester but I'm still exhausted by 3pm. Is that normal?",
        date: now.subtract(const Duration(hours: 8)),
        likedBy: {'seed_liker3@example.com'},
      ),
      CommunityPost(
        id: newId(),
        authorEmail: 'seed_carlo@example.com',
        authorDisplay: 'Carlo M.',
        category: 'Family',
        title: 'Budgeting for a new baby',
        body:
            'What actually made a dent in your budget once baby arrived — diapers, formula, or something you didn\'t expect?',
        date: now.subtract(const Duration(days: 1)),
      ),
    ];
  }
}
