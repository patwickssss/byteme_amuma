import 'package:flutter/material.dart';

import '../models/community_models.dart';
import '../services/community_storage_service.dart';
import '../services/mock_auth_service.dart';
import '../services/nav_controller.dart';
import '../theme/app_colors.dart';
import '../utils/display_name.dart';
import '../widgets/pressable_scale.dart';
import 'create_post_screen.dart';

/// Parent Community feed (Parent_Community.png): search/filter, post cards
/// with like + comment, create post, delete own post. Seeded with a few
/// made-up posts. Everything persists via shared_preferences.
class CommunityScreen extends StatefulWidget {
  const CommunityScreen({super.key});

  @override
  State<CommunityScreen> createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen> {
  static const _filters = ['For you', 'Pregnancy', 'Childcare', 'Family'];

  List<CommunityPost> _posts = [];
  String _filter = 'For you';
  String _query = '';
  String? _myEmail;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final user = await MockAuthService.getStoredAccount();
    final posts = await CommunityStorageService.loadPosts();
    if (!mounted) return;
    setState(() {
      _myEmail = user?.email;
      _posts = posts;
      _loading = false;
    });
  }

  List<CommunityPost> get _filtered {
    final q = _query.trim().toLowerCase();
    return _posts.where((p) {
      final matchesCategory = _filter == 'For you' || p.category == _filter;
      final matchesQuery = q.isEmpty ||
          p.title.toLowerCase().contains(q) ||
          p.body.toLowerCase().contains(q);
      return matchesCategory && matchesQuery;
    }).toList();
  }

  Future<void> _toggleLike(CommunityPost post) async {
    final email = _myEmail;
    if (email == null) return;
    await CommunityStorageService.toggleLike(post.id, email);
    _load();
  }

  Future<void> _openCreatePost() async {
    final created = await Navigator.of(context).push<bool>(
      MaterialPageRoute(builder: (_) => const CreatePostScreen()),
    );
    if (created == true) _load();
  }

  Future<void> _confirmDelete(CommunityPost post) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete post?'),
        content: const Text('This cannot be undone.'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Cancel')),
          TextButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text('Delete',
                  style: TextStyle(color: AppColors.errorRed))),
        ],
      ),
    );
    if (confirmed == true && _myEmail != null) {
      await CommunityStorageService.deletePost(post.id, _myEmail!);
      _load();
    }
  }

  Future<void> _openComments(CommunityPost post) async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => _CommentsSheet(
        post: post,
        myEmail: _myEmail ?? 'guest@example.com',
        onCommentAdded: _load,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButton: PressableScale(
        child: FloatingActionButton(
          backgroundColor: AppColors.maroon,
          onPressed: _openCreatePost,
          child: const Icon(Icons.add, color: Colors.white),
        ),
      ),
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
                  const Text('Community', style: TextStyle(fontSize: 16)),
                ],
              ),
              const SizedBox(height: 14),
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
                    hintText: 'Search topics or questions',
                    hintStyle: TextStyle(color: AppColors.pink, fontSize: 13),
                    prefixIcon:
                        Icon(Icons.search, color: AppColors.pink, size: 20),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 36,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: _filters.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 8),
                  itemBuilder: (context, i) {
                    final f = _filters[i];
                    final active = f == _filter;
                    return GestureDetector(
                      onTap: () => setState(() => _filter = f),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: active ? AppColors.pink : Colors.white,
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(
                            color:
                                active ? AppColors.pink : const Color(0xFFE3B7C8),
                          ),
                        ),
                        child: Text(
                          f,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: active
                                ? Colors.white
                                : const Color(0xFFE3B7C8),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 14),
              Expanded(
                child: _loading
                    ? const Center(child: CircularProgressIndicator())
                    : _filtered.isEmpty
                        ? const Center(
                            child: Text('No posts yet.',
                                style: TextStyle(color: Colors.black54)),
                          )
                        : ListView.separated(
                            padding: const EdgeInsets.only(bottom: 90),
                            itemCount: _filtered.length,
                            separatorBuilder: (_, __) =>
                                const SizedBox(height: 12),
                            itemBuilder: (context, i) =>
                                _postCard(_filtered[i]),
                          ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _postCard(CommunityPost post) {
    final liked = _myEmail != null && post.likedByUser(_myEmail!);
    final isMine = _myEmail != null && post.authorEmail == _myEmail;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF0C4D4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CircleAvatar(radius: 18, backgroundColor: Color(0xFFF2E2D0)),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      post.authorDisplay,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFFE1904A),
                      ),
                    ),
                    Text(
                      post.title,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF3A3A3A),
                      ),
                    ),
                  ],
                ),
              ),
              if (isMine)
                GestureDetector(
                  onTap: () => _confirmDelete(post),
                  child: const Icon(Icons.delete_outline,
                      size: 20, color: AppColors.errorRed),
                )
              else
                const Icon(Icons.chevron_right, color: AppColors.pink),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            post.body,
            style: const TextStyle(fontSize: 13, color: Colors.black87, height: 1.3),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              GestureDetector(
                onTap: () => _toggleLike(post),
                child: Row(
                  children: [
                    Icon(
                      liked ? Icons.favorite : Icons.favorite_border,
                      size: 20,
                      color: liked ? AppColors.pink : Colors.black54,
                    ),
                    if (post.likedBy.isNotEmpty) ...[
                      const SizedBox(width: 4),
                      Text('${post.likedBy.length}',
                          style: const TextStyle(fontSize: 12)),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: 20),
              GestureDetector(
                onTap: () => _openComments(post),
                child: Row(
                  children: [
                    const Icon(Icons.mode_comment_outlined,
                        size: 19, color: Colors.black54),
                    if (post.comments.isNotEmpty) ...[
                      const SizedBox(width: 4),
                      Text('${post.comments.length}',
                          style: const TextStyle(fontSize: 12)),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CommentsSheet extends StatefulWidget {
  final CommunityPost post;
  final String myEmail;
  final VoidCallback onCommentAdded;

  const _CommentsSheet({
    required this.post,
    required this.myEmail,
    required this.onCommentAdded,
  });

  @override
  State<_CommentsSheet> createState() => _CommentsSheetState();
}

class _CommentsSheetState extends State<_CommentsSheet> {
  final _controller = TextEditingController();
  late List<CommunityComment> _comments;
  bool _sending = false;

  @override
  void initState() {
    super.initState();
    _comments = List.of(widget.post.comments);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _send() async {
    final text = _controller.text.trim();
    if (text.isEmpty || _sending) return;
    setState(() => _sending = true);

    final comment = CommunityComment(
      id: CommunityStorageService.newId(),
      authorEmail: widget.myEmail,
      authorDisplay: DisplayName.fromEmail(widget.myEmail),
      text: text,
      date: DateTime.now(),
    );
    await CommunityStorageService.addComment(widget.post.id, comment);
    widget.onCommentAdded();

    if (!mounted) return;
    setState(() {
      _comments = [..._comments, comment];
      _controller.clear();
      _sending = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 16,
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Comments',
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: AppColors.maroon,
              ),
            ),
            const SizedBox(height: 12),
            ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.4,
              ),
              child: _comments.isEmpty
                  ? const Padding(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: Text('No comments yet. Be the first to reply.',
                          style: TextStyle(color: Colors.black54)),
                    )
                  : ListView.separated(
                      shrinkWrap: true,
                      itemCount: _comments.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (context, i) {
                        final c = _comments[i];
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              c.authorDisplay,
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFFE1904A),
                              ),
                            ),
                            Text(c.text, style: const TextStyle(fontSize: 13)),
                          ],
                        );
                      },
                    ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 44,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.pink),
                    ),
                    child: TextField(
                      controller: _controller,
                      decoration: const InputDecoration(
                        hintText: 'Write a comment...',
                        hintStyle: TextStyle(color: AppColors.pink, fontSize: 13),
                        border: InputBorder.none,
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  onPressed: _sending ? null : _send,
                  icon: const Icon(Icons.send, color: AppColors.maroon),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
