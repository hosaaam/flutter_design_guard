// ignore_for_file: non_constant_identifier_names

import 'package:analyzer_testing/analysis_rule/analysis_rule.dart';
import 'package:flutter_design_guard/src/rules/avoid_native_text_field_rule.dart';
import 'package:test_reflective_loader/test_reflective_loader.dart';

void main() {
  defineReflectiveSuite(() {
    defineReflectiveTests(AvoidNativeTextFieldRuleTest);
  });
}

@reflectiveTest
class AvoidNativeTextFieldRuleTest extends AnalysisRuleTest {
  @override
  void setUp() {
    newPackage('flutter')
      ..addFile('lib/material.dart', r'''
export 'src/material/text_field.dart';
export 'src/material/text_form_field.dart';
''')
      ..addFile('lib/src/material/text_field.dart', r'''
class TextField {
  const TextField();
}
''')
      ..addFile('lib/src/material/text_form_field.dart', r'''
class TextFormField {
  const TextFormField();
}
''');

    rule = AvoidNativeTextFieldRule();
    super.setUp();
  }

  Future<void> test_flutterTextField_reportsDiagnostic() async {
    const source = r'''
import 'package:flutter/material.dart';

void build() {
  const TextField();
}
''';

    await assertDiagnostics(source, [
      lint(
        source.indexOf('TextField();'),
        'TextField'.length,
        messageContainsAll: ['TextField', 'CustomTextField'],
      ),
    ]);
  }

  Future<void> test_flutterTextFormField_reportsDiagnostic() async {
    const source = r'''
import 'package:flutter/material.dart';

void build() {
  const TextFormField();
}
''';

    await assertDiagnostics(source, [
      lint(
        source.indexOf('TextFormField();'),
        'TextFormField'.length,
        messageContainsAll: ['TextFormField', 'CustomTextField'],
      ),
    ]);
  }

  Future<void> test_localTextField_isAllowed() async {
    await assertNoDiagnostics(r'''
class TextField {
  const TextField();
}

void build() {
  const TextField();
}
''');
  }

  Future<void> test_configuredReplacement_appearsInDiagnostic() async {
    final configPath = resourceProvider.pathContext.join(
      testPackageRootPath,
      'flutter_design_guard.yaml',
    );

    newFile(configPath, r'''
rules:
  avoid_native_text_field:
    replacement: AppField
''');

    const source = r'''
import 'package:flutter/material.dart';

void build() {
  const TextField();
}
''';

    await assertDiagnostics(source, [
      lint(
        source.indexOf('TextField();'),
        'TextField'.length,
        messageContainsAll: ['TextField', 'AppField'],
        correctionContains: 'AppField',
      ),
    ]);
  }

  Future<void> test_implementationPath_isAllowed() async {
    final relativeTestFilePath = pathContext
        .relative(testFile.path, from: testPackageRootPath)
        .replaceAll(pathContext.separator, '/');

    newFile(
      pathContext.join(testPackageRootPath, 'flutter_design_guard.yaml'),
      '''
rules:
  avoid_native_text_field:
    replacement: AppField
    implementation_paths:
      - $relativeTestFilePath
''',
    );

    await assertNoDiagnostics(r'''
import 'package:flutter/material.dart';

void build() {
  const TextField();
  const TextFormField();
}
''');
  }

  Future<void> test_replacementClass_isAllowed() async {
    newFile(
      pathContext.join(testPackageRootPath, 'flutter_design_guard.yaml'),
      r'''
rules:
  avoid_native_text_field:
    replacement: AppField
''',
    );

    const source = r'''
import 'package:flutter/material.dart';

class AppField {
  const AppField();

  Object build() {
    return const TextField();
  }
}

void buildPage() {
  const TextField();
}
''';

    await assertDiagnostics(source, [
      lint(
        source.lastIndexOf('TextField();'),
        'TextField'.length,
        messageContainsAll: ['TextField', 'AppField'],
      ),
    ]);
  }
}
