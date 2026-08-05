import 'package:analyzer/error/error.dart' show DiagnosticSeverity;
import 'package:analyzer/error/listener.dart' show DiagnosticReporter;
import 'package:custom_lint_builder/custom_lint_builder.dart'
    show CustomLintContext, CustomLintResolver, DartLintRule, LintCode;

/// Reports a warning when Flutter's native text input widgets are used.
///
/// Use CustomTextField instead to keep the application's design system
/// consistent.
class AvoidTextFieldRule extends DartLintRule {
  AvoidTextFieldRule() : super(code: _lintCode);

  static const _lintCode = LintCode(
    name: 'avoid_native_text_field',
    problemMessage:
        'Do not use TextField or TextFormField directly. '
        'Use CustomTextField instead.',
    correctionMessage:
        'Replace the native text input widget with CustomTextField.',
    errorSeverity: DiagnosticSeverity.WARNING,
  );

  static const _forbiddenWidgets = <String>{'TextField', 'TextFormField'};

  @override
  void run(
    CustomLintResolver resolver,
    DiagnosticReporter reporter,
    CustomLintContext context,
  ) {
    context.registry.addInstanceCreationExpression((node) {
      final widgetName = node.staticType?.element?.displayName;

      if (!_forbiddenWidgets.contains(widgetName)) {
        return;
      }

      reporter.atNode(node.constructorName.type, code);
    });
  }
}
