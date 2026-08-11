import 'package:analyzer/analysis_rule/analysis_rule.dart';
import 'package:analyzer/analysis_rule/rule_context.dart';
import 'package:analyzer/analysis_rule/rule_visitor_registry.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/error/error.dart';

import '../config/flutter_design_guard_config.dart';
import '../config/flutter_design_guard_config_loader.dart';

/// Prevents direct use of hardcoded colors.
final class AvoidHardcodedColorRule extends AnalysisRule {
  AvoidHardcodedColorRule({
    FlutterDesignGuardConfigLoader configLoader =
        const FlutterDesignGuardConfigLoader(),
  }) : _configLoader = configLoader,
       super(
         name: 'avoid_hardcoded_color',
         description: 'Avoid hardcoded colors in application UI.',
       );

  final FlutterDesignGuardConfigLoader _configLoader;

  static const LintCode code = LintCode(
    'avoid_hardcoded_color',
    'Do not use hardcoded colors directly. Use {0} instead.',
    correctionMessage: 'Replace the hardcoded color with {0}.',
    severity: DiagnosticSeverity.WARNING,
  );

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

    if (package != null && _isImplementationFile(context, config)) {
      return;
    }

    registry.addInstanceCreationExpression(
      this,
      _ColorCreationVisitor(
        rule: this,
        replacement: config.avoidHardcodedColor.replacement,
      ),
    );

    registry.addPrefixedIdentifier(
      this,
      _ColorsVisitor(
        rule: this,
        replacement: config.avoidHardcodedColor.replacement,
      ),
    );
  }

  bool _isImplementationFile(
    RuleContext context,
    FlutterDesignGuardConfig config,
  ) {
    final currentFile = context.currentUnit?.file ?? context.definingUnit.file;

    final packageRoot = context.package!.root;
    final pathContext = packageRoot.provider.pathContext;

    final packageRootPath = pathContext.normalize(packageRoot.path);
    final currentFilePath = pathContext.normalize(currentFile.path);

    return config.avoidHardcodedColor.implementationPaths.any((configuredPath) {
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

      if (!pathContext.isWithin(packageRootPath, absoluteConfiguredPath)) {
        return false;
      }

      return pathContext.equals(currentFilePath, absoluteConfiguredPath);
    });
  }
}

final class _ColorCreationVisitor extends SimpleAstVisitor<void> {
  const _ColorCreationVisitor({required this.rule, required this.replacement});

  final AvoidHardcodedColorRule rule;
  final String replacement;

  @override
  void visitInstanceCreationExpression(InstanceCreationExpression node) {
    final constructorElement = node.constructorName.element;

    if (constructorElement == null) {
      return;
    }

    final enclosingElement = constructorElement.enclosingElement;

    if (enclosingElement is! ClassElement) {
      return;
    }

    if (enclosingElement.name != 'Color') {
      return;
    }

    if (constructorElement.library.uri.toString() != 'dart:ui') {
      return;
    }

    rule.reportAtNode(node.constructorName, arguments: [replacement]);
  }
}

final class _ColorsVisitor extends SimpleAstVisitor<void> {
  const _ColorsVisitor({required this.rule, required this.replacement});

  final AvoidHardcodedColorRule rule;
  final String replacement;

  @override
  void visitPrefixedIdentifier(PrefixedIdentifier node) {
    final prefixElement = node.prefix.element;

    if (prefixElement is ClassElement &&
        prefixElement.name == 'Colors' &&
        _isFlutterLibrary(prefixElement.library.uri)) {
      _report(node);
      return;
    }

    final identifierElement = node.identifier.element;

    if (identifierElement is ClassElement &&
        identifierElement.name == 'Colors' &&
        _isFlutterLibrary(identifierElement.library.uri)) {
      _report(node);
    }
  }

  bool _isFlutterLibrary(Uri uri) {
    return uri.scheme == 'package' &&
        uri.pathSegments.isNotEmpty &&
        uri.pathSegments.first == 'flutter';
  }

  void _report(PrefixedIdentifier node) {
    rule.reportAtNode(node, arguments: [replacement]);
  }
}
