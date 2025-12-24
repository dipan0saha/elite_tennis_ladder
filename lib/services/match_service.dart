import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/match.dart';

/// Service for managing tennis matches
class MatchService {
  final SupabaseClient _supabase = Supabase.instance.client;

  /// Get all matches for a ladder
  Future<List<Match>> getLadderMatches(String ladderId) async {
    try {
      final response = await _supabase
          .from('matches')
          .select()
          .eq('ladder_id', ladderId)
          .order('created_at', ascending: false);

      return (response as List).map((json) => Match.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to load ladder matches: $e');
    }
  }

  /// Get matches for a specific player
  Future<List<Match>> getPlayerMatches(String playerId) async {
    try {
      final response = await _supabase
          .from('matches')
          .select()
          .or('player1_id.eq.$playerId,player2_id.eq.$playerId')
          .order('created_at', ascending: false);

      return (response as List).map((json) => Match.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to load player matches: $e');
    }
  }

  /// Get a single match by ID
  Future<Match?> getMatch(String matchId) async {
    try {
      final response =
          await _supabase.from('matches').select().eq('id', matchId).single();

      return Match.fromJson(response);
    } catch (e) {
      throw Exception('Failed to load match: $e');
    }
  }

  /// Create a new match
  Future<Match> createMatch({
    required String ladderId,
    String? challengeId,
    required String player1Id,
    required String player2Id,
    DateTime? scheduledAt,
    String? location,
  }) async {
    try {
      final response = await _supabase
          .from('matches')
          .insert({
            'ladder_id': ladderId,
            'challenge_id': challengeId,
            'player1_id': player1Id,
            'player2_id': player2Id,
            'scheduled_at': scheduledAt?.toIso8601String(),
            'location': location,
            'status': 'scheduled',
          })
          .select()
          .single();

      return Match.fromJson(response);
    } catch (e) {
      throw Exception('Failed to create match: $e');
    }
  }

  /// Report match score
  Future<Match> reportScore({
    required String matchId,
    required int player1Set1,
    required int player2Set1,
    required int player1Set2,
    required int player2Set2,
    int? player1Set3,
    int? player2Set3,
    required String reporterId,
  }) async {
    try {
      final response = await _supabase
          .from('matches')
          .update({
            'player1_set1_score': player1Set1,
            'player2_set1_score': player2Set1,
            'player1_set2_score': player1Set2,
            'player2_set2_score': player2Set2,
            'player1_set3_score': player1Set3,
            'player2_set3_score': player2Set3,
            'status': 'completed',
            'completed_at': DateTime.now().toIso8601String(),
          })
          .eq('id', matchId)
          .select()
          .single();

      return Match.fromJson(response);
    } catch (e) {
      throw Exception('Failed to report score: $e');
    }
  }

  /// Verify match score
  Future<Match> verifyScore({
    required String matchId,
    required String playerId,
  }) async {
    try {
      // Get current match to determine which player is verifying
      final match = await getMatch(matchId);
      if (match == null) {
        throw Exception('Match not found');
      }

      Map<String, dynamic> updates = {};
      if (match.player1Id == playerId) {
        updates['player1_verified'] = true;
        updates['player1_verified_at'] = DateTime.now().toIso8601String();
      } else if (match.player2Id == playerId) {
        updates['player2_verified'] = true;
        updates['player2_verified_at'] = DateTime.now().toIso8601String();
      }

      final response = await _supabase
          .from('matches')
          .update(updates)
          .eq('id', matchId)
          .select()
          .single();

      return Match.fromJson(response);
    } catch (e) {
      throw Exception('Failed to verify score: $e');
    }
  }

  /// Dispute match score
  Future<Match> disputeScore({
    required String matchId,
    required String disputedBy,
    required String reason,
    String? evidenceUrl,
  }) async {
    try {
      final response = await _supabase
          .from('matches')
          .update({
            'status': 'disputed',
            'disputed_by': disputedBy,
            'dispute_reason': reason,
            'dispute_evidence_url': evidenceUrl,
            'disputed_at': DateTime.now().toIso8601String(),
          })
          .eq('id', matchId)
          .select()
          .single();

      return Match.fromJson(response);
    } catch (e) {
      throw Exception('Failed to dispute score: $e');
    }
  }

  /// Resolve match dispute (admin only)
  Future<Match> resolveDispute({
    required String matchId,
    required String resolution,
  }) async {
    try {
      final response = await _supabase
          .from('matches')
          .update({
            'status': 'completed',
            'dispute_resolution': resolution,
            'dispute_resolved_at': DateTime.now().toIso8601String(),
          })
          .eq('id', matchId)
          .select()
          .single();

      return Match.fromJson(response);
    } catch (e) {
      throw Exception('Failed to resolve dispute: $e');
    }
  }

  /// Cancel a match
  Future<Match> cancelMatch(String matchId) async {
    try {
      final response = await _supabase
          .from('matches')
          .update({'status': 'cancelled'})
          .eq('id', matchId)
          .select()
          .single();

      return Match.fromJson(response);
    } catch (e) {
      throw Exception('Failed to cancel match: $e');
    }
  }

  /// Get match statistics for a player
  Future<Map<String, int>> getPlayerStats(String playerId) async {
    try {
      final matches = await getPlayerMatches(playerId);

      int wins = 0;
      int losses = 0;
      int total = 0;

      for (var match in matches) {
        if (match.status == 'completed' && match.winnerId != null) {
          total++;
          if (match.winnerId == playerId) {
            wins++;
          } else {
            losses++;
          }
        }
      }

      return {
        'wins': wins,
        'losses': losses,
        'total': total,
      };
    } catch (e) {
      return {'wins': 0, 'losses': 0, 'total': 0};
    }
  }
}
