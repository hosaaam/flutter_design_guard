/// Configuration used by Flutter Design Guard.
final class FlutterDesignGuardConfig {
  FlutterDesignGuardConfig({
    AvoidNativeTextFieldConfig? avoidNativeTextField,
    AvoidHardcodedColorConfig? avoidHardcodedColor,
  }) : avoidNativeTextField =
           avoidNativeTextField ?? AvoidNativeTextFieldConfig(),
       avoidHardcodedColor = avoidHardcodedColor ?? AvoidHardcodedColorConfig();

  /// Configuration for the `avoid_native_text_field` rule.
  final AvoidNativeTextFieldConfig avoidNativeTextField;

  /// Configuration for the `avoid_hardcoded_color` rule.
  final AvoidHardcodedColorConfig avoidHardcodedColor;
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

/// Configuration for the `avoid_hardcoded_color` rule.
final class AvoidHardcodedColorConfig {
  AvoidHardcodedColorConfig({
    this.replacement = 'AppColors',
    Iterable<String> implementationPaths = const [],
  }) : implementationPaths = List.unmodifiable(implementationPaths);

  /// Color source that consumers should use instead of hardcoded colors.
  final String replacement;

  /// Project-relative paths allowed to define hardcoded colors internally.
  final List<String> implementationPaths;
}
