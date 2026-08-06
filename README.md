# Flutter Design Guard

A Dart Analysis Server plugin that helps enforce your Flutter design system by reporting the usage of forbidden Flutter widgets and suggesting your project's custom replacements.

## Features

- ✅ Detects direct usage of `TextField`
- ✅ Detects direct usage of `TextFormField`
- ✅ Supports configurable replacement widgets
- ✅ Supports allowing implementation files
- ✅ Runs automatically during `dart analyze` and `flutter analyze`

## Requirements

- Flutter 3.38.0 or later
- Dart 3.10.0 or later

## Installation

Flutter Design Guard uses the official Dart Analyzer Plugin system.

Enable the plugin in your `analysis_options.yaml`:

```yaml
plugins:
  flutter_design_guard: ^0.1.1
```

No changes to `pubspec.yaml` are required.

## Configuration

Create a file named:

```text
flutter_design_guard.yaml
```

Example:

```yaml
rules:
  avoid_native_text_field:
    replacement: CustomTextField
    implementation_paths:
      - lib/core/widgets/custom_text_field.dart
```

### replacement

The widget that should be used instead of Flutter's native text fields.

### implementation_paths

Project-relative paths where native `TextField` and `TextFormField` usage is allowed. This is typically the implementation file of your custom wrapper widget.

## Example

### ❌ Bad

```dart
TextField();

TextFormField();
```

### ✅ Good

```dart
CustomTextField(
  controller: controller,
);
```

## Diagnostic

Using `TextField` or `TextFormField` produces:

```text
warning • Do not use TextField directly. Use CustomTextField instead. • avoid_native_text_field
```

## Supported Commands

The plugin runs automatically with:

```bash
flutter analyze
```

or

```bash
dart analyze
```

## License

MIT