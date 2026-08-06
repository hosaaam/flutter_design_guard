## 0.1.0-dev.1 - 2026-08-06

- Added the official Dart analyzer plugin entry point.
- Added the `avoid_native_text_field` diagnostic.
- Added semantic detection for Flutter Material `TextField` and
  `TextFormField`.
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