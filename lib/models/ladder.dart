/// Ladder model representing a tennis ladder configuration
/// Maps to the ladders table in Supabase
class Ladder {
  final String id;
  final String name;
  final String? description;
  final String adminId;
  final String visibility;
  final int maxPlayers;
  final int challengeRange;
  final int maxConcurrentChallenges;
  final int challengeCooldownDays;
  final int challengeResponseDays;
  final int inactivityWarningDays;
  final int inactivityPenaltyDays;
  final String inactivityAction;
  final String scoringSystem;
  final bool requireScoreVerification;
  final bool allowScoreDisputes;
  final bool divisionsEnabled;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  Ladder({
    required this.id,
    required this.name,
    this.description,
    required this.adminId,
    this.visibility = 'public',
    this.maxPlayers = 100,
    this.challengeRange = 3,
    this.maxConcurrentChallenges = 2,
    this.challengeCooldownDays = 14,
    this.challengeResponseDays = 7,
    this.inactivityWarningDays = 45,
    this.inactivityPenaltyDays = 60,
    this.inactivityAction = 'inactive_pool',
    this.scoringSystem = 'swap',
    this.requireScoreVerification = true,
    this.allowScoreDisputes = true,
    this.divisionsEnabled = false,
    this.isActive = true,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Create Ladder from Supabase JSON response
  factory Ladder.fromJson(Map<String, dynamic> json) {
    return Ladder(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      adminId: json['admin_id'] as String,
      visibility: json['visibility'] as String? ?? 'public',
      maxPlayers: json['max_players'] as int? ?? 100,
      challengeRange: json['challenge_range'] as int? ?? 3,
      maxConcurrentChallenges: json['max_concurrent_challenges'] as int? ?? 2,
      challengeCooldownDays: json['challenge_cooldown_days'] as int? ?? 14,
      challengeResponseDays: json['challenge_response_days'] as int? ?? 7,
      inactivityWarningDays: json['inactivity_warning_days'] as int? ?? 45,
      inactivityPenaltyDays: json['inactivity_penalty_days'] as int? ?? 60,
      inactivityAction: json['inactivity_action'] as String? ?? 'inactive_pool',
      scoringSystem: json['scoring_system'] as String? ?? 'swap',
      requireScoreVerification: json['require_score_verification'] as bool? ?? true,
      allowScoreDisputes: json['allow_score_disputes'] as bool? ?? true,
      divisionsEnabled: json['divisions_enabled'] as bool? ?? false,
      isActive: json['is_active'] as bool? ?? true,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  /// Convert Ladder to JSON for Supabase
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'admin_id': adminId,
      'visibility': visibility,
      'max_players': maxPlayers,
      'challenge_range': challengeRange,
      'max_concurrent_challenges': maxConcurrentChallenges,
      'challenge_cooldown_days': challengeCooldownDays,
      'challenge_response_days': challengeResponseDays,
      'inactivity_warning_days': inactivityWarningDays,
      'inactivity_penalty_days': inactivityPenaltyDays,
      'inactivity_action': inactivityAction,
      'scoring_system': scoringSystem,
      'require_score_verification': requireScoreVerification,
      'allow_score_disputes': allowScoreDisputes,
      'divisions_enabled': divisionsEnabled,
      'is_active': isActive,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  /// Create a copy of the ladder with updated fields
  Ladder copyWith({
    String? id,
    String? name,
    String? description,
    String? adminId,
    String? visibility,
    int? maxPlayers,
    int? challengeRange,
    int? maxConcurrentChallenges,
    int? challengeCooldownDays,
    int? challengeResponseDays,
    int? inactivityWarningDays,
    int? inactivityPenaltyDays,
    String? inactivityAction,
    String? scoringSystem,
    bool? requireScoreVerification,
    bool? allowScoreDisputes,
    bool? divisionsEnabled,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Ladder(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      adminId: adminId ?? this.adminId,
      visibility: visibility ?? this.visibility,
      maxPlayers: maxPlayers ?? this.maxPlayers,
      challengeRange: challengeRange ?? this.challengeRange,
      maxConcurrentChallenges: maxConcurrentChallenges ?? this.maxConcurrentChallenges,
      challengeCooldownDays: challengeCooldownDays ?? this.challengeCooldownDays,
      challengeResponseDays: challengeResponseDays ?? this.challengeResponseDays,
      inactivityWarningDays: inactivityWarningDays ?? this.inactivityWarningDays,
      inactivityPenaltyDays: inactivityPenaltyDays ?? this.inactivityPenaltyDays,
      inactivityAction: inactivityAction ?? this.inactivityAction,
      scoringSystem: scoringSystem ?? this.scoringSystem,
      requireScoreVerification: requireScoreVerification ?? this.requireScoreVerification,
      allowScoreDisputes: allowScoreDisputes ?? this.allowScoreDisputes,
      divisionsEnabled: divisionsEnabled ?? this.divisionsEnabled,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
