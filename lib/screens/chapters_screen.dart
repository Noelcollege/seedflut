import 'package:flutter/material.dart';
import '../widgets/app_background.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

class ChaptersScreen extends StatelessWidget {
  static const String routeName = '/chapters';

  const ChaptersScreen({super.key});

  Future<List<ChapterInfo>> _loadChapters() async {
    final String jsonStr = await rootBundle.loadString(
      'assets/data/environment_chapters.json',
    );
    final List<dynamic> list = json.decode(jsonStr) as List<dynamic>;
    final List<Color> palette = [
      Colors.green,
      Colors.teal,
      Colors.orange,
      Colors.red,
      Colors.blue,
      Colors.purple,
      Colors.indigo,
      Colors.cyan,
    ];
    final List<IconData> icons = [
      Icons.menu_book,
      Icons.eco,
      Icons.public,
      Icons.health_and_safety,
      Icons.psychology,
      Icons.lightbulb,
      Icons.auto_graph,
      Icons.science,
    ];
    int i = 0;
    return list.map((e) {
      final Map<String, dynamic> m = e as Map<String, dynamic>;
      final idx = i++;
      return ChapterInfo(
        id: 'ch_${idx + 1}',
        title: m['title'] as String,
        description: '${(m['topics'] as List<dynamic>).length} topics',
        duration: 60,
        difficulty: 'Medium',
        isCompleted: false,
        progress: 0.0,
        resourceType: 'Reading',
        icon: icons[idx % icons.length],
        color: palette[idx % palette.length],
      );
    }).toList();
  }

  void _startChapter(BuildContext context, ChapterInfo chapter) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(chapter.icon, color: chapter.color),
            const SizedBox(width: 12),
            Expanded(
              child: Text(chapter.title, style: const TextStyle(fontSize: 18)),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(chapter.description),
            const SizedBox(height: 12),
            _ChapterDetailRow('Duration', '${chapter.duration} min'),
            _ChapterDetailRow('Difficulty', chapter.difficulty),
            _ChapterDetailRow('Type', chapter.resourceType),
            if (chapter.progress > 0) ...[
              const SizedBox(height: 8),
              Text(
                'Progress: ${(chapter.progress * 100).toInt()}%',
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(context);
              // TODO: Navigate to chapter content
            },
            child: Text(chapter.isCompleted ? 'Review' : 'Start'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Chapters')),
      body: AppBackground(
        imageAsset: 'assets/images/bg_generic.jpg',
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Environmental Science Chapters',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Complete chapters to advance your learning',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.8),
                      fontSize: 14,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 20),
                  FutureBuilder<List<ChapterInfo>>(
                    future: _loadChapters(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState != ConnectionState.done) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      final data = snapshot.data ?? const <ChapterInfo>[];
                      return ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        padding: EdgeInsets.zero,
                        itemCount: data.length,
                        itemBuilder: (context, index) {
                          final chapter = data[index];
                          return _ChapterCard(
                            chapter: chapter,
                            onTap: () => _startChapter(context, chapter),
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ChapterCard extends StatelessWidget {
  final ChapterInfo chapter;
  final VoidCallback onTap;

  const _ChapterCard({required this.chapter, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: chapter.color.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(chapter.icon, color: chapter.color, size: 24),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                chapter.title,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            if (chapter.isCompleted)
                              Container(
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color: Colors.green,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.check,
                                  color: Colors.white,
                                  size: 16,
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          chapter.description,
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey.shade600,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Progress bar
              if (chapter.progress > 0) ...[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Progress',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    Text(
                      '${(chapter.progress * 100).toInt()}%',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                LinearProgressIndicator(
                  value: chapter.progress,
                  backgroundColor: Colors.grey.shade200,
                  valueColor: AlwaysStoppedAnimation<Color>(chapter.color),
                  minHeight: 4,
                ),
                const SizedBox(height: 8),
              ],

              // Chapter details
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _ChapterBadge(
                      icon: Icons.schedule,
                      text: '${chapter.duration} min',
                      color: Colors.blue,
                    ),
                    const SizedBox(width: 8),
                    _ChapterBadge(
                      icon: _getDifficultyIcon(chapter.difficulty),
                      text: chapter.difficulty,
                      color: _getDifficultyColor(chapter.difficulty),
                    ),
                    const SizedBox(width: 8),
                    _ChapterBadge(
                      icon: chapter.icon,
                      text: chapter.resourceType,
                      color: chapter.color,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getDifficultyIcon(String difficulty) {
    switch (difficulty.toLowerCase()) {
      case 'easy':
        return Icons.trending_down;
      case 'medium':
        return Icons.trending_flat;
      case 'hard':
        return Icons.trending_up;
      default:
        return Icons.help_outline;
    }
  }

  Color _getDifficultyColor(String difficulty) {
    switch (difficulty.toLowerCase()) {
      case 'easy':
        return Colors.green;
      case 'medium':
        return Colors.orange;
      case 'hard':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}

class _ChapterBadge extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color color;

  const _ChapterBadge({
    required this.icon,
    required this.text,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

class _ChapterDetailRow extends StatelessWidget {
  final String label;
  final String value;

  const _ChapterDetailRow(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
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

class ChapterInfo {
  final String id;
  final String title;
  final String description;
  final int duration;
  final String difficulty;
  final bool isCompleted;
  final double progress;
  final String resourceType;
  final IconData icon;
  final Color color;

  const ChapterInfo({
    required this.id,
    required this.title,
    required this.description,
    required this.duration,
    required this.difficulty,
    required this.isCompleted,
    required this.progress,
    required this.resourceType,
    required this.icon,
    required this.color,
  });
}
