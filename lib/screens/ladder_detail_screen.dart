import 'package:flutter/material.dart';
import '../models/ladder.dart';
import '../models/ladder_member.dart';
import '../models/user_profile.dart';
import '../services/auth_service.dart';
import '../services/ladder_service.dart';
import '../services/profile_service.dart';
import '../widgets/empty_state.dart';
import '../widgets/error_state.dart';
import '../widgets/loading_state.dart';
import 'challenge_create_screen.dart';

/// Screen displaying ladder details and rankings
class LadderDetailScreen extends StatefulWidget {
  final String ladderId;

  const LadderDetailScreen({
    super.key,
    required this.ladderId,
  });

  @override
  State<LadderDetailScreen> createState() => _LadderDetailScreenState();
}

class _LadderDetailScreenState extends State<LadderDetailScreen> {
  final LadderService _ladderService = LadderService();
  final ProfileService _profileService = ProfileService();
  final AuthService _authService = AuthService();

  Ladder? _ladder;
  List<LadderMember> _members = [];
  Map<String, UserProfile> _profiles = {};
  bool _isLoading = true;
  bool _isMember = false;
  int? _myRank;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final userId = _authService.currentUser?.id;

      // Load ladder and members
      final ladder = await _ladderService.getLadder(widget.ladderId);
      final members = await _ladderService.getLadderMembers(widget.ladderId);

      // Load profiles for all members concurrently
      final Map<String, UserProfile> profiles = {};
      final profileFutures = members.map((member) async {
        try {
          final profile = await _profileService.getProfileById(member.playerId);
          if (profile != null) {
            return MapEntry(member.playerId, profile);
          }
        } catch (e) {
          // Continue even if individual profile fails
        }
        return null;
      }).toList();

      final profileResults = await Future.wait(profileFutures);
      for (var entry in profileResults) {
        if (entry != null) {
          profiles[entry.key] = entry.value;
        }
      }

      // Check if current user is a member
      bool isMember = false;
      int? myRank;
      if (userId != null) {
        isMember = await _ladderService.isMember(widget.ladderId, userId);
        if (isMember) {
          myRank = await _ladderService.getUserRank(widget.ladderId, userId);
        }
      }

      if (mounted) {
        setState(() {
          _ladder = ladder;
          _members = members;
          _profiles = profiles;
          _isMember = isMember;
          _myRank = myRank;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = 'Failed to load ladder: $e';
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _joinLadder() async {
    final userId = _authService.currentUser?.id;
    if (userId == null) return;

    try {
      await _ladderService.joinLadder(widget.ladderId, userId);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Successfully joined ladder!'),
            backgroundColor: Colors.green,
          ),
        );
        _loadData();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to join ladder: $e'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }

  Future<void> _leaveLadder() async {
    final userId = _authService.currentUser?.id;
    if (userId == null) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Leave Ladder'),
        content: const Text('Are you sure you want to leave this ladder?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Leave'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    try {
      await _ladderService.leaveLadder(widget.ladderId, userId);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Left ladder successfully'),
            backgroundColor: Colors.green,
          ),
        );
        _loadData();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to leave ladder: $e'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_ladder?.name ?? 'Ladder Details'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh',
            onPressed: _loadData,
          ),
        ],
      ),
      body: _isLoading
          ? const LoadingState(message: 'Loading ladder...')
          : _errorMessage != null
              ? ErrorState(
                  message: _errorMessage!,
                  onRetry: _loadData,
                )
              : _buildContent(),
      floatingActionButton: _isMember && _ladder != null
          ? Builder(builder: (context) {
              final width = MediaQuery.of(context).size.width;
              final route = MaterialPageRoute(
                builder: (context) => ChallengeCreateScreen(
                  ladderId: widget.ladderId,
                  myRank: _myRank ?? 999,
                  members: _members,
                  profiles: _profiles,
                  challengeRange: _ladder!.challengeRange,
                ),
              );

              if (width > 420) {
                return FloatingActionButton.extended(
                  onPressed: () => Navigator.push(context, route),
                  icon: const Icon(Icons.emoji_events),
                  label: const Text('Create Challenge'),
                );
              }

              return FloatingActionButton(
                onPressed: () => Navigator.push(context, route),
                tooltip: 'Create Challenge',
                child: const Icon(Icons.emoji_events),
              );
            })
          : null,
    );
  }

  Widget _buildContent() {
    if (_ladder == null) {
      return const Center(child: Text('Ladder not found'));
    }

    return RefreshIndicator(
      onRefresh: _loadData,
      child: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildLadderInfo(),
          const SizedBox(height: 24),
          if (!_isMember) ...[
            ElevatedButton.icon(
              onPressed: _joinLadder,
              icon: const Icon(Icons.add),
              label: const Text('Join Ladder'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(16.0),
              ),
            ),
            const SizedBox(height: 24),
          ],
          if (_isMember) ...[
            Card(
              color: Theme.of(context).colorScheme.primaryContainer,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Icon(
                      Icons.emoji_events,
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Your Rank: #${_myRank ?? "N/A"}',
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onPrimaryContainer,
                                ),
                      ),
                    ),
                    TextButton(
                      onPressed: _leaveLadder,
                      child: const Text('Leave'),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
          Text(
            'Rankings',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 12),
          _buildRankings(),
        ],
      ),
    );
  }

  Widget _buildLadderInfo() {
    if (_ladder == null) return const SizedBox.shrink();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_ladder!.description != null) ...[
              Text(
                _ladder!.description!,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const Divider(height: 24),
            ],
            _buildInfoRow(
                Icons.people, 'Max Players', _ladder!.maxPlayers.toString()),
            _buildInfoRow(Icons.trending_up, 'Challenge Range',
                _ladder!.challengeRange.toString()),
            _buildInfoRow(Icons.emoji_events, 'Scoring',
                _formatScoringSystem(_ladder!.scoringSystem)),
            _buildInfoRow(Icons.timer, 'Response Time',
                '${_ladder!.challengeResponseDays} days'),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Theme.of(context).colorScheme.primary),
          const SizedBox(width: 12),
          Text(
            '$label:',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const Spacer(),
          Text(
            value,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildRankings() {
    if (_members.isEmpty) {
      return const EmptyState(
        icon: Icons.people_outline,
        title: 'No Members Yet',
        message: 'Be the first to join this ladder!',
      );
    }

    return Column(
      children: _members.map((member) => _buildRankingTile(member)).toList(),
    );
  }

  Widget _buildRankingTile(LadderMember member) {
    final profile = _profiles[member.playerId];
    final isCurrentUser = _authService.currentUser?.id == member.playerId;

    return Card(
      margin: const EdgeInsets.only(bottom: 8.0),
      color: isCurrentUser
          ? Theme.of(context)
              .colorScheme
              .primaryContainer
              .withValues(alpha: 0.3)
          : null,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: _getRankColor(member.rank),
          child: Text(
            '#${member.rank ?? '-'}',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        title: Text(
          profile?.fullName ?? 'Unknown Player',
          style: TextStyle(
            fontWeight: isCurrentUser ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        subtitle: Text(
          'W: ${member.wins ?? 0} | L: ${member.losses ?? 0}${member.winRate != null ? " | ${(member.winRate! * 100).toStringAsFixed(0)}%" : ""}',
        ),
        trailing:
            isCurrentUser ? const Icon(Icons.star, color: Colors.amber) : null,
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

  String _formatScoringSystem(String system) {
    switch (system) {
      case 'swap':
        return 'Swap';
      case 'points':
        return 'Points';
      case 'elo':
        return 'ELO';
      default:
        return system;
    }
  }
}
