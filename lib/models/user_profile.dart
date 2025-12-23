/// User Profile model representing a tennis player's profile
/// Maps to the profiles table in Supabase
class UserProfile {
  final String id;
  final String username;
  final String fullName;
  final String email;
  final String? phone;
  final String? avatarUrl;
  final String? bio;
  final String? skillLevel;
  final String availabilityStatus;
  final DateTime createdAt;
  final DateTime updatedAt;

  UserProfile({
    required this.id,
    required this.username,
    required this.fullName,
    required this.email,
    this.phone,
    this.avatarUrl,
    this.bio,
    this.skillLevel,
    this.availabilityStatus = 'active',
    required this.createdAt,
    required this.updatedAt,
  });

  /// Create UserProfile from Supabase JSON response
  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'] as String,
      username: json['username'] as String,
      fullName: json['full_name'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String?,
      avatarUrl: json['avatar_url'] as String?,
      bio: json['bio'] as String?,
      skillLevel: json['skill_level'] as String?,
      availabilityStatus: json['availability_status'] as String? ?? 'active',
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  /// Convert UserProfile to JSON for Supabase
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'full_name': fullName,
      'email': email,
      'phone': phone,
      'avatar_url': avatarUrl,
      'bio': bio,
      'skill_level': skillLevel,
      'availability_status': availabilityStatus,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  /// Create a copy of the profile with updated fields
  UserProfile copyWith({
    String? id,
    String? username,
    String? fullName,
    String? email,
    String? phone,
    String? avatarUrl,
    String? bio,
    String? skillLevel,
    String? availabilityStatus,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserProfile(
      id: id ?? this.id,
      username: username ?? this.username,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      bio: bio ?? this.bio,
      skillLevel: skillLevel ?? this.skillLevel,
      availabilityStatus: availabilityStatus ?? this.availabilityStatus,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
