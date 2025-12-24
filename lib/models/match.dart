/// Match model representing a tennis match result
/// Maps to the matches table in Supabase
class Match {
  final String id;
  final String ladderId;
  final String? challengeId;
  final String player1Id;
  final String player2Id;
  final String? winnerId;
  final String status;
  final DateTime? scheduledAt;
  final DateTime? startedAt;
  final DateTime? completedAt;
  final String? location;
  final String? courtSurface;

  // Score details
  final int? player1Set1Score;
  final int? player1Set2Score;
  final int? player1Set3Score;
  final int? player2Set1Score;
  final int? player2Set2Score;
  final int? player2Set3Score;

  // Verification
  final bool player1Verified;
  final bool player2Verified;
  final DateTime? player1VerifiedAt;
  final DateTime? player2VerifiedAt;

  // Dispute
  final String? disputedBy;
  final String? disputeReason;
  final String? disputeEvidenceUrl;
  final DateTime? disputedAt;
  final DateTime? disputeResolvedAt;
  final String? disputeResolution;

  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;

  Match({
    required this.id,
    required this.ladderId,
    this.challengeId,
    required this.player1Id,
    required this.player2Id,
    this.winnerId,
    this.status = 'scheduled',
    this.scheduledAt,
    this.startedAt,
    this.completedAt,
    this.location,
    this.courtSurface,
    this.player1Set1Score,
    this.player1Set2Score,
    this.player1Set3Score,
    this.player2Set1Score,
    this.player2Set2Score,
    this.player2Set3Score,
    this.player1Verified = false,
    this.player2Verified = false,
    this.player1VerifiedAt,
    this.player2VerifiedAt,
    this.disputedBy,
    this.disputeReason,
    this.disputeEvidenceUrl,
    this.disputedAt,
    this.disputeResolvedAt,
    this.disputeResolution,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Create Match from Supabase JSON response
  factory Match.fromJson(Map<String, dynamic> json) {
    return Match(
      id: json['id'] as String,
      ladderId: json['ladder_id'] as String,
      challengeId: json['challenge_id'] as String?,
      player1Id: json['player1_id'] as String,
      player2Id: json['player2_id'] as String,
      winnerId: json['winner_id'] as String?,
      status: json['status'] as String? ?? 'scheduled',
      scheduledAt: json['scheduled_at'] != null
          ? DateTime.parse(json['scheduled_at'] as String)
          : null,
      startedAt: json['started_at'] != null
          ? DateTime.parse(json['started_at'] as String)
          : null,
      completedAt: json['completed_at'] != null
          ? DateTime.parse(json['completed_at'] as String)
          : null,
      location: json['location'] as String?,
      courtSurface: json['court_surface'] as String?,
      player1Set1Score: json['player1_set1_score'] as int?,
      player1Set2Score: json['player1_set2_score'] as int?,
      player1Set3Score: json['player1_set3_score'] as int?,
      player2Set1Score: json['player2_set1_score'] as int?,
      player2Set2Score: json['player2_set2_score'] as int?,
      player2Set3Score: json['player2_set3_score'] as int?,
      player1Verified: json['player1_verified'] as bool? ?? false,
      player2Verified: json['player2_verified'] as bool? ?? false,
      player1VerifiedAt: json['player1_verified_at'] != null
          ? DateTime.parse(json['player1_verified_at'] as String)
          : null,
      player2VerifiedAt: json['player2_verified_at'] != null
          ? DateTime.parse(json['player2_verified_at'] as String)
          : null,
      disputedBy: json['disputed_by'] as String?,
      disputeReason: json['dispute_reason'] as String?,
      disputeEvidenceUrl: json['dispute_evidence_url'] as String?,
      disputedAt: json['disputed_at'] != null
          ? DateTime.parse(json['disputed_at'] as String)
          : null,
      disputeResolvedAt: json['dispute_resolved_at'] != null
          ? DateTime.parse(json['dispute_resolved_at'] as String)
          : null,
      disputeResolution: json['dispute_resolution'] as String?,
      notes: json['notes'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  /// Convert Match to JSON for Supabase
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'ladder_id': ladderId,
      'challenge_id': challengeId,
      'player1_id': player1Id,
      'player2_id': player2Id,
      'winner_id': winnerId,
      'status': status,
      'scheduled_at': scheduledAt?.toIso8601String(),
      'started_at': startedAt?.toIso8601String(),
      'completed_at': completedAt?.toIso8601String(),
      'location': location,
      'court_surface': courtSurface,
      'player1_set1_score': player1Set1Score,
      'player1_set2_score': player1Set2Score,
      'player1_set3_score': player1Set3Score,
      'player2_set1_score': player2Set1Score,
      'player2_set2_score': player2Set2Score,
      'player2_set3_score': player2Set3Score,
      'player1_verified': player1Verified,
      'player2_verified': player2Verified,
      'player1_verified_at': player1VerifiedAt?.toIso8601String(),
      'player2_verified_at': player2VerifiedAt?.toIso8601String(),
      'disputed_by': disputedBy,
      'dispute_reason': disputeReason,
      'dispute_evidence_url': disputeEvidenceUrl,
      'disputed_at': disputedAt?.toIso8601String(),
      'dispute_resolved_at': disputeResolvedAt?.toIso8601String(),
      'dispute_resolution': disputeResolution,
      'notes': notes,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  /// Check if match is completed
  bool get isCompleted {
    return status == 'completed';
  }

  /// Check if both players have verified
  bool get isBothVerified {
    return player1Verified && player2Verified;
  }

  /// Check if match is disputed
  bool get isDisputed {
    return status == 'disputed';
  }

  /// Get total sets won by player 1
  int get player1SetsWon {
    int sets = 0;
    if (player1Set1Score != null &&
        player2Set1Score != null &&
        player1Set1Score! > player2Set1Score!) {
      sets++;
    }
    if (player1Set2Score != null &&
        player2Set2Score != null &&
        player1Set2Score! > player2Set2Score!) {
      sets++;
    }
    if (player1Set3Score != null &&
        player2Set3Score != null &&
        player1Set3Score! > player2Set3Score!) {
      sets++;
    }
    return sets;
  }

  /// Get total sets won by player 2
  int get player2SetsWon {
    int sets = 0;
    if (player1Set1Score != null &&
        player2Set1Score != null &&
        player2Set1Score! > player1Set1Score!) {
      sets++;
    }
    if (player1Set2Score != null &&
        player2Set2Score != null &&
        player2Set2Score! > player1Set2Score!) {
      sets++;
    }
    if (player1Set3Score != null &&
        player2Set3Score != null &&
        player2Set3Score! > player1Set3Score!) {
      sets++;
    }
    return sets;
  }
}
