import 'package:flutter_test/flutter_test.dart';
import 'package:elite_tennis_ladder/models/ladder.dart';

void main() {
  group('Ladder Model Tests', () {
    test('fromJson creates valid Ladder', () {
      final json = {
        'id': '123',
        'name': 'Test Ladder',
        'description': 'A test ladder',
        'admin_id': 'admin123',
        'visibility': 'public',
        'max_players': 50,
        'challenge_range': 3,
        'max_concurrent_challenges': 2,
        'challenge_cooldown_days': 14,
        'challenge_response_days': 7,
        'inactivity_warning_days': 45,
        'inactivity_penalty_days': 60,
        'inactivity_action': 'inactive_pool',
        'scoring_system': 'swap',
        'require_score_verification': true,
        'allow_score_disputes': true,
        'divisions_enabled': false,
        'is_active': true,
        'created_at': '2025-01-01T00:00:00Z',
        'updated_at': '2025-01-01T00:00:00Z',
      };

      final ladder = Ladder.fromJson(json);

      expect(ladder.id, '123');
      expect(ladder.name, 'Test Ladder');
      expect(ladder.description, 'A test ladder');
      expect(ladder.adminId, 'admin123');
      expect(ladder.visibility, 'public');
      expect(ladder.maxPlayers, 50);
      expect(ladder.challengeRange, 3);
      expect(ladder.scoringSystem, 'swap');
      expect(ladder.isActive, true);
    });

    test('toJson creates valid JSON', () {
      final ladder = Ladder(
        id: '123',
        name: 'Test Ladder',
        description: 'A test ladder',
        adminId: 'admin123',
        visibility: 'public',
        maxPlayers: 50,
        challengeRange: 3,
        createdAt: DateTime.parse('2025-01-01T00:00:00Z'),
        updatedAt: DateTime.parse('2025-01-01T00:00:00Z'),
      );

      final json = ladder.toJson();

      expect(json['id'], '123');
      expect(json['name'], 'Test Ladder');
      expect(json['admin_id'], 'admin123');
      expect(json['visibility'], 'public');
      expect(json['max_players'], 50);
    });

    test('copyWith creates modified copy', () {
      final ladder = Ladder(
        id: '123',
        name: 'Test Ladder',
        adminId: 'admin123',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      final modified = ladder.copyWith(name: 'New Name', maxPlayers: 200);

      expect(modified.id, ladder.id);
      expect(modified.name, 'New Name');
      expect(modified.maxPlayers, 200);
      expect(modified.adminId, ladder.adminId);
    });

    test('fromJson handles null optional fields', () {
      final json = {
        'id': '123',
        'name': 'Test Ladder',
        'admin_id': 'admin123',
        'created_at': '2025-01-01T00:00:00Z',
        'updated_at': '2025-01-01T00:00:00Z',
      };

      final ladder = Ladder.fromJson(json);

      expect(ladder.description, null);
      expect(ladder.visibility, 'public'); // default value
      expect(ladder.maxPlayers, 100); // default value
    });
  });
}
