# Flutter Design Guard

Custom lint rules that help Flutter teams enforce their design system directly
inside the IDE and CI.

The first rule prevents direct usage of Flutter's native `TextField` and
`TextFormField` widgets and recommends using `CustomTextField` instead.

## Features

- Reports warnings directly inside supported IDEs.
- Detects Flutter's native `TextField`.
- Detects Flutter's native `TextFormField`.
- Recommends using the project's approved design-system component.
- Can run locally and in CI.
- Does not affect the application's runtime or production bundle.

## Installation

Add `flutter_design_guard` and `custom_lint` to your Flutter application's
`dev_dependencies`:

```yaml
dev_dependencies:
  custom_lint: ^0.8.1
  flutter_design_guard: ^0.0.1
```

Install the dependencies:

```bash
flutter pub get
```

This package is a development tool. You do not need to import it into your
application's Dart files.

## Configuration

Enable `custom_lint` in your application's `analysis_options.yaml`:

```yaml
analyzer:
  plugins:
    - custom_lint
```

To explicitly enable only the required rules:

```yaml
analyzer:
  plugins:
    - custom_lint

custom_lint:
  enable_all_lint_rules: false
  rules:
    - avoid_native_text_field
```

## Usage

The following code reports a warning:

```dart
TextField();

TextFormField();
```

The reported warning is:

```text
Do not use TextField or TextFormField directly.
Use CustomTextField instead.

avoid_native_text_field • WARNING
```

Use the approved design-system component instead:

```dart
CustomTextField();
```

## Command-line usage

Run the standard Dart analyzer:

```bash
dart analyze
```

Run Flutter Design Guard rules:

```bash
dart run custom_lint
```

## CI usage

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

## Ignoring a warning

Ignore one occurrence:

```dart
// ignore: avoid_native_text_field
final field = TextField();
```

Ignore the rule for an entire file:

```dart
// ignore_for_file: avoid_native_text_field
```

Use ignores only for exceptional cases, such as implementing the approved
design-system component itself.

## Available rules

### `avoid_native_text_field`

Reports a warning when Flutter's native `TextField` or `TextFormField` is used
directly.

## Documentation

See the [complete usage guide](doc/USAGE.md) for IDE setup, CI integration,
troubleshooting, and additional examples.

## Roadmap

Future releases are planned to include rules for:

- Native Flutter buttons.
- Hardcoded colors outside theme definitions.
- Inline text styles.
- Design-system spacing and radius tokens.
- Native dialogs, snackbars, and loading indicators.
- Configurable replacements and excluded paths.

## License

Flutter Design Guard is available under the BSD 3-Clause License.
See [LICENSE](LICENSE).