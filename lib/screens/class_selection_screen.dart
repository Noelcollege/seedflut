import 'package:flutter/material.dart';
import '../widgets/app_background.dart';
import 'class_chapters_screen.dart';

class ClassSelectionScreen extends StatelessWidget {
  static const String routeName = '/classes';

  const ClassSelectionScreen({super.key});

  // Mock grade data for Environmental Science
  final List<GradeInfo> grades = const [
    GradeInfo(
      id: 'env_11',
      name: 'Environmental Science',
      grade: 'Grade 11',
      teacher: 'Dr. Sarah Green',
      teacherAvatar: '🌱',
      difficulty: 'Medium',
      progress: 0.65,
      totalLessons: 20,
      completedLessons: 13,
      nextDeadline: 'Dec 15, 2024',
      color: Colors.green,
      icon: Icons.eco,
    ),
    GradeInfo(
      id: 'env_12',
      name: 'Environmental Science',
      grade: 'Grade 12',
      teacher: 'Prof. Michael Earth',
      teacherAvatar: '🌍',
      difficulty: 'Hard',
      progress: 0.40,
      totalLessons: 24,
      completedLessons: 10,
      nextDeadline: 'Dec 18, 2024',
      color: Colors.teal,
      icon: Icons.eco,
    ),
  ];

  void _goToChapters(BuildContext context, GradeInfo gradeInfo) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ClassChaptersScreen(
          className: '${gradeInfo.name} - ${gradeInfo.grade}',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Select Class')),
      body: AppBackground(
        imageAsset: 'assets/logo/app_icon.jpg',
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Environmental Science',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Text(
                  'Select your grade to continue learning',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 16,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.only(
                      bottom: 20,
                    ), // Fix bottom overflow
                    itemCount: grades.length,
                    itemBuilder: (context, index) {
                      final gradeInfo = grades[index];
                      return _GradeCard(
                        gradeInfo: gradeInfo,
                        onTap: () => _goToChapters(context, gradeInfo),
                      );
                    },
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

class _GradeCard extends StatelessWidget {
  final GradeInfo gradeInfo;
  final VoidCallback onTap;

  const _GradeCard({required this.gradeInfo, required this.onTap});

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
                      color: gradeInfo.color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      gradeInfo.icon,
                      color: gradeInfo.color,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          gradeInfo.name,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          gradeInfo.grade,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade600,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  _DifficultyBadge(difficulty: gradeInfo.difficulty),
                ],
              ),
              const SizedBox(height: 12),

              // Teacher info
              Row(
                children: [
                  Text(
                    gradeInfo.teacherAvatar,
                    style: const TextStyle(fontSize: 20),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    gradeInfo.teacher,
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Progress bar
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
                        '${gradeInfo.completedLessons}/${gradeInfo.totalLessons} lessons',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  LinearProgressIndicator(
                    value: gradeInfo.progress,
                    backgroundColor: Colors.grey.shade200,
                    valueColor: AlwaysStoppedAnimation<Color>(gradeInfo.color),
                    minHeight: 6,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${(gradeInfo.progress * 100).toInt()}% complete',
                    style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Deadline
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.orange.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.orange.shade200),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.schedule,
                      size: 14,
                      color: Colors.orange.shade700,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Next deadline: ${gradeInfo.nextDeadline}',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.orange.shade700,
                        fontWeight: FontWeight.w500,
                      ),
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
}

class _DifficultyBadge extends StatelessWidget {
  final String difficulty;

  const _DifficultyBadge({required this.difficulty});

  @override
  Widget build(BuildContext context) {
    Color color;
    switch (difficulty.toLowerCase()) {
      case 'easy':
        color = Colors.green;
        break;
      case 'medium':
        color = Colors.orange;
        break;
      case 'hard':
        color = Colors.red;
        break;
      default:
        color = Colors.grey;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(
        difficulty,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: color,
        ),
      ),
    );
  }
}

class GradeInfo {
  final String id;
  final String name;
  final String grade;
  final String teacher;
  final String teacherAvatar;
  final String difficulty;
  final double progress;
  final int totalLessons;
  final int completedLessons;
  final String nextDeadline;
  final Color color;
  final IconData icon;

  const GradeInfo({
    required this.id,
    required this.name,
    required this.grade,
    required this.teacher,
    required this.teacherAvatar,
    required this.difficulty,
    required this.progress,
    required this.totalLessons,
    required this.completedLessons,
    required this.nextDeadline,
    required this.color,
    required this.icon,
  });
}
