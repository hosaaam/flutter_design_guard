import 'package:analysis_server_plugin/plugin.dart';
import 'package:analysis_server_plugin/registry.dart';
import 'package:flutter_design_guard/src/rules/avoid_native_text_field_rule.dart';

/// Entry point loaded by the Dart Analysis Server.
final plugin = FlutterDesignGuardPlugin();

/// Enforces Flutter design-system conventions.
final class FlutterDesignGuardPlugin extends Plugin {
  @override
  String get name => 'Flutter Design Guard';

  @override
  void register(PluginRegistry registry) {
    registry.registerLintRule(AvoidNativeTextFieldRule());
  }
}
