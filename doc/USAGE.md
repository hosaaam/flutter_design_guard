# Flutter Design Guard usage

Flutter Design Guard runs as an official Dart Analyzer plugin. It reports
design-system violations in supported IDEs and through `dart analyze` or
`flutter analyze`.

## Installation

Add the plugin to your application's `analysis_options.yaml`:

```yaml
include: package:flutter_lints/flutter.yaml

plugins:
  flutter_design_guard:
    version: ^0.1.2
    diagnostics:
      avoid_native_text_field: true
      avoid_hardcoded_color: true
```

No package dependency or Dart import is required. If diagnostics do not appear
immediately, restart the Dart Analysis Server.

## Diagnostics

### `avoid_native_text_field`

Reports direct construction of Flutter Material's `TextField` and
`TextFormField`. A local class with either name is not reported.

```dart
// Reported
TextField();

TextFormField();

// Approved design-system wrapper
AppField();
```

### `avoid_hardcoded_color`

Reports Flutter palette values and direct `dart:ui` color construction:

```dart
// Reported
Colors.red;Colors.red.shade500;Color
(0xFF6750A4);Color.fromARGB(255, 103, 80, 164);
Color.fromRGBO(103, 80, 164, 1);

// Approved
Theme.of(context).colorScheme.primary;
AppColors.brand;
```

## Configuration

Create `flutter_design_guard.yaml` in the same directory as your package's
`pubspec.yaml` to customize replacement messages or allow the implementation
files behind your design system:

```yaml
rules:
  avoid_native_text_field:
    replacement: AppField
    implementation_paths:
      - lib/design_system/app_field.dart
  avoid_hardcoded_color:
    replacement: AppColors
    implementation_paths:
      - lib/design_system/app_colors.dart
```

- `replacement` is the name shown in the diagnostic and correction message.
- `implementation_paths` contains project-relative file paths. Native text
  fields or hardcoded colors are allowed only in those files.

Diagnostics are selected explicitly in `analysis_options.yaml`. Set a rule to
`false` when you want to keep it disabled:

```yaml
plugins:
  flutter_design_guard:
    version: ^0.1.2
    diagnostics:
      avoid_native_text_field: true
      avoid_hardcoded_color: true
```

For local package development, replace `version` with `path`:

```yaml
plugins:
  flutter_design_guard:
    path: ../flutter_design_guard
    diagnostics:
      avoid_native_text_field: true
      avoid_hardcoded_color: true
```

## Running checks

```bash
flutter analyze
```

or:

```bash
dart analyze
```

To suppress an exceptional violation, use Dart's standard diagnostic comments:

```dart
// ignore: flutter_design_guard/avoid_hardcoded_color
const legacyColor = Color(0xFF123456);

// ignore_for_file: flutter_design_guard/avoid_native_text_field
```

Prefer `implementation_paths` for approved design-system implementation files;
it documents the architectural boundary in one place.
