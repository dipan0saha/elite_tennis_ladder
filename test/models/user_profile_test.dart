import 'package:flutter_test/flutter_test.dart';
import 'package:elite_tennis_ladder/models/user_profile.dart';

void main() {
  group('UserProfile', () {
    final testDateTime = DateTime.parse('2025-01-01T00:00:00.000Z');
    
    test('should create UserProfile from JSON with all fields', () {
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
      expect(profile.createdAt, testDateTime);
      expect(profile.updatedAt, testDateTime);
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
      expect(profile.availabilityStatus, 'active');
    });

    test('should convert UserProfile to JSON with all fields', () {
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
        createdAt: testDateTime,
        updatedAt: testDateTime,
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
      expect(json['created_at'], testDateTime.toIso8601String());
      expect(json['updated_at'], testDateTime.toIso8601String());
    });

    test('should convert UserProfile to JSON with null optional fields', () {
      final profile = UserProfile(
        id: '123e4567-e89b-12d3-a456-426614174000',
        username: 'johndoe',
        fullName: 'John Doe',
        email: 'john@example.com',
        availabilityStatus: 'active',
        createdAt: testDateTime,
        updatedAt: testDateTime,
      );

      final json = profile.toJson();

      expect(json['phone'], isNull);
      expect(json['avatar_url'], isNull);
      expect(json['bio'], isNull);
      expect(json['skill_level'], isNull);
    });

    test('should create copy with updated single field', () {
      final profile = UserProfile(
        id: '123e4567-e89b-12d3-a456-426614174000',
        username: 'johndoe',
        fullName: 'John Doe',
        email: 'john@example.com',
        availabilityStatus: 'active',
        createdAt: testDateTime,
        updatedAt: testDateTime,
      );

      final updatedProfile = profile.copyWith(bio: 'Updated bio');

      expect(updatedProfile.id, profile.id);
      expect(updatedProfile.username, profile.username);
      expect(updatedProfile.fullName, profile.fullName);
      expect(updatedProfile.email, profile.email);
      expect(updatedProfile.bio, 'Updated bio');
      expect(updatedProfile.skillLevel, isNull);
    });

    test('should create copy with multiple updated fields', () {
      final profile = UserProfile(
        id: '123e4567-e89b-12d3-a456-426614174000',
        username: 'johndoe',
        fullName: 'John Doe',
        email: 'john@example.com',
        availabilityStatus: 'active',
        createdAt: testDateTime,
        updatedAt: testDateTime,
      );

      final updatedProfile = profile.copyWith(
        bio: 'Updated bio',
        skillLevel: 'advanced',
        phone: '+9876543210',
        avatarUrl: 'https://example.com/new-avatar.jpg',
      );

      expect(updatedProfile.id, profile.id);
      expect(updatedProfile.username, profile.username);
      expect(updatedProfile.bio, 'Updated bio');
      expect(updatedProfile.skillLevel, 'advanced');
      expect(updatedProfile.phone, '+9876543210');
      expect(updatedProfile.avatarUrl, 'https://example.com/new-avatar.jpg');
    });

    test('should create copy without changes when no parameters provided', () {
      final profile = UserProfile(
        id: '123e4567-e89b-12d3-a456-426614174000',
        username: 'johndoe',
        fullName: 'John Doe',
        email: 'john@example.com',
        bio: 'Original bio',
        skillLevel: 'intermediate',
        availabilityStatus: 'active',
        createdAt: testDateTime,
        updatedAt: testDateTime,
      );

      final copiedProfile = profile.copyWith();

      expect(copiedProfile.id, profile.id);
      expect(copiedProfile.username, profile.username);
      expect(copiedProfile.fullName, profile.fullName);
      expect(copiedProfile.email, profile.email);
      expect(copiedProfile.bio, profile.bio);
      expect(copiedProfile.skillLevel, profile.skillLevel);
      expect(copiedProfile.availabilityStatus, profile.availabilityStatus);
    });

    test('should default availabilityStatus to active', () {
      final profile = UserProfile(
        id: '123e4567-e89b-12d3-a456-426614174000',
        username: 'johndoe',
        fullName: 'John Doe',
        email: 'john@example.com',
        createdAt: testDateTime,
        updatedAt: testDateTime,
      );

      expect(profile.availabilityStatus, 'active');
    });

    test('should handle all skill level values', () {
      final skillLevels = ['beginner', 'intermediate', 'advanced', 'expert'];
      
      for (final level in skillLevels) {
        final json = {
          'id': '123e4567-e89b-12d3-a456-426614174000',
          'username': 'johndoe',
          'full_name': 'John Doe',
          'email': 'john@example.com',
          'skill_level': level,
          'availability_status': 'active',
          'created_at': '2025-01-01T00:00:00.000Z',
          'updated_at': '2025-01-01T00:00:00.000Z',
        };

        final profile = UserProfile.fromJson(json);
        expect(profile.skillLevel, level);
      }
    });

    test('should handle all availability status values', () {
      final statuses = ['active', 'vacation', 'injured', 'inactive'];
      
      for (final status in statuses) {
        final json = {
          'id': '123e4567-e89b-12d3-a456-426614174000',
          'username': 'johndoe',
          'full_name': 'John Doe',
          'email': 'john@example.com',
          'availability_status': status,
          'created_at': '2025-01-01T00:00:00.000Z',
          'updated_at': '2025-01-01T00:00:00.000Z',
        };

        final profile = UserProfile.fromJson(json);
        expect(profile.availabilityStatus, status);
      }
    });

    test('should handle JSON round-trip conversion', () {
      final originalProfile = UserProfile(
        id: '123e4567-e89b-12d3-a456-426614174000',
        username: 'johndoe',
        fullName: 'John Doe',
        email: 'john@example.com',
        phone: '+1234567890',
        avatarUrl: 'https://example.com/avatar.jpg',
        bio: 'Tennis enthusiast',
        skillLevel: 'intermediate',
        availabilityStatus: 'active',
        createdAt: testDateTime,
        updatedAt: testDateTime,
      );

      final json = originalProfile.toJson();
      final reconstructedProfile = UserProfile.fromJson(json);

      expect(reconstructedProfile.id, originalProfile.id);
      expect(reconstructedProfile.username, originalProfile.username);
      expect(reconstructedProfile.fullName, originalProfile.fullName);
      expect(reconstructedProfile.email, originalProfile.email);
      expect(reconstructedProfile.phone, originalProfile.phone);
      expect(reconstructedProfile.avatarUrl, originalProfile.avatarUrl);
      expect(reconstructedProfile.bio, originalProfile.bio);
      expect(reconstructedProfile.skillLevel, originalProfile.skillLevel);
      expect(reconstructedProfile.availabilityStatus, originalProfile.availabilityStatus);
      expect(reconstructedProfile.createdAt, originalProfile.createdAt);
      expect(reconstructedProfile.updatedAt, originalProfile.updatedAt);
    });

    test('should handle empty string values', () {
      final json = {
        'id': '123e4567-e89b-12d3-a456-426614174000',
        'username': 'johndoe',
        'full_name': 'John Doe',
        'email': 'john@example.com',
        'phone': '',
        'avatar_url': '',
        'bio': '',
        'skill_level': null,
        'availability_status': 'active',
        'created_at': '2025-01-01T00:00:00.000Z',
        'updated_at': '2025-01-01T00:00:00.000Z',
      };

      final profile = UserProfile.fromJson(json);

      expect(profile.phone, '');
      expect(profile.avatarUrl, '');
      expect(profile.bio, '');
    });
  });
}
