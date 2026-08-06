/// Configuration used by Flutter Design Guard.
final class FlutterDesignGuardConfig {
  FlutterDesignGuardConfig({AvoidNativeTextFieldConfig? avoidNativeTextField})
    : avoidNativeTextField =
          avoidNativeTextField ?? AvoidNativeTextFieldConfig();

  /// Configuration for the `avoid_native_text_field` rule.
  final AvoidNativeTextFieldConfig avoidNativeTextField;
}

/// Configuration for the `avoid_native_text_field` rule.
final class AvoidNativeTextFieldConfig {
  AvoidNativeTextFieldConfig({
    this.replacement = 'CustomTextField',
    Iterable<String> implementationPaths = const [],
  }) : implementationPaths = List.unmodifiable(implementationPaths);

  /// Widget that consumers should use instead of Flutter text fields.
  final String replacement;

  /// Project-relative paths allowed to use Flutter text fields internally.
  final List<String> implementationPaths;
}
