import 'package:flutter/material.dart';
import '../widgets/app_background.dart';
import 'class_chapters_screen.dart';

class ClassSelectionScreen extends StatelessWidget {
  static const String routeName = '/classes';

  const ClassSelectionScreen({super.key});

  void _goToChapters(BuildContext context, String className) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ClassChaptersScreen(className: className),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Select Class')),
      body: AppBackground(
        imageAsset: 'assets/logo/app_icon.jpg',
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Card(
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      'Choose your class',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 16),
                    FilledButton(
                      onPressed: () => _goToChapters(context, 'Class 11'),
                      child: const Text('Class 11'),
                    ),
                    const SizedBox(height: 12),
                    FilledButton.tonal(
                      onPressed: () => _goToChapters(context, 'Class 12'),
                      child: const Text('Class 12'),
                    ),
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
