/// Ladder Member model representing a player's membership in a ladder
/// Maps to the ladder_members table in Supabase
class LadderMember {
  final String id;
  final String ladderId;
  final String playerId;
  final int rank;
  final String status;
  final DateTime? lastMatchDate;
  final int? wins;
  final int? losses;
  final double? winRate;
  final DateTime joinedAt;
  final DateTime updatedAt;

  LadderMember({
    required this.id,
    required this.ladderId,
    required this.playerId,
    required this.rank,
    this.status = 'active',
    this.lastMatchDate,
    this.wins = 0,
    this.losses = 0,
    this.winRate = 0.0,
    required this.joinedAt,
    required this.updatedAt,
  });

  /// Create LadderMember from Supabase JSON response
  factory LadderMember.fromJson(Map<String, dynamic> json) {
    return LadderMember(
      id: json['id'] as String,
      ladderId: json['ladder_id'] as String,
      playerId: json['player_id'] as String,
      rank: json['rank'] as int,
      status: json['status'] as String? ?? 'active',
      lastMatchDate: json['last_match_date'] != null 
          ? DateTime.parse(json['last_match_date'] as String)
          : null,
      wins: json['wins'] as int? ?? 0,
      losses: json['losses'] as int? ?? 0,
      winRate: (json['win_rate'] as num?)?.toDouble() ?? 0.0,
      joinedAt: DateTime.parse(json['joined_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  /// Convert LadderMember to JSON for Supabase
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'ladder_id': ladderId,
      'player_id': playerId,
      'rank': rank,
      'status': status,
      'last_match_date': lastMatchDate?.toIso8601String(),
      'wins': wins,
      'losses': losses,
      'win_rate': winRate,
      'joined_at': joinedAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  /// Create a copy of the ladder member with updated fields
  LadderMember copyWith({
    String? id,
    String? ladderId,
    String? playerId,
    int? rank,
    String? status,
    DateTime? lastMatchDate,
    int? wins,
    int? losses,
    double? winRate,
    DateTime? joinedAt,
    DateTime? updatedAt,
  }) {
    return LadderMember(
      id: id ?? this.id,
      ladderId: ladderId ?? this.ladderId,
      playerId: playerId ?? this.playerId,
      rank: rank ?? this.rank,
      status: status ?? this.status,
      lastMatchDate: lastMatchDate ?? this.lastMatchDate,
      wins: wins ?? this.wins,
      losses: losses ?? this.losses,
      winRate: winRate ?? this.winRate,
      joinedAt: joinedAt ?? this.joinedAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
