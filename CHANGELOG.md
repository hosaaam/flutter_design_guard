# Changelog

All notable changes to this project will be documented in this file.

## 0.1.2

- Added the `avoid_hardcoded_color` diagnostic.
- Detects Flutter `Colors.*` values, including Material color shades.
- Detects `Color(...)`, `Color.fromARGB(...)`, and `Color.fromRGBO(...)`.
- Allows theme-based colors and project design tokens.
- Added configurable replacement guidance and implementation paths for color
  token definitions.
- Added analyzer tests, documentation, and an example covering both available
  diagnostics.

## 0.1.1

- Updated installation to use the official Dart Analyzer Plugin configuration.
- Installation now requires only `analysis_options.yaml`.
- Improved README with clearer installation, configuration, and usage examples.
- Clarified configuration options and diagnostics.

## 0.1.0

- First stable release.
- Migrated to Dart's official analyzer plugin system.
- Added the `avoid_native_text_field` diagnostic.
- Detects direct usage of Flutter's `TextField` and `TextFormField`.
- Allows projects to enforce using a custom design-system text field.
- Added analyzer tests for valid and invalid widget usage.
- Added configuration and installation documentation.
- Verified support through `dart analyze` and `flutter analyze`.

## 0.1.0-dev.1

- Added the official Dart analyzer plugin entry point.
- Added semantic detection for Flutter Material `TextField` and
  `TextFormField`.
- Added configurable replacement names and allowed implementation paths.
- Added configuration parsing, tests, documentation, and an example project.

## 0.0.1

- Initial release.
- Added the `avoid_native_text_field` lint rule.
- Reports direct `TextField` and `TextFormField` usage.
- Recommends using a project-specific design-system text field.
