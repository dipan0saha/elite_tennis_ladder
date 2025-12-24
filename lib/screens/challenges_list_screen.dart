import 'package:flutter/material.dart';
import '../models/challenge.dart';
import '../models/user_profile.dart';
import '../services/auth_service.dart';
import '../services/challenge_service.dart';
import '../services/profile_service.dart';
import '../widgets/empty_state.dart';
import '../widgets/error_state.dart';
import '../widgets/loading_state.dart';
import 'report_score_screen.dart';

/// Screen displaying user's challenges
class ChallengesListScreen extends StatefulWidget {
  const ChallengesListScreen({super.key});

  @override
  State<ChallengesListScreen> createState() => _ChallengesListScreenState();
}

class _ChallengesListScreenState extends State<ChallengesListScreen>
    with SingleTickerProviderStateMixin {
  final ChallengeService _challengeService = ChallengeService();
  final ProfileService _profileService = ProfileService();
  final AuthService _authService = AuthService();

  late TabController _tabController;
  List<Challenge> _pendingChallenges = [];
  List<Challenge> _sentChallenges = [];
  List<Challenge> _receivedChallenges = [];
  Map<String, UserProfile> _profiles = {};
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadChallenges();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadChallenges() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final userId = _authService.currentUser?.id;
      if (userId == null) {
        throw Exception('Not authenticated');
      }

      final results = await Future.wait([
        _challengeService.getPendingChallenges(userId),
        _challengeService.getMyChallenges(userId),
        _challengeService.getReceivedChallenges(userId),
      ]);

      final pending = results[0];
      final sent = results[1];
      final received = results[2];

      // Collect all unique user IDs
      final userIds = <String>{};
      for (var challenge in [...pending, ...sent, ...received]) {
        userIds.add(challenge.challengerId);
        userIds.add(challenge.opponentId);
      }

      // Load profiles concurrently
      final Map<String, UserProfile> profiles = {};
      final profileFutures = userIds.map((userId) async {
        try {
          final profile = await _profileService.getProfileById(userId);
          if (profile != null) {
            return MapEntry(userId, profile);
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

      if (mounted) {
        setState(() {
          _pendingChallenges = pending;
          _sentChallenges = sent;
          _receivedChallenges = received;
          _profiles = profiles;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = 'Failed to load challenges: $e';
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _acceptChallenge(Challenge challenge) async {
    try {
      await _challengeService.acceptChallenge(challenge.id);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Challenge accepted!'),
            backgroundColor: Colors.green,
          ),
        );
        _loadChallenges();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to accept challenge: $e'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }

  Future<void> _declineChallenge(Challenge challenge) async {
    final reason = await showDialog<String>(
      context: context,
      builder: (context) => _DeclineDialog(),
    );

    if (reason == null) return;

    try {
      await _challengeService.declineChallenge(challenge.id, reason);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Challenge declined'),
            backgroundColor: Colors.orange,
          ),
        );
        _loadChallenges();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to decline challenge: $e'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }

  Future<void> _cancelChallenge(Challenge challenge) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cancel Challenge'),
        content: const Text('Are you sure you want to cancel this challenge?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Yes'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    try {
      await _challengeService.cancelChallenge(challenge.id, null);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Challenge cancelled'),
            backgroundColor: Colors.orange,
          ),
        );
        _loadChallenges();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to cancel challenge: $e'),
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
        title: const Text('My Challenges'),
        bottom: TabBar(
          controller: _tabController,
          // Use theme onPrimary for contrast so it adapts to app theme
          labelColor: Theme.of(context).colorScheme.onPrimary,
          unselectedLabelColor:
              Theme.of(context).colorScheme.onPrimary.withOpacity(0.7),
          indicatorColor: Theme.of(context).colorScheme.onPrimary,
          tabs: [
            Tab(
              text: 'Pending',
              icon: Badge(
                label: Text(_pendingChallenges.length.toString()),
                child: const Icon(Icons.notifications_active),
              ),
            ),
            const Tab(text: 'Sent', icon: Icon(Icons.send)),
            const Tab(text: 'Received', icon: Icon(Icons.inbox)),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh',
            onPressed: _loadChallenges,
          ),
        ],
      ),
      body: _isLoading
          ? const LoadingState(message: 'Loading challenges...')
          : _errorMessage != null
              ? ErrorState(
                  message: _errorMessage!,
                  onRetry: _loadChallenges,
                )
              : TabBarView(
                  controller: _tabController,
                  children: [
                    _buildChallengeList(
                        _pendingChallenges, 'No pending challenges', true),
                    _buildChallengeList(
                        _sentChallenges, 'No sent challenges', false),
                    _buildChallengeList(
                        _receivedChallenges, 'No received challenges', false),
                  ],
                ),
    );
  }

  Widget _buildChallengeList(
      List<Challenge> challenges, String emptyMessage, bool showActions) {
    if (challenges.isEmpty) {
      return EmptyState(
        icon: Icons.emoji_events,
        title: 'No Challenges',
        message: emptyMessage,
      );
    }

    return RefreshIndicator(
      onRefresh: _loadChallenges,
      child: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: challenges.length,
        itemBuilder: (context, index) {
          final challenge = challenges[index];
          return _buildChallengeCard(challenge, showActions);
        },
      ),
    );
  }

  Widget _buildChallengeCard(Challenge challenge, bool showActions) {
    final userId = _authService.currentUser?.id;
    final isChallenger = challenge.challengerId == userId;
    final otherUserId =
        isChallenger ? challenge.opponentId : challenge.challengerId;
    final otherProfile = _profiles[otherUserId];

    return Card(
      margin: const EdgeInsets.only(bottom: 12.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    isChallenger
                        ? 'To: ${otherProfile?.fullName ?? "Unknown"}'
                        : 'From: ${otherProfile?.fullName ?? "Unknown"}',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                _buildStatusChip(challenge.status),
              ],
            ),
            if (challenge.message != null) ...[
              const SizedBox(height: 8),
              Text(
                challenge.message!,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
              ),
            ],
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.access_time,
                    size: 16,
                    color: Theme.of(context).colorScheme.onSurfaceVariant),
                const SizedBox(width: 4),
                Text(
                  _formatDate(challenge.createdAt),
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                if (challenge.expiresAt != null) ...[
                  const SizedBox(width: 16),
                  Icon(Icons.event,
                      size: 16,
                      color: Theme.of(context).colorScheme.onSurfaceVariant),
                  const SizedBox(width: 4),
                  Text(
                    'Expires: ${_formatDate(challenge.expiresAt!)}',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ],
            ),
            if (showActions &&
                challenge.status == 'pending' &&
                !isChallenger) ...[
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => _acceptChallenge(challenge),
                      icon: const Icon(Icons.check),
                      label: const Text('Accept'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => _declineChallenge(challenge),
                      icon: const Icon(Icons.close),
                      label: const Text('Decline'),
                    ),
                  ),
                ],
              ),
            ],
            if (challenge.status == 'accepted') ...[
              const SizedBox(height: 12),
              ElevatedButton.icon(
                onPressed: () async {
                  final challengerProfile = _profiles[challenge.challengerId];
                  final opponentProfile = _profiles[challenge.opponentId];

                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ReportScoreScreen(
                        ladderId: challenge.ladderId,
                        challengeId: challenge.id,
                        player1Id: challenge.challengerId,
                        player2Id: challenge.opponentId,
                        player1Name: challengerProfile?.fullName ?? 'Player 1',
                        player2Name: opponentProfile?.fullName ?? 'Player 2',
                      ),
                    ),
                  );

                  if (result == true) {
                    _loadChallenges();
                  }
                },
                icon: const Icon(Icons.scoreboard),
                label: const Text('Report Score'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
            if (challenge.status == 'pending' && isChallenger) ...[
              const SizedBox(height: 12),
              OutlinedButton.icon(
                onPressed: () => _cancelChallenge(challenge),
                icon: const Icon(Icons.cancel),
                label: const Text('Cancel Challenge'),
              ),
            ],
            if (challenge.status == 'declined' &&
                challenge.declineReason != null) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: Colors.orange.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(4.0),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.info_outline,
                        size: 16, color: Colors.orange),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Reason: ${challenge.declineReason}',
                        style: const TextStyle(fontSize: 12),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildStatusChip(String status) {
    Color color;
    IconData icon;

    switch (status) {
      case 'pending':
        color = Colors.orange;
        icon = Icons.hourglass_empty;
        break;
      case 'accepted':
        color = Colors.green;
        icon = Icons.check_circle;
        break;
      case 'declined':
        color = Colors.red;
        icon = Icons.cancel;
        break;
      case 'cancelled':
        color = Colors.grey;
        icon = Icons.block;
        break;
      case 'expired':
        color = Colors.grey;
        icon = Icons.access_time;
        break;
      case 'completed':
        color = Colors.blue;
        icon = Icons.done_all;
        break;
      default:
        color = Colors.grey;
        icon = Icons.help;
    }

    return Chip(
      avatar: Icon(icon, size: 16, color: color),
      label: Text(
        status.toUpperCase(),
        style: TextStyle(fontSize: 10, color: color),
      ),
      backgroundColor: color.withValues(alpha: 0.1),
      padding: EdgeInsets.zero,
      visualDensity: VisualDensity.compact,
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }
}

class _DeclineDialog extends StatefulWidget {
  @override
  State<_DeclineDialog> createState() => _DeclineDialogState();
}

class _DeclineDialogState extends State<_DeclineDialog> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Decline Challenge'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('Please provide a reason for declining:'),
          const SizedBox(height: 16),
          TextField(
            controller: _controller,
            decoration: const InputDecoration(
              hintText: 'Reason...',
              border: OutlineInputBorder(),
            ),
            maxLines: 3,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context, _controller.text.trim());
          },
          child: const Text('Decline'),
        ),
      ],
    );
  }
}
