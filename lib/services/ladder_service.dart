import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/ladder.dart';
import '../models/ladder_member.dart';

/// Service for managing tennis ladders
class LadderService {
  final SupabaseClient _supabase = Supabase.instance.client;

  /// Get all public ladders
  Future<List<Ladder>> getPublicLadders() async {
    try {
      final response = await _supabase
          .from('ladders')
          .select()
          .eq('visibility', 'public')
          .eq('is_active', true)
          .order('created_at', ascending: false);

      return (response as List)
          .map((json) => Ladder.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Failed to load public ladders: $e');
    }
  }

  /// Get ladders where user is admin
  Future<List<Ladder>> getMyLadders(String userId) async {
    try {
      final response = await _supabase
          .from('ladders')
          .select()
          .eq('admin_id', userId)
          .order('created_at', ascending: false);

      return (response as List)
          .map((json) => Ladder.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Failed to load your ladders: $e');
    }
  }

  /// Get ladders where user is a member
  Future<List<Ladder>> getJoinedLadders(String userId) async {
    try {
      final response = await _supabase
          .from('ladder_members')
          .select('ladder_id, ladders(*)')
          .eq('player_id', userId)
          .eq('status', 'active');

      return (response as List)
          .map((json) => Ladder.fromJson(json['ladders'] as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Failed to load joined ladders: $e');
    }
  }

  /// Get a single ladder by ID
  Future<Ladder?> getLadder(String ladderId) async {
    try {
      final response = await _supabase
          .from('ladders')
          .select()
          .eq('id', ladderId)
          .single();

      return Ladder.fromJson(response as Map<String, dynamic>);
    } catch (e) {
      throw Exception('Failed to load ladder: $e');
    }
  }

  /// Create a new ladder
  Future<Ladder> createLadder({
    required String name,
    String? description,
    required String adminId,
    String visibility = 'public',
    int maxPlayers = 100,
    int challengeRange = 3,
    int maxConcurrentChallenges = 2,
    int challengeCooldownDays = 14,
    int challengeResponseDays = 7,
    String scoringSystem = 'swap',
  }) async {
    try {
      final response = await _supabase
          .from('ladders')
          .insert({
            'name': name,
            'description': description,
            'admin_id': adminId,
            'visibility': visibility,
            'max_players': maxPlayers,
            'challenge_range': challengeRange,
            'max_concurrent_challenges': maxConcurrentChallenges,
            'challenge_cooldown_days': challengeCooldownDays,
            'challenge_response_days': challengeResponseDays,
            'scoring_system': scoringSystem,
          })
          .select()
          .single();

      return Ladder.fromJson(response as Map<String, dynamic>);
    } catch (e) {
      throw Exception('Failed to create ladder: $e');
    }
  }

  /// Update an existing ladder
  Future<Ladder> updateLadder(String ladderId, Map<String, dynamic> updates) async {
    try {
      final response = await _supabase
          .from('ladders')
          .update(updates)
          .eq('id', ladderId)
          .select()
          .single();

      return Ladder.fromJson(response as Map<String, dynamic>);
    } catch (e) {
      throw Exception('Failed to update ladder: $e');
    }
  }

  /// Delete a ladder
  Future<void> deleteLadder(String ladderId) async {
    try {
      await _supabase
          .from('ladders')
          .delete()
          .eq('id', ladderId);
    } catch (e) {
      throw Exception('Failed to delete ladder: $e');
    }
  }

  /// Get ladder members with rankings
  Future<List<LadderMember>> getLadderMembers(String ladderId) async {
    try {
      final response = await _supabase
          .from('ladder_members')
          .select()
          .eq('ladder_id', ladderId)
          .eq('status', 'active')
          .order('rank', ascending: true);

      return (response as List)
          .map((json) => LadderMember.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Failed to load ladder members: $e');
    }
  }

  /// Join a ladder
  Future<LadderMember> joinLadder(String ladderId, String playerId) async {
    try {
      // Get current member count to determine rank
      final members = await getLadderMembers(ladderId);
      final nextRank = members.length + 1;

      final response = await _supabase
          .from('ladder_members')
          .insert({
            'ladder_id': ladderId,
            'player_id': playerId,
            'rank': nextRank,
            'status': 'active',
          })
          .select()
          .single();

      return LadderMember.fromJson(response as Map<String, dynamic>);
    } catch (e) {
      throw Exception('Failed to join ladder: $e');
    }
  }

  /// Leave a ladder
  Future<void> leaveLadder(String ladderId, String playerId) async {
    try {
      await _supabase
          .from('ladder_members')
          .update({'status': 'inactive'})
          .eq('ladder_id', ladderId)
          .eq('player_id', playerId);
    } catch (e) {
      throw Exception('Failed to leave ladder: $e');
    }
  }

  /// Check if user is member of ladder
  Future<bool> isMember(String ladderId, String playerId) async {
    try {
      final response = await _supabase
          .from('ladder_members')
          .select()
          .eq('ladder_id', ladderId)
          .eq('player_id', playerId)
          .eq('status', 'active');

      return (response as List).isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  /// Get user's rank in ladder
  Future<int?> getUserRank(String ladderId, String playerId) async {
    try {
      final response = await _supabase
          .from('ladder_members')
          .select('rank')
          .eq('ladder_id', ladderId)
          .eq('player_id', playerId)
          .eq('status', 'active')
          .single();

      return response['rank'] as int?;
    } catch (e) {
      return null;
    }
  }
}
