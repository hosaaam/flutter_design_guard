import 'package:flutter_design_guard/src/config/flutter_design_guard_config_parser.dart';
import 'package:test/test.dart';

void main() {
  group('FlutterDesignGuardConfigParser', () {
    const parser = FlutterDesignGuardConfigParser();

    test('parses replacement and implementation paths', () {
      final config = parser.parse(r'''
rules:
  avoid_native_text_field:
    replacement: AppField
    implementation_paths:
      - lib/widgets/app_field.dart
      - " lib/widgets/text_field_helper.dart "
      - lib/widgets/app_field.dart
  avoid_hardcoded_color:
    replacement: DesignColors
    implementation_paths:
      - lib/theme/design_colors.dart
''');

      final ruleConfig = config.avoidNativeTextField;

      expect(ruleConfig.replacement, 'AppField');
      expect(ruleConfig.implementationPaths, [
        'lib/widgets/app_field.dart',
        'lib/widgets/text_field_helper.dart',
      ]);
      expect(config.avoidHardcodedColor.replacement, 'DesignColors');
      expect(config.avoidHardcodedColor.implementationPaths, [
        'lib/theme/design_colors.dart',
      ]);
    });

    test('uses defaults when configuration is absent', () {
      final config = parser.parse('');

      final ruleConfig = config.avoidNativeTextField;

      expect(ruleConfig.replacement, 'CustomTextField');
      expect(ruleConfig.implementationPaths, isEmpty);
      expect(config.avoidHardcodedColor.replacement, 'AppColors');
      expect(config.avoidHardcodedColor.implementationPaths, isEmpty);
    });

    test('uses safe defaults when values have invalid types', () {
      final config = parser.parse(r'''
rules:
  avoid_native_text_field:
    replacement: 42
    implementation_paths: invalid
  avoid_hardcoded_color:
    replacement: []
    implementation_paths: invalid
''');

      final ruleConfig = config.avoidNativeTextField;

      expect(ruleConfig.replacement, 'CustomTextField');
      expect(ruleConfig.implementationPaths, isEmpty);
      expect(config.avoidHardcodedColor.replacement, 'AppColors');
      expect(config.avoidHardcodedColor.implementationPaths, isEmpty);
    });
  });
}
