import 'package:analyzer/file_system/memory_file_system.dart';
import 'package:flutter_design_guard/src/config/flutter_design_guard_config_loader.dart';
import 'package:test/test.dart';

void main() {
  group('FlutterDesignGuardConfigLoader', () {
    const loader = FlutterDesignGuardConfigLoader();

    late MemoryResourceProvider resourceProvider;
    late String packageRootPath;

    setUp(() {
      resourceProvider = MemoryResourceProvider();
      packageRootPath = resourceProvider.pathContext.absolute('workspace');
      resourceProvider.newFolder(packageRootPath);
    });

    test('loads configuration from the package root', () {
      final configPath = resourceProvider.pathContext.join(
        packageRootPath,
        'flutter_design_guard.yaml',
      );

      resourceProvider.newFile(configPath, r'''
rules:
  avoid_native_text_field:
    replacement: AppField
    implementation_paths:
      - lib/widgets/app_field.dart
''');

      final config = loader.load(resourceProvider.getFolder(packageRootPath));

      expect(config.avoidNativeTextField.replacement, 'AppField');
      expect(config.avoidNativeTextField.implementationPaths, [
        'lib/widgets/app_field.dart',
      ]);
    });

    test('uses defaults when the configuration file is missing', () {
      final config = loader.load(resourceProvider.getFolder(packageRootPath));

      expect(config.avoidNativeTextField.replacement, 'CustomTextField');
      expect(config.avoidNativeTextField.implementationPaths, isEmpty);
    });

    test('uses defaults when the YAML is invalid', () {
      final configPath = resourceProvider.pathContext.join(
        packageRootPath,
        'flutter_design_guard.yaml',
      );

      resourceProvider.newFile(configPath, '''
rules:
  avoid_native_text_field:
    replacement: [
''');

      final config = loader.load(resourceProvider.getFolder(packageRootPath));

      expect(config.avoidNativeTextField.replacement, 'CustomTextField');
      expect(config.avoidNativeTextField.implementationPaths, isEmpty);
    });
  });
}
