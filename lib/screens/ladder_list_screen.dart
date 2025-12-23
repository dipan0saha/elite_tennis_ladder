import 'package:flutter/material.dart';
import '../models/ladder.dart';
import '../services/auth_service.dart';
import '../services/ladder_service.dart';
import '../widgets/empty_state.dart';
import '../widgets/error_state.dart';
import '../widgets/loading_state.dart';
import 'ladder_detail_screen.dart';
import 'create_ladder_screen.dart';

/// Screen displaying list of tennis ladders
class LadderListScreen extends StatefulWidget {
  const LadderListScreen({super.key});

  @override
  State<LadderListScreen> createState() => _LadderListScreenState();
}

class _LadderListScreenState extends State<LadderListScreen> with SingleTickerProviderStateMixin {
  final LadderService _ladderService = LadderService();
  final AuthService _authService = AuthService();
  
  late TabController _tabController;
  List<Ladder> _publicLadders = [];
  List<Ladder> _myLadders = [];
  List<Ladder> _joinedLadders = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadLadders();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadLadders() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final userId = _authService.currentUser?.id;
      
      final results = await Future.wait([
        _ladderService.getPublicLadders(),
        if (userId != null) _ladderService.getMyLadders(userId),
        if (userId != null) _ladderService.getJoinedLadders(userId),
      ]);

      if (mounted) {
        setState(() {
          _publicLadders = results[0] as List<Ladder>;
          if (userId != null && results.length > 1) {
            _myLadders = results[1] as List<Ladder>;
          }
          if (userId != null && results.length > 2) {
            _joinedLadders = results[2] as List<Ladder>;
          }
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = 'Failed to load ladders: $e';
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tennis Ladders'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Public', icon: Icon(Icons.public)),
            Tab(text: 'My Ladders', icon: Icon(Icons.admin_panel_settings)),
            Tab(text: 'Joined', icon: Icon(Icons.group)),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: 'Create Ladder',
            onPressed: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const CreateLadderScreen(),
                ),
              );
              if (result == true) {
                _loadLadders();
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh',
            onPressed: _loadLadders,
          ),
        ],
      ),
      body: _isLoading
          ? const LoadingState(message: 'Loading ladders...')
          : _errorMessage != null
              ? ErrorState(
                  message: _errorMessage!,
                  onRetry: _loadLadders,
                )
              : TabBarView(
                  controller: _tabController,
                  children: [
                    _buildLadderList(_publicLadders, 'No public ladders available'),
                    _buildLadderList(_myLadders, 'You haven\'t created any ladders yet'),
                    _buildLadderList(_joinedLadders, 'You haven\'t joined any ladders yet'),
                  ],
                ),
    );
  }

  Widget _buildLadderList(List<Ladder> ladders, String emptyMessage) {
    if (ladders.isEmpty) {
      return EmptyState(
        icon: Icons.sports_tennis,
        title: 'No Ladders',
        message: emptyMessage,
        action: _tabController.index == 1
            ? ElevatedButton.icon(
                onPressed: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const CreateLadderScreen(),
                    ),
                  );
                  if (result == true) {
                    _loadLadders();
                  }
                },
                icon: const Icon(Icons.add),
                label: const Text('Create Ladder'),
              )
            : null,
      );
    }

    return RefreshIndicator(
      onRefresh: _loadLadders,
      child: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: ladders.length,
        itemBuilder: (context, index) {
          final ladder = ladders[index];
          return _buildLadderCard(ladder);
        },
      ),
    );
  }

  Widget _buildLadderCard(Ladder ladder) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12.0),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => LadderDetailScreen(ladderId: ladder.id),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      ladder.name,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                  _buildVisibilityChip(ladder.visibility),
                ],
              ),
              if (ladder.description != null) ...[
                const SizedBox(height: 8),
                Text(
                  ladder.description!,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
              const SizedBox(height: 12),
              Wrap(
                spacing: 16.0,
                runSpacing: 8.0,
                children: [
                  _buildInfoChip(
                    Icons.emoji_events,
                    'Scoring: ${_formatScoringSystem(ladder.scoringSystem)}',
                  ),
                  _buildInfoChip(
                    Icons.people,
                    'Max: ${ladder.maxPlayers}',
                  ),
                  _buildInfoChip(
                    Icons.trending_up,
                    'Range: ${ladder.challengeRange}',
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildVisibilityChip(String visibility) {
    IconData icon;
    Color color;
    
    switch (visibility) {
      case 'public':
        icon = Icons.public;
        color = Colors.green;
        break;
      case 'private':
        icon = Icons.lock;
        color = Colors.orange;
        break;
      case 'invite_only':
        icon = Icons.mail;
        color = Colors.blue;
        break;
      default:
        icon = Icons.help;
        color = Colors.grey;
    }

    return Chip(
      avatar: Icon(icon, size: 16, color: color),
      label: Text(
        visibility.toUpperCase(),
        style: TextStyle(fontSize: 10, color: color),
      ),
      backgroundColor: color.withOpacity(0.1),
      padding: EdgeInsets.zero,
      visualDensity: VisualDensity.compact,
    );
  }

  Widget _buildInfoChip(IconData icon, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: Theme.of(context).colorScheme.primary),
        const SizedBox(width: 4),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
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
