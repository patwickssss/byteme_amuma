/// Derives a friendly display name from an email since Sign Up has no
/// name field (e.g. "maria.santos@example.com" -> "Maria Santos").
class DisplayName {
  DisplayName._();

  static String fromEmail(String email) {
    final local = email.split('@').first;
    final parts = local
        .split(RegExp(r'[._\-+0-9]+'))
        .where((p) => p.isNotEmpty)
        .toList();
    if (parts.isEmpty) return email;
    return parts
        .map((p) => p[0].toUpperCase() + p.substring(1))
        .join(' ');
  }
}
