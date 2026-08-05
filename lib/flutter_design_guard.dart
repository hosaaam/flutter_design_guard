import 'package:custom_lint_builder/custom_lint_builder.dart';
import 'package:flutter_design_guard/src/rules/avoid_text_field_rule.dart';

PluginBase createPlugin() => _FlutterDesignGuardPlugin();

class _FlutterDesignGuardPlugin extends PluginBase {
  @override
  List<LintRule> getLintRules(CustomLintConfigs configs) {
    return [AvoidTextFieldRule()];
  }
}
