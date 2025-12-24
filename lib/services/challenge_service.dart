import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/challenge.dart';

/// Service for managing match challenges
class ChallengeService {
  final SupabaseClient _supabase = Supabase.instance.client;

  /// Get all challenges for a ladder
  Future<List<Challenge>> getLadderChallenges(String ladderId) async {
    try {
      final response = await _supabase
          .from('challenges')
          .select()
          .eq('ladder_id', ladderId)
          .order('created_at', ascending: false);

      return (response as List)
          .map((json) => Challenge.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Failed to load ladder challenges: $e');
    }
  }

  /// Get challenges sent by a user
  Future<List<Challenge>> getMyChallenges(String userId) async {
    try {
      final response = await _supabase
          .from('challenges')
          .select()
          .eq('challenger_id', userId)
          .order('created_at', ascending: false);

      return (response as List)
          .map((json) => Challenge.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Failed to load your challenges: $e');
    }
  }

  /// Get challenges received by a user
  Future<List<Challenge>> getReceivedChallenges(String userId) async {
    try {
      final response = await _supabase
          .from('challenges')
          .select()
          .eq('opponent_id', userId)
          .order('created_at', ascending: false);

      return (response as List)
          .map((json) => Challenge.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Failed to load received challenges: $e');
    }
  }

  /// Get pending challenges for a user
  Future<List<Challenge>> getPendingChallenges(String userId) async {
    try {
      final response = await _supabase
          .from('challenges')
          .select()
          .eq('opponent_id', userId)
          .eq('status', 'pending')
          .order('created_at', ascending: false);

      return (response as List)
          .map((json) => Challenge.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Failed to load pending challenges: $e');
    }
  }

  /// Create a new challenge
  Future<Challenge> createChallenge({
    required String ladderId,
    required String challengerId,
    required String opponentId,
    String? message,
  }) async {
    try {
      final response = await _supabase
          .from('challenges')
          .insert({
            'ladder_id': ladderId,
            'challenger_id': challengerId,
            'opponent_id': opponentId,
            'message': message,
            'status': 'pending',
          })
          .select()
          .single();

      return Challenge.fromJson(response);
    } catch (e) {
      throw Exception('Failed to create challenge: $e');
    }
  }

  /// Accept a challenge
  Future<Challenge> acceptChallenge(String challengeId) async {
    try {
      final response = await _supabase
          .from('challenges')
          .update({
            'status': 'accepted',
            'responded_at': DateTime.now().toIso8601String(),
          })
          .eq('id', challengeId)
          .select()
          .single();

      return Challenge.fromJson(response);
    } catch (e) {
      throw Exception('Failed to accept challenge: $e');
    }
  }

  /// Decline a challenge
  Future<Challenge> declineChallenge(String challengeId, String? reason) async {
    try {
      final response = await _supabase
          .from('challenges')
          .update({
            'status': 'declined',
            'decline_reason': reason,
            'responded_at': DateTime.now().toIso8601String(),
          })
          .eq('id', challengeId)
          .select()
          .single();

      return Challenge.fromJson(response);
    } catch (e) {
      throw Exception('Failed to decline challenge: $e');
    }
  }

  /// Cancel a challenge
  Future<Challenge> cancelChallenge(String challengeId, String? reason) async {
    try {
      final response = await _supabase
          .from('challenges')
          .update({
            'status': 'cancelled',
            'cancellation_reason': reason,
          })
          .eq('id', challengeId)
          .select()
          .single();

      return Challenge.fromJson(response);
    } catch (e) {
      throw Exception('Failed to cancel challenge: $e');
    }
  }

  /// Mark challenge as completed
  Future<Challenge> completeChallenge(String challengeId) async {
    try {
      final response = await _supabase
          .from('challenges')
          .update({
            'status': 'completed',
            'completed_at': DateTime.now().toIso8601String(),
          })
          .eq('id', challengeId)
          .select()
          .single();

      return Challenge.fromJson(response);
    } catch (e) {
      throw Exception('Failed to complete challenge: $e');
    }
  }

  /// Get a single challenge by ID
  Future<Challenge?> getChallenge(String challengeId) async {
    try {
      final response = await _supabase
          .from('challenges')
          .select()
          .eq('id', challengeId)
          .single();

      return Challenge.fromJson(response);
    } catch (e) {
      throw Exception('Failed to load challenge: $e');
    }
  }

  /// Count active challenges for a user
  Future<int> getActiveChallengeCount(String userId) async {
    try {
      final response = await _supabase
          .from('challenges')
          .select()
          .eq('challenger_id', userId)
          .inFilter('status', ['pending', 'accepted']);

      return (response as List).length;
    } catch (e) {
      return 0;
    }
  }
}
