import 'package:flutter/material.dart';
import '../widgets/app_background.dart';

class LeaderboardScreen extends StatelessWidget {
  static const String routeName = '/leaderboard';

  const LeaderboardScreen({super.key});

  // Mock leaderboard data
  final List<LeaderboardEntry> leaderboardData = const [
    LeaderboardEntry(
      rank: 1,
      name: 'Alex Johnson',
      score: 12450,
      avatar: '👨‍💻',
      rankChange: 2,
      lastActive: '2h ago',
      isCurrentUser: true,
    ),
    LeaderboardEntry(
      rank: 2,
      name: 'Sarah Chen',
      score: 11890,
      avatar: '👩‍🎓',
      rankChange: -1,
      lastActive: '1h ago',
      isCurrentUser: false,
    ),
    LeaderboardEntry(
      rank: 3,
      name: 'Mike Rodriguez',
      score: 11230,
      avatar: '👨‍🔬',
      rankChange: 1,
      lastActive: '3h ago',
      isCurrentUser: false,
    ),
    LeaderboardEntry(
      rank: 4,
      name: 'Emma Wilson',
      score: 10890,
      avatar: '👩‍💼',
      rankChange: -2,
      lastActive: '5h ago',
      isCurrentUser: false,
    ),
    LeaderboardEntry(
      rank: 5,
      name: 'David Kim',
      score: 10240,
      avatar: '👨‍🎨',
      rankChange: 0,
      lastActive: '30m ago',
      isCurrentUser: false,
    ),
    LeaderboardEntry(
      rank: 6,
      name: 'Lisa Thompson',
      score: 9870,
      avatar: '👩‍🏫',
      rankChange: 3,
      lastActive: '4h ago',
      isCurrentUser: false,
    ),
    LeaderboardEntry(
      rank: 7,
      name: 'James Brown',
      score: 9450,
      avatar: '👨‍💻',
      rankChange: -1,
      lastActive: '6h ago',
      isCurrentUser: false,
    ),
    LeaderboardEntry(
      rank: 8,
      name: 'Anna Garcia',
      score: 9120,
      avatar: '👩‍🔬',
      rankChange: 2,
      lastActive: '1d ago',
      isCurrentUser: false,
    ),
  ];

  void _showUserProfile(BuildContext context, LeaderboardEntry entry) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Text(entry.avatar, style: const TextStyle(fontSize: 32)),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    entry.name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Rank #${entry.rank}',
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                  ),
                ],
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _ProfileStatRow('Score', '${entry.score.toString()} XP'),
            _ProfileStatRow('Last Active', entry.lastActive),
            _ProfileStatRow(
              'Rank Change',
              _getRankChangeText(entry.rankChange),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(context);
              // TODO: Navigate to user's detailed profile
            },
            child: const Text('View Profile'),
          ),
        ],
      ),
    );
  }

  String _getRankChangeText(int change) {
    if (change > 0) {
      return '↑ $change';
    } else if (change < 0) {
      return '↓ ${change.abs()}';
    } else {
      return '→ No change';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Leaderboard')),
      body: AppBackground(
        imageAsset: 'assets/logo/app_icon.jpg',
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: const [
                    Icon(Icons.leaderboard_outlined, color: Colors.white),
                    SizedBox(width: 8),
                    Text(
                      'Leaderboard',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: Card(
                    elevation: 8,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: ListView.builder(
                      padding: const EdgeInsets.fromLTRB(
                        8,
                        8,
                        8,
                        20,
                      ), // Fix bottom overflow
                      itemCount: leaderboardData.length,
                      itemBuilder: (context, index) {
                        final entry = leaderboardData[index];
                        return _LeaderboardTile(
                          entry: entry,
                          onTap: () => _showUserProfile(context, entry),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _LeaderboardTile extends StatelessWidget {
  final LeaderboardEntry entry;
  final VoidCallback onTap;

  const _LeaderboardTile({required this.entry, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: entry.isCurrentUser
              ? Colors.indigo.shade50
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: entry.isCurrentUser
              ? Border.all(color: Colors.indigo.shade200)
              : null,
        ),
        child: Row(
          children: [
            // Rank
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: _getRankColor(entry.rank),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  entry.rank.toString(),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),

            // Avatar
            Text(entry.avatar, style: const TextStyle(fontSize: 24)),
            const SizedBox(width: 12),

            // Name and details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        entry.name,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                          color: entry.isCurrentUser
                              ? Colors.indigo.shade700
                              : Colors.black87,
                        ),
                      ),
                      if (entry.isCurrentUser) ...[
                        const SizedBox(width: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.indigo.shade100,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            'You',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: Colors.indigo.shade700,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      Text(
                        entry.lastActive,
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      const SizedBox(width: 8),
                      _buildRankChange(entry.rankChange),
                    ],
                  ),
                ],
              ),
            ),

            // Score
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${entry.score.toString()} XP',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Rank #${entry.rank}',
                  style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _getRankColor(int rank) {
    switch (rank) {
      case 1:
        return Colors.amber.shade600;
      case 2:
        return Colors.grey.shade400;
      case 3:
        return Colors.orange.shade600;
      default:
        return Colors.indigo.shade600;
    }
  }

  Widget _buildRankChange(int change) {
    if (change > 0) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.keyboard_arrow_up, color: Colors.green, size: 16),
          Text(
            change.toString(),
            style: const TextStyle(
              fontSize: 11,
              color: Colors.green,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      );
    } else if (change < 0) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.keyboard_arrow_down, color: Colors.red, size: 16),
          Text(
            change.abs().toString(),
            style: const TextStyle(
              fontSize: 11,
              color: Colors.red,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      );
    } else {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.remove, color: Colors.grey, size: 16),
          Text(
            '0',
            style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
          ),
        ],
      );
    }
  }
}

class _ProfileStatRow extends StatelessWidget {
  final String label;
  final String value;

  const _ProfileStatRow(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
          ),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
          ),
        ],
      ),
    );
  }
}

class LeaderboardEntry {
  final int rank;
  final String name;
  final int score;
  final String avatar;
  final int rankChange;
  final String lastActive;
  final bool isCurrentUser;

  const LeaderboardEntry({
    required this.rank,
    required this.name,
    required this.score,
    required this.avatar,
    required this.rankChange,
    required this.lastActive,
    required this.isCurrentUser,
  });
}
