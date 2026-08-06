# Flutter Design Guard

A Dart analyzer plugin that helps Flutter teams enforce design-system
components by preventing direct use of native text fields.

The first stable release provides the `avoid_native_text_field` diagnostic,
which detects direct usage of Flutter's `TextField` and `TextFormField`.

## Requirements

- Dart SDK 3.11 or newer.
- A Flutter project using the modern Dart analyzer plugin system.
- The plugin must be configured in the root `analysis_options.yaml` file.

## Installation

Add the plugin to the top-level `plugins` section of your project's root
`analysis_options.yaml` file:

```yaml
plugins:
  flutter_design_guard:
    version: ^0.1.0
    diagnostics:
      avoid_native_text_field: true
```

Do not place `plugins` under the `analyzer` section.

You don't need to add `flutter_design_guard` to your application's
`pubspec.yaml`. Analyzer plugins are resolved separately by the Dart Analysis
Server.

After adding or changing the plugin configuration, restart the Dart Analysis
Server.

### Visual Studio Code

Open the command palette and run:

```text
Dart: Restart Analysis Server
```

### Android Studio or IntelliJ IDEA

Use:

```text
File > Invalidate Caches / Restart
```

You can also restart the IDE.

## Usage

After enabling the diagnostic, run:

```bash
flutter analyze
```

You can also use:

```bash
dart analyze
```

The diagnostic also appears directly in supported editors.

## Available diagnostics

### `avoid_native_text_field`

Prevents direct usage of Flutter's native `TextField` and `TextFormField`
widgets.

This helps projects consistently use their own design-system field component.

#### Invalid

```dart
import 'package:flutter/material.dart';

class LoginForm extends StatelessWidget {
  const LoginForm({super.key});

  @override
  Widget build(BuildContext context) {
    return const TextField();
  }
}
```

```dart
import 'package:flutter/material.dart';

class ProfileForm extends StatelessWidget {
  const ProfileForm({super.key});

  @override
  Widget build(BuildContext context) {
    return const TextFormField();
  }
}
```

The analyzer reports:

```text
Do not use TextField directly. Use your design-system text field instead.
```

#### Valid

Use the text-field component provided by your application or design system:

```dart
import 'package:flutter/material.dart';

class AppTextField extends StatelessWidget {
  const AppTextField({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox();
  }
}
```

```dart
class LoginForm extends StatelessWidget {
  const LoginForm({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppTextField();
  }
}
```

## Disabling the diagnostic

To disable the rule while keeping the plugin installed:

```yaml
plugins:
  flutter_design_guard:
    version: ^0.1.0
    diagnostics:
      avoid_native_text_field: false
```

## Suppressing a diagnostic

Suppress one occurrence:

```dart
// ignore: flutter_design_guard/avoid_native_text_field
final field = TextField();
```

Suppress the diagnostic for an entire file:

```dart
// ignore_for_file: flutter_design_guard/avoid_native_text_field
```

Suppress