/// Prototype-only user record. Replace with a real model once a backend exists.
/// Fields match the Sign Up form in Figma (email + password) plus a
/// profile map filled in by the "Let's set up your account" screen.
class MockUser {
  final String email;
  final String password; // prototype only — NOT secure storage
  final Map<String, dynamic> profile;

  const MockUser({
    required this.email,
    required this.password,
    this.profile = const {},
  });

  MockUser copyWith({Map<String, dynamic>? profile}) {
    return MockUser(
      email: email,
      password: password,
      profile: profile ?? this.profile,
    );
  }

  Map<String, dynamic> toJson() => {
        'email': email,
        'password': password,
        'profile': profile,
      };

  factory MockUser.fromJson(Map<String, dynamic> json) {
    return MockUser(
      email: json['email'] as String,
      password: json['password'] as String,
      profile: Map<String, dynamic>.from(json['profile'] as Map? ?? {}),
    );
  }
}
