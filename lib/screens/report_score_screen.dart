import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../services/match_service.dart';
import '../services/challenge_service.dart';

/// Screen for reporting match scores
class ReportScoreScreen extends StatefulWidget {
  final String ladderId;
  final String challengeId;
  final String player1Id;
  final String player2Id;
  final String player1Name;
  final String player2Name;

  const ReportScoreScreen({
    super.key,
    required this.ladderId,
    required this.challengeId,
    required this.player1Id,
    required this.player2Id,
    required this.player1Name,
    required this.player2Name,
  });

  @override
  State<ReportScoreScreen> createState() => _ReportScoreScreenState();
}

class _ReportScoreScreenState extends State<ReportScoreScreen> {
  final _formKey = GlobalKey<FormState>();
  final MatchService _matchService = MatchService();
  final ChallengeService _challengeService = ChallengeService();
  
  final TextEditingController _player1Set1Controller = TextEditingController();
  final TextEditingController _player2Set1Controller = TextEditingController();
  final TextEditingController _player1Set2Controller = TextEditingController();
  final TextEditingController _player2Set2Controller = TextEditingController();
  final TextEditingController _player1Set3Controller = TextEditingController();
  final TextEditingController _player2Set3Controller = TextEditingController();
  
  bool _isLoading = false;
  bool _requireSet3 = false;

  @override
  void dispose() {
    _player1Set1Controller.dispose();
    _player2Set1Controller.dispose();
    _player1Set2Controller.dispose();
    _player2Set2Controller.dispose();
    _player1Set3Controller.dispose();
    _player2Set3Controller.dispose();
    super.dispose();
  }

  bool _validateScores() {
    // Validate set 1 and 2 are filled
    if (_player1Set1Controller.text.isEmpty || _player2Set1Controller.text.isEmpty ||
        _player1Set2Controller.text.isEmpty || _player2Set2Controller.text.isEmpty) {
      return false;
    }

    final p1s1 = int.tryParse(_player1Set1Controller.text) ?? -1;
    final p2s1 = int.tryParse(_player2Set1Controller.text) ?? -1;
    final p1s2 = int.tryParse(_player1Set2Controller.text) ?? -1;
    final p2s2 = int.tryParse(_player2Set2Controller.text) ?? -1;

    if (p1s1 < 0 || p2s1 < 0 || p1s2 < 0 || p2s2 < 0) {
      return false;
    }

    // Check if we need set 3 (if sets are split 1-1)
    final player1Sets = (p1s1 > p2s1 ? 1 : 0) + (p1s2 > p2s2 ? 1 : 0);
    final player2Sets = (p2s1 > p1s1 ? 1 : 0) + (p2s2 > p1s2 ? 1 : 0);

    if (player1Sets == 1 && player2Sets == 1) {
      setState(() => _requireSet3 = true);
      if (_player1Set3Controller.text.isEmpty || _player2Set3Controller.text.isEmpty) {
        return false;
      }
    }

    return true;
  }

  Future<void> _submitScore() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (!_validateScores()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter valid scores'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      // Create match with scores
      final match = await _matchService.createMatch(
        ladderId: widget.ladderId,
        challengeId: widget.challengeId,
        player1Id: widget.player1Id,
        player2Id: widget.player2Id,
      );

      // Report the score
      await _matchService.reportScore(
        matchId: match.id,
        player1Set1: int.parse(_player1Set1Controller.text),
        player2Set1: int.parse(_player2Set1Controller.text),
        player1Set2: int.parse(_player1Set2Controller.text),
        player2Set2: int.parse(_player2Set2Controller.text),
        player1Set3: _player1Set3Controller.text.isNotEmpty 
            ? int.parse(_player1Set3Controller.text) 
            : null,
        player2Set3: _player2Set3Controller.text.isNotEmpty 
            ? int.parse(_player2Set3Controller.text) 
            : null,
        reporterId: widget.player1Id, // Assuming reporter is player1
      );

      // Mark challenge as completed
      await _challengeService.completeChallenge(widget.challengeId);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Score reported successfully!'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context, true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to report score: $e'),
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
        title: const Text('Report Score'),
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
                child: Column(
                  children: [
                    Text(
                      'Match',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            color: Theme.of(context).colorScheme.onPrimaryContainer,
                          ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${widget.player1Name} vs ${widget.player2Name}',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: Theme.of(context).colorScheme.onPrimaryContainer,
                          ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Enter Scores',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            _buildSetScoreRow('Set 1', _player1Set1Controller, _player2Set1Controller),
            const SizedBox(height: 12),
            _buildSetScoreRow('Set 2', _player1Set2Controller, _player2Set2Controller),
            if (_requireSet3) ...[
              const SizedBox(height: 12),
              _buildSetScoreRow('Set 3', _player1Set3Controller, _player2Set3Controller),
            ],
            const SizedBox(height: 24),
            Card(
              color: Colors.blue.shade50,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  children: [
                    const Icon(Icons.info_outline, color: Colors.blue),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Enter the number of games won in each set. If sets are tied 1-1, you\'ll need to enter Set 3.',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: _isLoading ? null : _submitScore,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(16.0),
              ),
              child: _isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Submit Score'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSetScoreRow(String setLabel, TextEditingController player1Controller, TextEditingController player2Controller) {
    return Row(
      children: [
        SizedBox(
          width: 60,
          child: Text(
            setLabel,
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.player1Name,
                style: Theme.of(context).textTheme.bodySmall,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              TextFormField(
                controller: player1Controller,
                decoration: const InputDecoration(
                  hintText: '0',
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Required';
                  }
                  final score = int.tryParse(value);
                  if (score == null || score < 0 || score > 7) {
                    return 'Invalid';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.player2Name,
                style: Theme.of(context).textTheme.bodySmall,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              TextFormField(
                controller: player2Controller,
                decoration: const InputDecoration(
                  hintText: '0',
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Required';
                  }
                  final score = int.tryParse(value);
                  if (score == null || score < 0 || score > 7) {
                    return 'Invalid';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
