import 'package:flutter/material.dart';
import '../widgets/app_background.dart';

class LeaderboardScreen extends StatelessWidget {
  static const String routeName = '/leaderboard';

  const LeaderboardScreen({super.key});

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
                    child: ListView(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      children: const [
                        _LeaderboardTile(rank: 1, name: 'You', score: 8420),
                        _LeaderboardTile(rank: 2, name: 'Alex', score: 7990),
                        _LeaderboardTile(rank: 3, name: 'Sam', score: 7560),
                        _LeaderboardTile(rank: 4, name: 'Jordan', score: 7330),
                        _LeaderboardTile(rank: 5, name: 'Riley', score: 7015),
                      ],
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
  final int rank;
  final String name;
  final int score;
  const _LeaderboardTile({
    required this.rank,
    required this.name,
    required this.score,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
      visualDensity: const VisualDensity(vertical: -2),
      leading: CircleAvatar(
        radius: 14,
        backgroundColor: Colors.indigo.shade50,
        child: Text(
          rank.toString(),
          style: const TextStyle(color: Colors.indigo, fontSize: 12),
        ),
      ),
      title: Text(
        name,
        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
      ),
      trailing: Text(score.toString(), style: const TextStyle(fontSize: 13)),
    );
  }
}
