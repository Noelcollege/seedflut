import 'package:flutter/material.dart';
import '../widgets/app_background.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

class ClassChaptersScreen extends StatefulWidget {
  final String className;
  const ClassChaptersScreen({super.key, required this.className});

  @override
  State<ClassChaptersScreen> createState() => _ClassChaptersScreenState();
}

class _ClassChaptersScreenState extends State<ClassChaptersScreen> {
  String? _selectedChapter;
  List<_ChapterData> _chaptersData = [];
  bool _isLoading = true;
  String? _error;

  Future<void> _loadChapters() async {
    try {
      final String jsonStr = await rootBundle.loadString(
        'assets/data/environment_chapters.json',
      );
      final dynamic data = json.decode(jsonStr);

      // ✅ handle both list and object JSON
      final List<dynamic> list = data is List
          ? data
          : (data['chapters'] as List<dynamic>);

      setState(() {
        _chaptersData = list
            .map(
              (e) => _ChapterData(
                title: (e as Map<String, dynamic>)['title'] as String,
                topics: List<String>.from(e['topics'] as List<dynamic>),
              ),
            )
            .toList();
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = "Failed to load chapters: $e";
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _loadChapters();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('${widget.className} - Chapters')),
      body: AppBackground(
        imageAsset: 'assets/logo/app_icon.jpg',
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _error != null
                ? Center(
                    child: Text(
                      _error!,
                      style: const TextStyle(color: Colors.red),
                      textAlign: TextAlign.center,
                    ),
                  )
                : _chaptersData.isEmpty
                ? const Center(
                    child: Text(
                      "No chapters available",
                      style: TextStyle(color: Colors.white),
                    ),
                  )
                : SingleChildScrollView(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Environmental Science - Select Chapter',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Choose a chapter to view topics',
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.8),
                            fontSize: 14,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        // Chapter Selection
                        Card(
                          elevation: 6,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Available Chapters',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Wrap(
                                  spacing: 12,
                                  runSpacing: 12,
                                  children: _chaptersData.map((c) {
                                    final bool selected =
                                        c.title == _selectedChapter;
                                    return ChoiceChip(
                                      label: Text(c.title),
                                      selected: selected,
                                      onSelected: (_) => setState(
                                        () => _selectedChapter = c.title,
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ],
                            ),
                          ),
                        ),
                        // Topics Section
                        if (_selectedChapter != null) ...[
                          const SizedBox(height: 20),
                          Card(
                            elevation: 6,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Topics in $_selectedChapter',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 12),
                                  Builder(
                                    builder: (context) {
                                      final selected = _chaptersData.firstWhere(
                                        (c) => c.title == _selectedChapter,
                                        orElse: () =>
                                            _ChapterData(title: "", topics: []),
                                      );

                                      return ListView.builder(
                                        shrinkWrap: true,
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        padding: const EdgeInsets.only(
                                          bottom: 12,
                                        ),
                                        itemCount: selected.topics.length,
                                        itemBuilder: (context, index) {
                                          final topic = selected.topics[index];
                                          return Card(
                                            margin: const EdgeInsets.only(
                                              bottom: 8,
                                            ),
                                            elevation: 2,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                            child: ListTile(
                                              leading: Container(
                                                width: 8,
                                                height: 8,
                                                decoration: const BoxDecoration(
                                                  color: Colors.green,
                                                  shape: BoxShape.circle,
                                                ),
                                              ),
                                              title: Text(
                                                topic,
                                                style: const TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              trailing: const Icon(
                                                Icons.arrow_forward_ios,
                                                size: 14,
                                                color: Colors.grey,
                                              ),
                                              onTap: () {
                                                // TODO: Navigate to topic content
                                              },
                                            ),
                                          );
                                        },
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}

class _ChapterData {
  final String title;
  final List<String> topics;
  const _ChapterData({required this.title, required this.topics});
}
