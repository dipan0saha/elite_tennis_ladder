import 'package:flutter/material.dart';
import '../models/ladder_member.dart';
import '../models/user_profile.dart';
import '../services/auth_service.dart';
import '../services/challenge_service.dart';

/// Screen for creating a new challenge
class ChallengeCreateScreen extends StatefulWidget {
  final String ladderId;
  final int myRank;
  final List<LadderMember> members;
  final Map<String, UserProfile> profiles;
  final int challengeRange;

  const ChallengeCreateScreen({
    super.key,
    required this.ladderId,
    required this.myRank,
    required this.members,
    required this.profiles,
    required this.challengeRange,
  });

  @override
  State<ChallengeCreateScreen> createState() => _ChallengeCreateScreenState();
}

class _ChallengeCreateScreenState extends State<ChallengeCreateScreen> {
  final _formKey = GlobalKey<FormState>();
  final ChallengeService _challengeService = ChallengeService();
  final AuthService _authService = AuthService();

  final TextEditingController _messageController = TextEditingController();

  String? _selectedOpponentId;
  bool _isLoading = false;

  List<LadderMember> get _availableOpponents {
    final userId = _authService.currentUser?.id;
    if (userId == null) return [];

    // Can challenge players ranked above you within challenge range
    return widget.members.where((member) {
      if (member.playerId == userId) return false;
      // Must have a valid rank to be challengeable
      final r = member.rank;
      if (r == null) return false;
      // Can challenge players above you within the ladder's challenge range
      return r < widget.myRank && (widget.myRank - r) <= widget.challengeRange;
    }).toList();
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _createChallenge() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_selectedOpponentId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select an opponent')),
      );
      return;
    }

    final userId = _authService.currentUser?.id;
    if (userId == null) return;

    setState(() => _isLoading = true);

    try {
      await _challengeService.createChallenge(
        ladderId: widget.ladderId,
        challengerId: userId,
        opponentId: _selectedOpponentId!,
        message: _messageController.text.trim().isEmpty
            ? null
            : _messageController.text.trim(),
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Challenge sent successfully!'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context, true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to create challenge: $e'),
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
        title: const Text('Create Challenge'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            Card(
              color: Theme.of(context).colorScheme.primaryContainer,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'You can challenge players ranked above you',
                        style: TextStyle(
                          color:
                              Theme.of(context).colorScheme.onPrimaryContainer,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Select Opponent',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            if (_availableOpponents.isEmpty) ...[
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    children: [
                      Icon(
                        Icons.person_off,
                        size: 48,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'No available opponents',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'There are no players ranked above you to challenge',
                        style: Theme.of(context).textTheme.bodySmall,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ] else ...[
              ..._availableOpponents.map((member) {
                final profile = widget.profiles[member.playerId];
                final isSelected = _selectedOpponentId == member.playerId;

                return Card(
                  margin: const EdgeInsets.only(bottom: 8.0),
                  color: isSelected
                      ? Theme.of(context).colorScheme.primaryContainer
                      : null,
                  child: RadioListTile<String>(
                    // ignore: deprecated_member_use
                    value: member.playerId,
                    // ignore: deprecated_member_use
                    groupValue: _selectedOpponentId,
                    // ignore: deprecated_member_use
                    onChanged: (value) {
                      setState(() => _selectedOpponentId = value);
                    },
                    title: Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: _getRankColor(member.rank),
                          radius: 16,
                          child: Text(
                            '#${member.rank ?? '-'}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            profile?.fullName ?? 'Unknown Player',
                            style: TextStyle(
                              fontWeight: isSelected
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                            ),
                          ),
                        ),
                      ],
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(left: 44.0),
                      child: Text(
                        'W: ${member.wins ?? 0} | L: ${member.losses ?? 0}',
                      ),
                    ),
                  ),
                );
              }).toList(),
            ],
            const SizedBox(height: 24),
            Text(
              'Challenge Message (Optional)',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _messageController,
              decoration: const InputDecoration(
                hintText: 'Add a message to your challenge...',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: _isLoading || _availableOpponents.isEmpty
                  ? null
                  : _createChallenge,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(16.0),
              ),
              child: _isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Send Challenge'),
            ),
          ],
        ),
      ),
    );
  }

  Color _getRankColor(int? rank) {
    if (rank == null) return Theme.of(context).colorScheme.primary;
    if (rank == 1) return Colors.amber;
    if (rank == 2) return Colors.grey.shade400;
    if (rank == 3) return Colors.brown.shade300;
    return Theme.of(context).colorScheme.primary;
  }
}
