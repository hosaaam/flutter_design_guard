import 'package:custom_lint_builder/custom_lint_builder.dart';

LintCode forbiddenWidgetCode({
  required String widget,
  required String replacement,
}) {
  return LintCode(
    name: 'avoid_${widget.toLowerCase()}',
    problemMessage: 'Do not use $widget directly. Use $replacement instead.',
    correctionMessage: 'Replace $widget with $replacement.',
  );
}
