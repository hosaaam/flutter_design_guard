import 'package:flutter/material.dart';

import 'widgets/app_field.dart';

void main() {
  runApp(const ExampleApp());
}

class ExampleApp extends StatelessWidget {
  const ExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: ExampleScreen());
  }
}

class ExampleScreen extends StatelessWidget {
  const ExampleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Flutter Design Guard')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Reported by avoid_native_text_field when used directly:
            // TextField();
            // TextFormField();
            const AppField(label: 'Name'),
            const SizedBox(height: 16),
            const AppField.form(label: 'Email'),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                // Colors.blue and Color(0xFF...) would be reported by
                // avoid_hardcoded_color. Theme colors are approved.
                color: colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                'Use theme colors instead of hardcoded colors.',
                style: TextStyle(color: colorScheme.onPrimaryContainer),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
