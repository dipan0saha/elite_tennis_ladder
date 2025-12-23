import 'package:flutter_test/flutter_test.dart';
import 'package:elite_tennis_ladder/models/user_profile.dart';

void main() {
  group('UserProfile', () {
    test('should create UserProfile from JSON', () {
      final json = {
        'id': '123e4567-e89b-12d3-a456-426614174000',
        'username': 'johndoe',
        'full_name': 'John Doe',
        'email': 'john@example.com',
        'phone': '+1234567890',
        'avatar_url': 'https://example.com/avatar.jpg',
        'bio': 'Tennis enthusiast',
        'skill_level': 'intermediate',
        'availability_status': 'active',
        'created_at': '2025-01-01T00:00:00.000Z',
        'updated_at': '2025-01-01T00:00:00.000Z',
      };

      final profile = UserProfile.fromJson(json);

      expect(profile.id, '123e4567-e89b-12d3-a456-426614174000');
      expect(profile.username, 'johndoe');
      expect(profile.fullName, 'John Doe');
      expect(profile.email, 'john@example.com');
      expect(profile.phone, '+1234567890');
      expect(profile.avatarUrl, 'https://example.com/avatar.jpg');
      expect(profile.bio, 'Tennis enthusiast');
      expect(profile.skillLevel, 'intermediate');
      expect(profile.availabilityStatus, 'active');
    });

    test('should handle null optional fields in JSON', () {
      final json = {
        'id': '123e4567-e89b-12d3-a456-426614174000',
        'username': 'johndoe',
        'full_name': 'John Doe',
        'email': 'john@example.com',
        'phone': null,
        'avatar_url': null,
        'bio': null,
        'skill_level': null,
        'availability_status': 'active',
        'created_at': '2025-01-01T00:00:00.000Z',
        'updated_at': '2025-01-01T00:00:00.000Z',
      };

      final profile = UserProfile.fromJson(json);

      expect(profile.phone, isNull);
      expect(profile.avatarUrl, isNull);
      expect(profile.bio, isNull);
      expect(profile.skillLevel, isNull);
    });

    test('should convert UserProfile to JSON', () {
      final profile = UserProfile(
        id: '123e4567-e89b-12d3-a456-426614174000',
        username: 'johndoe',
        fullName: 'John Doe',
        email: 'john@example.com',
        phone: '+1234567890',
        avatarUrl: 'https://example.com/avatar.jpg',
        bio: 'Tennis enthusiast',
        skillLevel: 'intermediate',
        availabilityStatus: 'active',
        createdAt: DateTime.parse('2025-01-01T00:00:00.000Z'),
        updatedAt: DateTime.parse('2025-01-01T00:00:00.000Z'),
      );

      final json = profile.toJson();

      expect(json['id'], '123e4567-e89b-12d3-a456-426614174000');
      expect(json['username'], 'johndoe');
      expect(json['full_name'], 'John Doe');
      expect(json['email'], 'john@example.com');
      expect(json['phone'], '+1234567890');
      expect(json['avatar_url'], 'https://example.com/avatar.jpg');
      expect(json['bio'], 'Tennis enthusiast');
      expect(json['skill_level'], 'intermediate');
      expect(json['availability_status'], 'active');
    });

    test('should create copy with updated fields', () {
      final profile = UserProfile(
        id: '123e4567-e89b-12d3-a456-426614174000',
        username: 'johndoe',
        fullName: 'John Doe',
        email: 'john@example.com',
        availabilityStatus: 'active',
        createdAt: DateTime.parse('2025-01-01T00:00:00.000Z'),
        updatedAt: DateTime.parse('2025-01-01T00:00:00.000Z'),
      );

      final updatedProfile = profile.copyWith(
        bio: 'Updated bio',
        skillLevel: 'advanced',
      );

      expect(updatedProfile.id, profile.id);
      expect(updatedProfile.username, profile.username);
      expect(updatedProfile.bio, 'Updated bio');
      expect(updatedProfile.skillLevel, 'advanced');
    });

    test('should default availabilityStatus to active', () {
      final profile = UserProfile(
        id: '123e4567-e89b-12d3-a456-426614174000',
        username: 'johndoe',
        fullName: 'John Doe',
        email: 'john@example.com',
        createdAt: DateTime.parse('2025-01-01T00:00:00.000Z'),
        updatedAt: DateTime.parse('2025-01-01T00:00:00.000Z'),
      );

      expect(profile.availabilityStatus, 'active');
    });
  });
}
