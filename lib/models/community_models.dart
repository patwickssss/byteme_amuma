/// Prototype data models for the Parent Community feed.
/// Stored locally (shared_preferences) as one shared feed; each post/comment
/// records who made it (by the logged-in mock user's email) so likes and
/// "delete own post" work per-user, per the spec.

class CommunityComment {
  final String id;
  final String authorEmail;
  final String authorDisplay;
  final String text;
  final DateTime date;

  const CommunityComment({
    required this.id,
    required this.authorEmail,
    required this.authorDisplay,
    required this.text,
    required this.date,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'authorEmail': authorEmail,
        'authorDisplay': authorDisplay,
        'text': text,
        'date': date.toIso8601String(),
      };

  factory CommunityComment.fromJson(Map<String, dynamic> json) =>
      CommunityComment(
        id: json['id'] as String,
        authorEmail: json['authorEmail'] as String,
        authorDisplay: json['authorDisplay'] as String,
        text: json['text'] as String,
        date: DateTime.parse(json['date'] as String),
      );
}

class CommunityPost {
  final String id;
  final String authorEmail;
  final String authorDisplay;
  final String category; // Pregnancy, Childcare, Family
  final String title;
  final String body;
  final DateTime date;
  final Set<String> likedBy; // emails
  final List<CommunityComment> comments;

  const CommunityPost({
    required this.id,
    required this.authorEmail,
    required this.authorDisplay,
    required this.category,
    required this.title,
    required this.body,
    required this.date,
    this.likedBy = const {},
    this.comments = const [],
  });

  bool likedByUser(String email) => likedBy.contains(email);

  CommunityPost copyWith({
    Set<String>? likedBy,
    List<CommunityComment>? comments,
  }) {
    return CommunityPost(
      id: id,
      authorEmail: authorEmail,
      authorDisplay: authorDisplay,
      category: category,
      title: title,
      body: body,
      date: date,
      likedBy: likedBy ?? this.likedBy,
      comments: comments ?? this.comments,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'authorEmail': authorEmail,
        'authorDisplay': authorDisplay,
        'category': category,
        'title': title,
        'body': body,
        'date': date.toIso8601String(),
        'likedBy': likedBy.toList(),
        'comments': comments.map((c) => c.toJson()).toList(),
      };

  factory CommunityPost.fromJson(Map<String, dynamic> json) => CommunityPost(
        id: json['id'] as String,
        authorEmail: json['authorEmail'] as String,
        authorDisplay: json['authorDisplay'] as String,
        category: json['category'] as String,
        title: json['title'] as String,
        body: json['body'] as String,
        date: DateTime.parse(json['date'] as String),
        likedBy: Set<String>.from(json['likedBy'] as List? ?? []),
        comments: (json['comments'] as List<dynamic>? ?? [])
            .map((e) =>
                CommunityComment.fromJson(Map<String, dynamic>.from(e as Map)))
            .toList(),
      );
}
