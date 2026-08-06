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

    final rawRule = rules['avoid_native_text_field'];
    if (rawRule is! YamlMap) {
      return FlutterDesignGuardConfig();
    }

    final defaults = AvoidNativeTextFieldConfig();

    return FlutterDesignGuardConfig(
      avoidNativeTextField: AvoidNativeTextFieldConfig(
        replacement: _readReplacement(
          rawRule['replacement'],
          fallback: defaults.replacement,
        ),
        implementationPaths: _readImplementationPaths(
          rawRule['implementation_paths'],
        ),
      ),
    );
  }

  String _readReplacement(Object? value, {required String fallback}) {
    if (value is! String) return fallback;

    final replacement = value.trim();
    return replacement.isEmpty ? fallback : replacement;
  }

  List<String> _readImplementationPaths(Object? value) {
    if (value is! YamlList) return const [];

    return value
        .whereType<String>()
        .map((path) => path.trim())
        .where((path) => path.isNotEmpty)
        .toSet()
        .toList(growable: false);
  }
}
