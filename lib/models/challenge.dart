/// Challenge model representing a match challenge between players
/// Maps to the challenges table in Supabase
class Challenge {
  final String id;
  final String ladderId;
  final String challengerId;
  final String opponentId;
  final String status;
  final String? message;
  final String? declineReason;
  final String? cancellationReason;
  final DateTime? expiresAt;
  final DateTime? respondedAt;
  final DateTime? completedAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  Challenge({
    required this.id,
    required this.ladderId,
    required this.challengerId,
    required this.opponentId,
    this.status = 'pending',
    this.message,
    this.declineReason,
    this.cancellationReason,
    this.expiresAt,
    this.respondedAt,
    this.completedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Create Challenge from Supabase JSON response
  factory Challenge.fromJson(Map<String, dynamic> json) {
    return Challenge(
      id: json['id'] as String,
      ladderId: json['ladder_id'] as String,
      challengerId: json['challenger_id'] as String,
      opponentId: json['opponent_id'] as String,
      status: json['status'] as String? ?? 'pending',
      message: json['message'] as String?,
      declineReason: json['decline_reason'] as String?,
      cancellationReason: json['cancellation_reason'] as String?,
      expiresAt: json['expires_at'] != null 
          ? DateTime.parse(json['expires_at'] as String)
          : null,
      respondedAt: json['responded_at'] != null 
          ? DateTime.parse(json['responded_at'] as String)
          : null,
      completedAt: json['completed_at'] != null 
          ? DateTime.parse(json['completed_at'] as String)
          : null,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  /// Convert Challenge to JSON for Supabase
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'ladder_id': ladderId,
      'challenger_id': challengerId,
      'opponent_id': opponentId,
      'status': status,
      'message': message,
      'decline_reason': declineReason,
      'cancellation_reason': cancellationReason,
      'expires_at': expiresAt?.toIso8601String(),
      'responded_at': respondedAt?.toIso8601String(),
      'completed_at': completedAt?.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  /// Create a copy of the challenge with updated fields
  Challenge copyWith({
    String? id,
    String? ladderId,
    String? challengerId,
    String? opponentId,
    String? status,
    String? message,
    String? declineReason,
    String? cancellationReason,
    DateTime? expiresAt,
    DateTime? respondedAt,
    DateTime? completedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Challenge(
      id: id ?? this.id,
      ladderId: ladderId ?? this.ladderId,
      challengerId: challengerId ?? this.challengerId,
      opponentId: opponentId ?? this.opponentId,
      status: status ?? this.status,
      message: message ?? this.message,
      declineReason: declineReason ?? this.declineReason,
      cancellationReason: cancellationReason ?? this.cancellationReason,
      expiresAt: expiresAt ?? this.expiresAt,
      respondedAt: respondedAt ?? this.respondedAt,
      completedAt: completedAt ?? this.completedAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  /// Check if challenge is expired
  bool get isExpired {
    return expiresAt != null && expiresAt!.isBefore(DateTime.now());
  }

  /// Check if challenge is pending
  bool get isPending {
    return status == 'pending';
  }

  /// Check if challenge is accepted
  bool get isAccepted {
    return status == 'accepted';
  }
}
