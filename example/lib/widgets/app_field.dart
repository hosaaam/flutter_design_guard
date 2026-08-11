import 'package:flutter/material.dart';

/// Example design-system wrapper for Flutter's native text inputs.
class AppField extends StatelessWidget {
  const AppField({required this.label, super.key}) : isFormField = false;

  const AppField.form({required this.label, super.key}) : isFormField = true;

  final String label;
  final bool isFormField;

  @override
  Widget build(BuildContext context) {
    final decoration = InputDecoration(labelText: label);

    if (isFormField) {
      return TextFormField(decoration: decoration);
    }

    return TextField(decoration: decoration);
  }
}
