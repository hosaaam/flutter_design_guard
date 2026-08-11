import 'package:yaml/yaml.dart';

import 'flutter_design_guard_config.dart';

/// Converts YAML content into Flutter Design Guard configuration.
final class FlutterDesignGuardConfigParser {
  const FlutterDesignGuardConfigParser();

  /// Parses configuration from [source].
  FlutterDesignGuardConfig parse(String source, {Uri? sourceUrl}) {
    final document = loadYaml(source, sourceUrl: sourceUrl);

    if (document is! YamlMap) {
      return FlutterDesignGuardConfig();
    }

    final rules = document['rules'];

    if (rules is! YamlMap) {
      return FlutterDesignGuardConfig();
    }

    return FlutterDesignGuardConfig(
      avoidNativeTextField: _parseNativeTextFieldRule(
        rules['avoid_native_text_field'],
      ),
      avoidHardcodedColor: _parseHardcodedColorRule(
        rules['avoid_hardcoded_color'],
      ),
    );
  }

  AvoidNativeTextFieldConfig _parseNativeTextFieldRule(Object? value) {
    final defaults = AvoidNativeTextFieldConfig();

    if (value is! YamlMap) {
      return defaults;
    }

    return AvoidNativeTextFieldConfig(
      replacement: _readReplacement(
        value['replacement'],
        fallback: defaults.replacement,
      ),
      implementationPaths: _readImplementationPaths(
        value['implementation_paths'],
      ),
    );
  }

  AvoidHardcodedColorConfig _parseHardcodedColorRule(Object? value) {
    final defaults = AvoidHardcodedColorConfig();

    if (value is! YamlMap) {
      return defaults;
    }

    return AvoidHardcodedColorConfig(
      replacement: _readReplacement(
        value['replacement'],
        fallback: defaults.replacement,
      ),
      implementationPaths: _readImplementationPaths(
        value['implementation_paths'],
      ),
    );
  }

  String _readReplacement(Object? value, {required String fallback}) {
    if (value is! String) {
      return fallback;
    }

    final replacement = value.trim();

    return replacement.isEmpty ? fallback : replacement;
  }

  List<String> _readImplementationPaths(Object? value) {
    if (value is! YamlList) {
      return const [];
    }

    return value
        .whereType<String>()
        .map((path) => path.trim())
        .where((path) => path.isNotEmpty)
        .toSet()
        .toList(growable: false);
  }
}
