import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';

import 'step.dart';

class PathVisitor extends SimpleAstVisitor {
  final List<AnalyzerStep> patterns;
  final List<AnalyzerStep> currentPath;
  final void Function(dynamic obj, AnalyzerStep step)? trigger;

  PathVisitor({
    required this.patterns,
    this.currentPath = const [],
    this.trigger,
  });

  @override
  visitCompilationUnit(CompilationUnit node) {
    forward(node);
  }

  @override
  visitClassDeclaration(ClassDeclaration node) {
    forward(node);
  }

  @override
  visitConstructorDeclaration(ConstructorDeclaration node) {
    forward(node);
  }

  @override
  visitSuperConstructorInvocation(SuperConstructorInvocation node) {
    forward(node);
  }

  @override
  visitArgumentList(ArgumentList node) {
    forward(node);
  }

  @override
  visitNamedExpression(NamedExpression node) {
    forward(node);
  }

  @override
  visitLabel(Label node) {
    forward(node);
  }

  @override
  visitSimpleStringLiteral(SimpleStringLiteral node) {
    forward(node);
  }

  @override
  visitExtendsClause(ExtendsClause node) {
    forward(node);
  }

  @override
  visitConstructorName(ConstructorName node) {
    forward(node);
  }

  @override
  visitFormalParameterList(FormalParameterList node) {
    forward(node);
  }

  @override
  visitDefaultFormalParameter(DefaultFormalParameter node) {
    forward(node);
  }

  @override
  visitFieldFormalParameter(FieldFormalParameter node) {
    forward(node);
  }

  @override
  visitFieldDeclaration(FieldDeclaration node) {
    forward(node);
  }

  @override
  visitVariableDeclarationList(VariableDeclarationList node) {
    forward(node);
  }

  @override
  visitVariableDeclaration(VariableDeclaration node) {
    forward(node);
  }

  @override
  visitNamedType(NamedType node) {
    forward(node);
  }

  ///visitor为深度优先遍历,对覆写节点前向推进过程中，
  ///若节点类型处于[patterns]之中，则调用[trigger]
  void forward(node) {
    AnalyzerStep? step = match(node);
    if (step != null) {
      trigger?.call(node, step);
      currentPath.add(step);
    }
    node.visitChildren(this);
  }

  AnalyzerStep? match(node) {
    List steps = patterns.where((e) => e.typeChecker(node)).toList();
    return steps.isEmpty ? null : steps.first;
  }
}
