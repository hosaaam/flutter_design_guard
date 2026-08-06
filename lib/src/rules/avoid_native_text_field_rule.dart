import 'package:analyzer/analysis_rule/analysis_rule.dart';
import 'package:analyzer/analysis_rule/rule_context.dart';
import 'package:analyzer/analysis_rule/rule_visitor_registry.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:analyzer/error/error.dart';

import '../config/flutter_design_guard_config.dart';
import '../config/flutter_design_guard_config_loader.dart';

/// Prevents direct use of Flutter Material text-input widgets.
final class AvoidNativeTextFieldRule extends AnalysisRule {
  AvoidNativeTextFieldRule({
    FlutterDesignGuardConfigLoader configLoader =
        const FlutterDesignGuardConfigLoader(),
  }) : _configLoader = configLoader,
       super(
         name: 'avoid_native_text_field',
         description:
             'Avoid direct use of Flutter Material text-input widgets.',
       );

  final FlutterDesignGuardConfigLoader _configLoader;

  /// The diagnostic code must have a single, stable instance.
  static const LintCode code = LintCode(
    'avoid_native_text_field',
    'Do not use {0} directly. Use {1} instead.',
    correctionMessage: 'Replace {0} with {1}.',
    severity: DiagnosticSeverity.WARNING,
  );

  static const Map<String, String> _forbiddenWidgets = {
    'TextField': 'package:flutter/src/material/text_field.dart',
    'TextFormField': 'package:flutter/src/material/text_form_field.dart',
  };

  @override
  LintCode get diagnosticCode => code;

  @override
  void registerNodeProcessors(
    RuleVisitorRegistry registry,
    RuleContext context,
  ) {
    final package = context.package;

    final config = package == null
        ? FlutterDesignGuardConfig()
        : _configLoader.load(package.root);

    if (package != null) {
      final currentFile =
          context.currentUnit?.file ?? context.definingUnit.file;

      final pathContext = package.root.provider.pathContext;
      final packageRootPath = pathContext.normalize(package.root.path);
      final currentFilePath = pathContext.normalize(currentFile.path);

      final isImplementationFile = config
          .avoidNativeTextField
          .implementationPaths
          .any((configuredPath) {
            if (pathContext.isAbsolute(configuredPath)) {
              return false;
            }

            final platformPath = configuredPath.replaceAll(
              '/',
              pathContext.separator,
            );

            final absoluteConfiguredPath = pathContext.normalize(
              pathContext.join(packageRootPath, platformPath),
            );

            if (!pathContext.isWithin(
              packageRootPath,
              absoluteConfiguredPath,
            )) {
              return false;
            }

            return pathContext.equals(currentFilePath, absoluteConfiguredPath);
          });

      if (isImplementationFile) {
        return;
      }
    }
    registry.addInstanceCreationExpression(
      this,
      _Visitor(
        rule: this,
        replacement: config.avoidNativeTextField.replacement,
      ),
    );
  }
}

final class _Visitor extends SimpleAstVisitor<void> {
  const _Visitor({required this.rule, required this.replacement});

  final AvoidNativeTextFieldRule rule;
  final String replacement;

  @override
  void visitInstanceCreationExpression(InstanceCreationExpression node) {
    final enclosingClass = node.thisOrAncestorOfType<ClassDeclaration>();

    if (enclosingClass?.namePart.typeName.lexeme == replacement) {
      return;
    }
    final constructorElement = node.constructorName.element;
    if (constructorElement == null) return;

    final widgetElement = constructorElement.enclosingElement;
    final widgetName = widgetElement.displayName;
    final libraryUri = constructorElement.library.uri.toString();

    final expectedLibraryUri =
        AvoidNativeTextFieldRule._forbiddenWidgets[widgetName];

    // Matching both the symbol name and its declaring Flutter library
    // prevents false positives for local classes with the same name.
    if (expectedLibraryUri == null || libraryUri != expectedLibraryUri) {
      return;
    }

    rule.reportAtNode(
      node.constructorName.type,
      arguments: [widgetName, replacement],
    );
  }
}
