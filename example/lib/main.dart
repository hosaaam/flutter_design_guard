import 'package:flutter/material.dart';

void main() {
  runApp(const GuardExampleApp());
}

class GuardExampleApp extends StatelessWidget {
  const GuardExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Column(
          children: [
            // expect_lint: avoid_native_text_field
            const TextField(),

            // expect_lint: avoid_native_text_field
            TextFormField(),

            const CustomTextField(),
          ],
        ),
      ),
    );
  }
}

/// Represents the application's approved design-system text field.
class CustomTextField extends StatelessWidget {
  const CustomTextField({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox();
  }
}
