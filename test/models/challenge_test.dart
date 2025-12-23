import 'package:flutter_test/flutter_test.dart';
import 'package:elite_tennis_ladder/models/challenge.dart';

void main() {
  group('Challenge Model Tests', () {
    test('fromJson creates valid Challenge', () {
      final json = {
        'id': 'c123',
        'ladder_id': 'l123',
        'challenger_id': 'p1',
        'opponent_id': 'p2',
        'status': 'pending',
        'message': 'Good luck!',
        'created_at': '2025-01-01T00:00:00Z',
        'updated_at': '2025-01-01T00:00:00Z',
        'expires_at': '2025-01-08T00:00:00Z',
      };

      final challenge = Challenge.fromJson(json);

      expect(challenge.id, 'c123');
      expect(challenge.ladderId, 'l123');
      expect(challenge.challengerId, 'p1');
      expect(challenge.opponentId, 'p2');
      expect(challenge.status, 'pending');
      expect(challenge.message, 'Good luck!');
      expect(challenge.expiresAt, isNotNull);
    });

    test('toJson creates valid JSON', () {
      final challenge = Challenge(
        id: 'c123',
        ladderId: 'l123',
        challengerId: 'p1',
        opponentId: 'p2',
        status: 'pending',
        message: 'Good luck!',
        createdAt: DateTime.parse('2025-01-01T00:00:00Z'),
        updatedAt: DateTime.parse('2025-01-01T00:00:00Z'),
      );

      final json = challenge.toJson();

      expect(json['id'], 'c123');
      expect(json['ladder_id'], 'l123');
      expect(json['challenger_id'], 'p1');
      expect(json['opponent_id'], 'p2');
      expect(json['status'], 'pending');
      expect(json['message'], 'Good luck!');
    });

    test('isPending returns correct value', () {
      final pending = Challenge(
        id: 'c123',
        ladderId: 'l123',
        challengerId: 'p1',
        opponentId: 'p2',
        status: 'pending',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      final accepted = Challenge(
        id: 'c124',
        ladderId: 'l123',
        challengerId: 'p1',
        opponentId: 'p2',
        status: 'accepted',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      expect(pending.isPending, true);
      expect(accepted.isPending, false);
    });

    test('isExpired returns correct value', () {
      final future = DateTime.now().add(const Duration(days: 7));
      final past = DateTime.now().subtract(const Duration(days: 1));

      final notExpired = Challenge(
        id: 'c123',
        ladderId: 'l123',
        challengerId: 'p1',
        opponentId: 'p2',
        expiresAt: future,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      final expired = Challenge(
        id: 'c124',
        ladderId: 'l123',
        challengerId: 'p1',
        opponentId: 'p2',
        expiresAt: past,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      expect(notExpired.isExpired, false);
      expect(expired.isExpired, true);
    });

    test('isAccepted returns correct value', () {
      final accepted = Challenge(
        id: 'c123',
        ladderId: 'l123',
        challengerId: 'p1',
        opponentId: 'p2',
        status: 'accepted',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      final pending = Challenge(
        id: 'c124',
        ladderId: 'l123',
        challengerId: 'p1',
        opponentId: 'p2',
        status: 'pending',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      expect(accepted.isAccepted, true);
      expect(pending.isAccepted, false);
    });
  });
}
