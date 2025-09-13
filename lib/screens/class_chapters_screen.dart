import 'package:flutter/material.dart';
import '../widgets/app_background.dart';

class ClassChaptersScreen extends StatefulWidget {
  final String className;
  const ClassChaptersScreen({super.key, required this.className});

  @override
  State<ClassChaptersScreen> createState() => _ClassChaptersScreenState();
}

class _ClassChaptersScreenState extends State<ClassChaptersScreen> {
  String? _selectedChapter;

  List<String> get _chapters => const ['Chapter 1', 'Chapter 2'];
  List<String> get _topicsForEnvironment => const [
    'What is Environment?',
    'Components of Ecosystem',
    'Food Chains and Webs',
    'Biogeochemical Cycles',
    'Human Impact on Environment',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('${widget.className} - Chapters')),
      body: AppBackground(
        imageAsset: 'assets/logo/app_icon.jpg',
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 900),
            child: Card(
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.menu_book_outlined),
                        const SizedBox(width: 8),
                        Text(
                          '${widget.className} - Select Chapter',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: _chapters.map((c) {
                        final bool selected = c == _selectedChapter;
                        return ChoiceChip(
                          label: Text(c),
                          selected: selected,
                          onSelected: (_) =>
                              setState(() => _selectedChapter = c),
                        );
                      }).toList(),
                    ),
                    if (_selectedChapter != null) ...[
                      const SizedBox(height: 20),
                      const Text(
                        'Topics: Environment',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 8),
                      ..._topicsForEnvironment.map(
                        (t) => ListTile(
                          leading: const Icon(Icons.circle, size: 10),
                          title: Text(t),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
