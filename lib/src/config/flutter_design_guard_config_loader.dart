import 'package:analyzer/file_system/file_system.dart';
import 'package:yaml/yaml.dart';

import 'flutter_design_guard_config.dart';
import 'flutter_design_guard_config_parser.dart';

/// Loads Flutter Design Guard configuration from a package root.
final class FlutterDesignGuardConfigLoader {
  const FlutterDesignGuardConfigLoader({
    this.fileName = 'flutter_design_guard.yaml',
    this.parser = const FlutterDesignGuardConfigParser(),
  });

  /// Name of the configuration file expected at the package root.
  final String fileName;

  /// Parser used to convert the YAML source into configuration.
  final FlutterDesignGuardConfigParser parser;

  /// Loads configuration from [packageRoot].
  ///
  /// Returns the default configuration when the file is missing, unreadable,
  /// or contains invalid YAML.
  FlutterDesignGuardConfig load(Folder packageRoot) {
    final file = packageRoot.getFile(fileName);
    if (!file.exists) {
      return FlutterDesignGuardConfig();
    }

    try {
      return parser.parse(file.readAsStringSync(), sourceUrl: file.toUri());
    } on FileSystemException {
      return FlutterDesignGuardConfig();
    } on YamlException {
      return FlutterDesignGuardConfig();
    }
  }
}
