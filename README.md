# Flutter Design Guard

A Dart Analyzer plugin that keeps Flutter UI code aligned with your design
system in the IDE, `dart analyze`, and `flutter analyze`.

## What it guards

- `avoid_native_text_field` — reports direct `TextField` and `TextFormField`
  usage and points developers to your approved wrapper.
- `avoid_hardcoded_color` — reports `Colors.*`, `Color(...)`,
  `Color.fromARGB(...)`, and `Color.fromRGBO(...)` so UI colors come from
  theme or design tokens.

Theme colors such as `Theme.of(context).colorScheme.primary` and custom token
classes such as `AppColors` are allowed.

## Install

Enable the official analyzer plugin and its diagnostics in
`analysis_options.yaml`:

```yaml
plugins:
  flutter_design_guard:
    version: ^0.1.2
    diagnostics:
      avoid_native_text_field: true
      avoid_hardcoded_color: true
```

No `pubspec.yaml` dependency or source import is required.

## Configure

To customize their guidance, create `flutter_design_guard.yaml` at the project
root:

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

`implementation_paths` are project-relative files where native widgets or
hardcoded colors are allowed, typically the files that define your approved
design-system abstractions.

## Example

```dart
// Reported
TextField();
TextFormField();
Container(color: Colors.red);
final brand = Color(0xFF6750A4);

// Approved
AppField();
Container(color: Theme.of(context).colorScheme.primary);
Container(color: AppColors.brand);
```

Run `dart analyze` or `flutter analyze`. See [the usage guide](doc/USAGE.md)
for diagnostic configuration, exclusions, and troubleshooting.

## License

MIT
