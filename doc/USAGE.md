# Flutter Design Guard Usage

`flutter_design_guard` provides custom lint rules that help Flutter teams
enforce their design system directly inside the IDE and CI.

The package currently prevents direct usage of Flutter's native
`TextField` and `TextFormField` widgets and recommends using
`CustomTextField` instead.

## Installation

Add `custom_lint` and `flutter_design_guard` to your application's
`dev_dependencies`:

```yaml
dev_dependencies:
  custom_lint: ^0.8.1
  flutter_design_guard: ^0.0.1
```

Then install the dependencies:

```bash
flutter pub get
```

`flutter_design_guard` is a development tool. You do not need to import it
inside your Dart files.

## Enable the plugin

Add `custom_lint` to your application's `analysis_options.yaml`:

```yaml
analyzer:
  plugins:
    - custom_lint
```

All installed Flutter Design Guard rules are enabled by default.

## Enable rules explicitly

For better control, disable automatic rule activation and explicitly list
the rules used by your project:

```yaml
analyzer:
  plugins:
    - custom_lint

custom_lint:
  enable_all_lint_rules: false
  rules:
    - avoid_native_text_field
```

## Available rules

### `avoid_native_text_field`

Reports a warning when Flutter's native `TextField` or `TextFormField`
is used directly.

Incorrect:

```dart
import 'package:flutter/material.dart';

class LoginForm extends StatelessWidget {
  const LoginForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(),
        TextFormField(),
      ],
    );
  }
}
```

The analyzer reports:

```text
Do not use TextField or TextFormField directly.
Use CustomTextField instead.

avoid_native_text_field • WARNING
```

Correct:

```dart
class LoginForm extends StatelessWidget {
  const LoginForm({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        CustomTextField(),
        CustomTextField(),
      ],
    );
  }
}
```

## IDE support

After installing the package, restart the Dart Analysis Server if the warning
does not immediately appear.

### Visual Studio Code

Open the command palette and run:

```text
Dart: Restart Analysis Server
```

### Android Studio or IntelliJ IDEA

Use:

```text
File → Invalidate Caches / Restart
```

## Command-line usage

Run Flutter Design Guard from the root of your Flutter application:

```bash
dart run custom_lint
```

Example output:

```text
lib/login_form.dart:16:13
Do not use TextField or TextFormField directly.
Use CustomTextField instead.
avoid_native_text_field • WARNING
```

Run the standard analyzer separately:

```bash
dart analyze
dart run custom_lint
```

## CI usage

Flutter Design Guard can be added to a continuous integration workflow.

Example GitHub Actions steps:

```yaml
- name: Install dependencies
  run: flutter pub get

- name: Check formatting
  run: dart format --output=none --set-exit-if-changed .

- name: Run Dart analyzer
  run: dart analyze

- name: Run Flutter Design Guard
  run: dart run custom_lint
```

The CI job fails when lint violations are found.

## Ignoring a warning

Ignore a single violation:

```dart
// ignore: avoid_native_text_field
final field = TextField();
```

Ignore the rule for an entire file:

```dart
// ignore_for_file: avoid_native_text_field
```

Ignoring rules should be limited to exceptional cases, such as implementing
the approved design-system component itself.

## Disable the rule

Disable the rule for the entire project:

```yaml
analyzer:
  plugins:
    - custom_lint

custom_lint:
  rules:
    - avoid_native_text_field: false
```

## Troubleshooting

### No warning appears in the IDE

Verify that both packages are under `dev_dependencies`:

```yaml
dev_dependencies:
  custom_lint: ^0.8.1
  flutter_design_guard: ^0.0.1
```

Verify that the plugin is enabled:

```yaml
analyzer:
  plugins:
    - custom_lint
```

Then run:

```bash
flutter pub get
dart run custom_lint
```

Restart the Dart Analysis Server afterward.

### `dart analyze` reports no custom lint issues

Flutter Design Guard rules are executed through `custom_lint`.

Run:

```bash
dart run custom_lint
```

in addition to:

```bash
dart analyze
```

## Roadmap

Planned rules include:

- Preventing direct use of native Flutter buttons.
- Preventing hardcoded colors outside theme definitions.
- Enforcing application typography.
- Enforcing design-system spacing and radius tokens.
- Preventing direct use of native dialogs and snackbars.
- Configurable widget replacements and excluded paths.