import 'package:flutter_test/flutter_test.dart';
import 'package:elite_tennis_ladder/models/match.dart';

void main() {
  group('Match Model Tests', () {
    test('fromJson creates valid Match', () {
      final json = {
        'id': 'm123',
        'ladder_id': 'l123',
        'challenge_id': 'c123',
        'player1_id': 'p1',
        'player2_id': 'p2',
        'winner_id': 'p1',
        'status': 'completed',
        'player1_set1_score': 6,
        'player2_set1_score': 4,
        'player1_set2_score': 6,
        'player2_set2_score': 3,
        'player1_verified': true,
        'player2_verified': false,
        'created_at': '2025-01-01T00:00:00Z',
        'updated_at': '2025-01-01T00:00:00Z',
      };

      final match = Match.fromJson(json);

      expect(match.id, 'm123');
      expect(match.ladderId, 'l123');
      expect(match.challengeId, 'c123');
      expect(match.player1Id, 'p1');
      expect(match.player2Id, 'p2');
      expect(match.winnerId, 'p1');
      expect(match.status, 'completed');
      expect(match.player1Set1Score, 6);
      expect(match.player2Set1Score, 4);
    });

    test('toJson creates valid JSON', () {
      final match = Match(
        id: 'm123',
        ladderId: 'l123',
        player1Id: 'p1',
        player2Id: 'p2',
        winnerId: 'p1',
        status: 'completed',
        player1Set1Score: 6,
        player2Set1Score: 4,
        createdAt: DateTime.parse('2025-01-01T00:00:00Z'),
        updatedAt: DateTime.parse('2025-01-01T00:00:00Z'),
      );

      final json = match.toJson();

      expect(json['id'], 'm123');
      expect(json['ladder_id'], 'l123');
      expect(json['player1_id'], 'p1');
      expect(json['player2_id'], 'p2');
      expect(json['winner_id'], 'p1');
      expect(json['status'], 'completed');
    });

    test('isCompleted returns correct value', () {
      final completed = Match(
        id: 'm123',
        ladderId: 'l123',
        player1Id: 'p1',
        player2Id: 'p2',
        status: 'completed',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      final scheduled = Match(
        id: 'm124',
        ladderId: 'l123',
        player1Id: 'p1',
        player2Id: 'p2',
        status: 'scheduled',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      expect(completed.isCompleted, true);
      expect(scheduled.isCompleted, false);
    });

    test('isBothVerified returns correct value', () {
      final bothVerified = Match(
        id: 'm123',
        ladderId: 'l123',
        player1Id: 'p1',
        player2Id: 'p2',
        player1Verified: true,
        player2Verified: true,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      final notBothVerified = Match(
        id: 'm124',
        ladderId: 'l123',
        player1Id: 'p1',
        player2Id: 'p2',
        player1Verified: true,
        player2Verified: false,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      expect(bothVerified.isBothVerified, true);
      expect(notBothVerified.isBothVerified, false);
    });

    test('player1SetsWon calculates correctly', () {
      final match = Match(
        id: 'm123',
        ladderId: 'l123',
        player1Id: 'p1',
        player2Id: 'p2',
        player1Set1Score: 6,
        player2Set1Score: 4,
        player1Set2Score: 3,
        player2Set2Score: 6,
        player1Set3Score: 6,
        player2Set3Score: 2,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      expect(match.player1SetsWon, 2); // Won sets 1 and 3
      expect(match.player2SetsWon, 1); // Won set 2
    });

    test('isDisputed returns correct value', () {
      final disputed = Match(
        id: 'm123',
        ladderId: 'l123',
        player1Id: 'p1',
        player2Id: 'p2',
        status: 'disputed',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      final notDisputed = Match(
        id: 'm124',
        ladderId: 'l123',
        player1Id: 'p1',
        player2Id: 'p2',
        status: 'completed',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      expect(disputed.isDisputed, true);
      expect(notDisputed.isDisputed, false);
    });
  });
}
