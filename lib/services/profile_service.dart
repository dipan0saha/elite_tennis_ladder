import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/user_profile.dart';

/// Profile service for handling user profile operations
/// Provides CRUD operations for user profiles and avatar uploads
class ProfileService {
  final SupabaseClient _supabase = Supabase.instance.client;

  /// Get the current user's ID
  String? get currentUserId => _supabase.auth.currentUser?.id;

  /// Get a user profile by user ID
  /// Returns null if profile doesn't exist
  Future<UserProfile?> getProfile(String userId) async {
    try {
      final response = await _supabase
          .from('profiles')
          .select()
          .eq('id', userId)
          .maybeSingle();

      if (response == null) {
        return null;
      }

      return UserProfile.fromJson(response);
    } catch (e) {
      throw Exception('Failed to fetch profile: $e');
    }
  }

  /// Get the current user's profile
  Future<UserProfile?> getCurrentUserProfile() async {
    final userId = currentUserId;
    if (userId == null) {
      throw Exception('No authenticated user');
    }
    return getProfile(userId);
  }

  /// Update user profile
  /// Returns the updated profile
  Future<UserProfile> updateProfile({
    required String userId,
    String? fullName,
    String? phone,
    String? bio,
    String? skillLevel,
    String? availabilityStatus,
    String? avatarUrl,
  }) async {
    try {
      final updates = <String, dynamic>{};
      
      if (fullName != null) updates['full_name'] = fullName;
      if (phone != null) updates['phone'] = phone;
      if (bio != null) updates['bio'] = bio;
      if (skillLevel != null) updates['skill_level'] = skillLevel;
      if (availabilityStatus != null) updates['availability_status'] = availabilityStatus;
      if (avatarUrl != null) updates['avatar_url'] = avatarUrl;

      final response = await _supabase
          .from('profiles')
          .update(updates)
          .eq('id', userId)
          .select()
          .single();

      return UserProfile.fromJson(response);
    } catch (e) {
      throw Exception('Failed to update profile: $e');
    }
  }

  /// Upload an avatar image and return the public URL
  /// The file is stored in Supabase Storage under avatars/{userId}/{filename}
  Future<String> uploadAvatar({
    required String userId,
    required File imageFile,
    required String fileName,
  }) async {
    try {
      // Create a unique file path
      final filePath = '$userId/$fileName';

      // Upload the file to Supabase Storage
      await _supabase.storage
          .from('avatars')
          .upload(
            filePath,
            imageFile,
            fileOptions: const FileOptions(
              upsert: true,
            ),
          );

      // Get the public URL for the uploaded file
      final publicUrl = _supabase.storage
          .from('avatars')
          .getPublicUrl(filePath);

      return publicUrl;
    } catch (e) {
      throw Exception('Failed to upload avatar: $e');
    }
  }

  /// Delete the current avatar from storage
  Future<void> deleteAvatar(String avatarUrl) async {
    try {
      // Extract the file path from the URL
      final uri = Uri.parse(avatarUrl);
      final pathSegments = uri.pathSegments;
      
      // Find the index of 'avatars' in the path
      final avatarsIndex = pathSegments.indexOf('avatars');
      if (avatarsIndex == -1 || avatarsIndex >= pathSegments.length - 1) {
        throw Exception('Invalid avatar URL format');
      }

      // Get the file path after 'avatars/'
      final filePath = pathSegments.sublist(avatarsIndex + 1).join('/');

      // Delete the file from storage
      await _supabase.storage
          .from('avatars')
          .remove([filePath]);
    } catch (e) {
      throw Exception('Failed to delete avatar: $e');
    }
  }
}
