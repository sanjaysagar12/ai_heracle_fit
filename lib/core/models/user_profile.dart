class UserProfile {
  final String id;
  final String username;
  final String name;
  final String email;
  final String? avatarUrl;
  final String? bio;
  final String? role;

  const UserProfile({
    required this.id,
    required this.username,
    required this.name,
    required this.email,
    this.avatarUrl,
    this.bio,
    this.role,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) => UserProfile(
    id: json['id'] as String? ?? '',
    username: json['username'] as String? ?? '',
    name: json['name'] as String? ?? '',
    email: json['email'] as String? ?? '',
    avatarUrl: json['avatarUrl'] as String?,
    bio: json['bio'] as String?,
    role: json['role'] as String?,
  );

  /// Subtitle shown in the header, e.g. "Athlete • Pro Member"
  String get subtitle {
    final parts = [if (bio != null) bio!, if (role != null) role!];
    return parts.isEmpty ? '' : parts.join(' • ');
  }

  /// First word of name for a compact greeting.
  String get firstName => name.split(' ').first;
}
