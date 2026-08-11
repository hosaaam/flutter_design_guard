// ignore_for_file: non_constant_identifier_names

import 'package:analyzer_testing/analysis_rule/analysis_rule.dart';
import 'package:flutter_design_guard/src/rules/avoid_hardcoded_color.dart';
import 'package:test_reflective_loader/test_reflective_loader.dart';

void main() {
  defineReflectiveSuite(() {
    defineReflectiveTests(AvoidHardcodedColorRuleTest);
  });
}

@reflectiveTest
class AvoidHardcodedColorRuleTest extends AnalysisRuleTest {
  @override
  bool get addFlutterPackageDep => true;

  @override
  void setUp() {
    rule = AvoidHardcodedColorRule();
    super.setUp();
  }

  void test_color() async {
    await assertDiagnostics(
      r'''
import 'dart:ui';

void main() {
  final color = Color(0xFF123456);
}
''',
      [lint(49, 5)],
    );
  }

  void test_colorFromARGB() async {
    await assertDiagnostics(
      r'''
import 'dart:ui';

void main() {
  final color = Color.fromARGB(255, 18, 52, 86);
}
''',
      [lint(49, 14)],
    );
  }

  void test_colorFromRGBO() async {
    await assertDiagnostics(
      r'''
import 'dart:ui';

void main() {
  final color = Color.fromRGBO(18, 52, 86, 1);
}
''',
      [lint(49, 14)],
    );
  }

  void test_localColorClass_isIgnored() async {
    await assertNoDiagnostics(r'''
class Color {
  const Color();
}

void main() {
  const color = Color();
}
''');
  }

  void test_localColorsClass_isIgnored() async {
    await assertNoDiagnostics(r'''
class Colors {
  static const red = 0;
}

void main() {
  final color = Colors.red;
}
''');
  }

  void test_colors_red() async {
    await assertDiagnostics(
      r'''
import 'package:flutter/material.dart';

void main() {
  final color = Colors.red;
}
''',
      [lint(71, 10)],
    );
  }

  void test_colors_redShade500() async {
    await assertDiagnostics(
      r'''
import 'package:flutter/material.dart';

void main() {
  final color = Colors.red.shade500;
}
''',
      [lint(71, 10)],
    );
  }

  void test_colors_redShade700() async {
    await assertDiagnostics(
      r'''
import 'package:flutter/material.dart';

void main() {
  final color = Colors.red.shade700;
}
''',
      [lint(71, 10)],
    );
  }

  void test_colors_nestedPropertyAccess() async {
    await assertDiagnostics(
      r'''
import 'package:flutter/material.dart';

void main() {
  final color = Colors.red.shade500;
}
''',
      [lint(71, 10)],
    );
  }
}
