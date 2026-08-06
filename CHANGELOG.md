# Changelog

All notable changes to this project will be documented in this file.

## 0.1.1

- Updated installation to use the official Dart Analyzer Plugin configuration.
- Installation now requires only `analysis_options.yaml`.
- Improved README with clearer installation, configuration, and usage examples.
- Clarified configuration options and diagnostics.

## 0.1.0

- First stable release.
- Migrated to Dart's official analyzer plugin system.
- Added the `avoid_native_text_field` diagnostic.
- Detects direct usage of Flutter's `TextField`.
- Detects direct usage of Flutter's `TextFormField`.
- Allows projects to enforce using a custom design-system text field.
- Added analyzer tests for valid and invalid widget usage.
- Added configuration and installation documentation.
- Verified support through `dart analyze` and `flutter analyze`.

## 0.1.0-dev.1

- Added the official Dart analyzer plugin entry point.
- Added the `avoid_native_text_field` diagnostic.
- Added semantic detection for Flutter Material `TextField` and `TextFormField`.
- Added configurable replacement widget names.
- Added allowed implementation paths.
- Allowed native text fields inside the configured replacement class.
- Added configuration parsing, tests, documentation, and an example project.

## 0.0.1

- Initial release.
- Added the `avoid_native_text_field` lint rule.
- Reports a warning when Flutter's `TextField` is used directly.
- Reports a warning when Flutter's `TextFormField` is used directly.
- Recommends using `CustomTextField` instead.