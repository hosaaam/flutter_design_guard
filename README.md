# Flutter Design Guard

Analyzer plugin for enforcing Flutter design-system components directly in the
IDE, `dart analyze`, `flutter analyze`, and CI.

The first rule prevents direct usage of Flutter Material `TextField` and
`TextFormField`, and recommends the project’s configured replacement widget.

## Features

- Detects Flutter Material `TextField` and `TextFormField`.
- Uses semantic analysis to avoid false positives from local classes.
- Supports a configurable replacement widget.
- Supports allowed implementation files.
- Allows native fields inside the replacement class.
- Has no runtime or production-bundle impact.

## Setup

Enable the plugin in the consuming project’s `analysis_options.yaml`:

```yaml
include: package:flutter_lints/flutter.yaml

plugins:
  flutter_design_guard:
    path: ../flutter_design_guard
    diagnostics:
      avoid_native_text_field: true
```

Restart the Dart Analysis Server after changing the plugin configuration.

## Configuration

Create `flutter_design_guard.yaml` next to the consuming project’s
`pubspec.yaml`:

```yaml
rules:
  avoid_native_text_field:
    replacement: AppField
    implementation_paths:
      - lib/core/widgets/app_field.dart
      - lib/core/widgets/text_field_helper.dart
```

| Option                 | Description                                          | Default           |
|------------------------|------------------------------------------------------|-------------------|
| `replacement`          | Widget developers should use instead.                | `CustomTextField` |
| `implementation_paths` | Package-relative files allowed to use native fields. | `[]`              |

Invalid or missing configuration falls back to safe defaults.

## Usage

This produces analyzer warnings:

```dart
const TextField
();const TextFormField
();
```

Example diagnostic:

```text
Do not use TextField directly. Use AppField instead.
```

Use the configured design-system widget:

```dart
const AppField
();
```

## Allowed usages

Native text fields are allowed inside the configured replacement class:

```dart
class AppField {
  const AppField();

  Object build() {
    return const TextField();
  }
}
```

They are also allowed inside files listed in `implementation_paths`.

A local class with the same name does not produce a false warning:

```dart
class TextField {
  const TextField();
}

void build() {
  const TextField();
}
```

## Ignoring a diagnostic

For exceptional cases:

```dart
// ignore: avoid_native_text_field
const field = TextField();
```

For an entire file:

```dart
// ignore_for_file: avoid_native_text_field
```

Prefer `implementation_paths` for design-system implementation files.

## Commands

```bash
dart test
dart analyze
```

For a consuming Flutter project:

```bash
flutter analyze
```

No separate lint command is required.

## Available rules

### `avoid_native_text_field`

Prevents direct usage of Flutter Material:

- `TextField`
- `TextFormField`

## Roadmap

Future rules may cover buttons, dialogs, colors, typography, spacing, icons,
checkboxes, switches, and other design-system components.

## License

Flutter Design Guard is available under the BSD 3-Clause License.
See [LICENSE](LICENSE).