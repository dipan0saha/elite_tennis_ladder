import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../services/ladder_service.dart';

/// Screen for creating a new tennis ladder
class CreateLadderScreen extends StatefulWidget {
  const CreateLadderScreen({super.key});

  @override
  State<CreateLadderScreen> createState() => _CreateLadderScreenState();
}

class _CreateLadderScreenState extends State<CreateLadderScreen> {
  final _formKey = GlobalKey<FormState>();
  final LadderService _ladderService = LadderService();
  final AuthService _authService = AuthService();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  String _visibility = 'public';
  int _maxPlayers = 100;
  int _challengeRange = 3;
  int _maxConcurrentChallenges = 2;
  int _challengeCooldownDays = 14;
  int _challengeResponseDays = 7;
  String _scoringSystem = 'swap';

  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _createLadder() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final userId = _authService.currentUser?.id;
    if (userId == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('You must be logged in to create a ladder')),
        );
      }
      return;
    }

    setState(() => _isLoading = true);

    try {
      await _ladderService.createLadder(
        name: _nameController.text.trim(),
        description: _descriptionController.text.trim().isEmpty
            ? null
            : _descriptionController.text.trim(),
        adminId: userId,
        visibility: _visibility,
        maxPlayers: _maxPlayers,
        challengeRange: _challengeRange,
        maxConcurrentChallenges: _maxConcurrentChallenges,
        challengeCooldownDays: _challengeCooldownDays,
        challengeResponseDays: _challengeResponseDays,
        scoringSystem: _scoringSystem,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Ladder created successfully!'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context, true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to create ladder: $e'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create New Ladder'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            // Basic Info Section
            Text(
              'Basic Information',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Ladder Name',
                hintText: 'e.g., Summer Tennis Ladder 2025',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.sports_tennis),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter a ladder name';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description (optional)',
                hintText: 'Brief description of your ladder',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.description),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              initialValue: _visibility,
              decoration: const InputDecoration(
                labelText: 'Visibility',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.visibility),
              ),
              items: const [
                DropdownMenuItem(value: 'public', child: Text('Public')),
                DropdownMenuItem(value: 'private', child: Text('Private')),
                DropdownMenuItem(
                    value: 'invite_only', child: Text('Invite Only')),
              ],
              onChanged: (value) {
                setState(() => _visibility = value!);
              },
            ),

            const SizedBox(height: 32),

            // Challenge Rules Section
            Text(
              'Challenge Rules',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            _buildSliderField(
              label: 'Max Players',
              value: _maxPlayers.toDouble(),
              min: 10,
              max: 500,
              divisions: 49,
              onChanged: (value) => setState(() => _maxPlayers = value.toInt()),
            ),
            _buildSliderField(
              label: 'Challenge Range (positions above you can challenge)',
              value: _challengeRange.toDouble(),
              min: 1,
              max: 10,
              divisions: 9,
              onChanged: (value) =>
                  setState(() => _challengeRange = value.toInt()),
            ),
            _buildSliderField(
              label: 'Max Concurrent Challenges',
              value: _maxConcurrentChallenges.toDouble(),
              min: 1,
              max: 5,
              divisions: 4,
              onChanged: (value) =>
                  setState(() => _maxConcurrentChallenges = value.toInt()),
            ),
            _buildSliderField(
              label: 'Challenge Cooldown (days)',
              value: _challengeCooldownDays.toDouble(),
              min: 0,
              max: 30,
              divisions: 30,
              onChanged: (value) =>
                  setState(() => _challengeCooldownDays = value.toInt()),
            ),
            _buildSliderField(
              label: 'Challenge Response Time (days)',
              value: _challengeResponseDays.toDouble(),
              min: 1,
              max: 14,
              divisions: 13,
              onChanged: (value) =>
                  setState(() => _challengeResponseDays = value.toInt()),
            ),

            const SizedBox(height: 32),

            // Scoring System Section
            Text(
              'Scoring System',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              initialValue: _scoringSystem,
              decoration: const InputDecoration(
                labelText: 'Scoring System',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.emoji_events),
              ),
              items: const [
                DropdownMenuItem(
                    value: 'swap',
                    child: Text('Swap (Winner takes loser\'s rank)')),
                DropdownMenuItem(value: 'points', child: Text('Points Based')),
                DropdownMenuItem(value: 'elo', child: Text('ELO Rating')),
              ],
              onChanged: (value) {
                setState(() => _scoringSystem = value!);
              },
            ),

            const SizedBox(height: 32),

            // Create Button
            ElevatedButton(
              onPressed: _isLoading ? null : _createLadder,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(16.0),
              ),
              child: _isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Create Ladder'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSliderField({
    required String label,
    required double value,
    required double min,
    required double max,
    required int divisions,
    required ValueChanged<double> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                label,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
            Text(
              value.toInt().toString(),
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                  ),
            ),
          ],
        ),
        Slider(
          value: value,
          min: min,
          max: max,
          divisions: divisions,
          label: value.toInt().toString(),
          onChanged: onChanged,
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}
