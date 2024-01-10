import 'package:analyzer/dart/ast/ast.dart';

import '../base/base.dart';

///获取一个继承[superClass]的构造器超集中[labelName]的[SimpleStringLiteral]取值
class SuperNameRTester extends RetroTester<SimpleStringLiteral> {
  final String superClass;

  final String labelName;

  SuperNameRTester({
    required this.superClass,
    required this.labelName,
  });

  @override
  bool accept(node) {
    ClassDeclaration classDeclaration = retroNode<ClassDeclaration>(node);
    ExtendsClause? extendsClause = classDeclaration.extendsClause;
    NamedExpression namedExpression = retroNode<NamedExpression>(node);
    Label label = namedExpression.name;
    if (extendsClause == null ||
        extendsClause.superclass.name.name != superClass) {
      return false;
    }
    if (label.label.name != labelName) {
      return false;
    }
    return true;
  }

  ///状态机为：
  ///[ClassDeclaration]，[ExtendsClause]=>
  ///[ConstructorDeclaration]=>
  ///[SuperConstructorInvocation]=>
  ///[ArgumentList]=>
  ///[NamedExpression]，[Label]=>
  ///[SimpleStringLiteral]
  @override
  List<AnalyzerStep> get path => [
        AnalyzerStep.simpleStringLiteral,
        AnalyzerStep.namedExpression,
        AnalyzerStep.argumentList,
        AnalyzerStep.superConstructorInvocation,
        AnalyzerStep.constructorDeclaration,
        AnalyzerStep.classDeclaration,
      ];
}

///获取构造器中的参数列表
class ConstructorParametersRTester extends RetroTester<FieldFormalParameter> {
  @override
  bool accept(node) {
    return true;
  }

  ///以[labelStringValue]为主流程，获取[constructorParameters]的状态机为：
  ///[ConstructorDeclaration]=>
  ///[FormalParameterList]=>
  ///[FieldFormalParameter]
  @override
  List<AnalyzerStep> get path => [
        AnalyzerStep.fieldFormalParameter,
        AnalyzerStep.formalParameterList,
        AnalyzerStep.constructorDeclaration,
      ];
}

///获取类中的属性列表
class ClassParametersRTester extends RetroTester<VariableDeclaration> {
  @override
  bool accept(VariableDeclaration node) {
    return true;
  }

  ///以[labelStringValue]为主流程，获取[classParameters]的状态机为：
  ///[FieldDeclaration]=>
  ///[VariableDeclarationList]=>
  ///[FieldFormal]=>
  ///[VariableDeclaration]
  @override
  List<AnalyzerStep> get path => [
        AnalyzerStep.variableDeclaration,
        AnalyzerStep.variableDeclarationList,
        AnalyzerStep.fieldDeclaration,
        AnalyzerStep.classDeclaration,
      ];
}

class MayExternRTester extends SimpleRetroTester {
  @override
  List<AnalyzerStep> get path => [
        AnalyzerStep.namedType,
        AnalyzerStep.methodInvocation,
        AnalyzerStep.prefixedIdentifier,
      ];
}

///获取声明：类、函数、枚举
class DeclarationRTester extends SimpleRetroTester {
  @override
  List<AnalyzerStep> get path => [
        AnalyzerStep.classDeclaration,
        AnalyzerStep.functionDeclaration,
        AnalyzerStep.enumDeclaration,
      ];
}

///获取库/文件引用信息
class DirectiveRTester extends SimpleRetroTester {
  @override
  List<AnalyzerStep> get path => [
        AnalyzerStep.libraryDirective,
        AnalyzerStep.partDirective,
        AnalyzerStep.partOfDirective,
        AnalyzerStep.exportDirective,
      ];
}
