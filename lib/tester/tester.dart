import 'package:analyzer/dart/ast/ast.dart';

import '../base/base.dart';

///获取一个继承[superClass]的构造器超集中[labelName]的[SimpleStringLiteral]取值
class SuperNameRTester extends RetroTester<SimpleStringLiteral> {
  ///构造器类名
  String className = '';

  ///标签中的字符串取值
  String labelStringValue = '';

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
    className = classDeclaration.name.toString();
    labelStringValue = node.value;
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

  @override
  void reset() {
    className = '';
    labelStringValue = '';
  }
}

///获取构造器中的参数列表
class ConstructorParametersRTester extends RetroTester<FieldFormalParameter> {
  ///构造器形参列表，{形参变量名:是否必须},
  ///bool类型代表是否[isRequiredNamed]&[isNamed]
  Map<String, bool> constructorParameters = {};

  @override
  bool accept(node) {
    constructorParameters.addAll(
      {node.name.toString(): node.isRequiredNamed || node.isNamed},
    );
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

  @override
  void reset() {
    constructorParameters = {};
  }
}

///获取类中的属性列表
class ClassParametersRTester extends RetroTester<VariableDeclaration> {
  ///构造器形参列表，{形参变量名：形参类型}
  Map<String, String> classParameters = {};

  ///记录参数是否可以为空,{形参变量名: 是否可为空}
  Map<String, bool> classParameterQuestions = {};

  @override
  bool accept(VariableDeclaration node) {
    VariableDeclarationList name = retroNode<VariableDeclarationList>(node);
    bool question = name.type?.question != null;
    String type = name.type.toString().replaceAll('?', '');

    classParameters.addAll({node.name.toString(): type});
    classParameterQuestions.addAll({node.name.toString(): question});
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

  @override
  void reset() {
    classParameters = {};
    classParameterQuestions = {};
  }
}

class MayExternRTester extends SimpleRetroTester {
  Set<String> ids = {};

  @override
  bool accept(node) {
    if (node is NamedType) {
      ids.add(node.name.name);
    } else if (node is MethodInvocation) {
      ids.add(node.methodName.name);
    } else if (node is PrefixedIdentifier) {
      ids.add(node.prefix.name);
    }
    return true;
  }

  @override
  List<AnalyzerStep> get path => [
        AnalyzerStep.namedType,
        AnalyzerStep.methodInvocation,
        AnalyzerStep.prefixedIdentifier,
      ];
}

///获取声明：类、函数、枚举
class DeclarationRTester extends SimpleRetroTester {
  Set<String> dClass = {};
  Set<String> dFunction = {};
  Set<String> dEnum = {};

  @override
  bool accept(AstNode node) {
    if (node is ClassDeclaration) {
      dClass.add(node.name.toString());
    } else if (node is FunctionDeclaration) {
      dFunction.add(node.name.toString());
    } else if (node is EnumDeclaration) {
      dEnum.add(node.name.toString());
    }
    return true;
  }

  @override
  List<AnalyzerStep> get path => [
        AnalyzerStep.classDeclaration,
        AnalyzerStep.functionDeclaration,
        AnalyzerStep.enumDeclaration,
      ];
}

///获取库/文件引用信息
class DirectiveRTester extends SimpleRetroTester {
  Set<String> dLibrary = {};
  Set<String> dPart = {};
  Set<String> dExport = {};
  Map<int, String> dPartOf = {};

  @override
  bool accept(AstNode node) {
    if (node is LibraryDirective) {
      dLibrary.add(node.name2.toString());
    } else if (node is PartDirective) {
      dPart.add(node.uri.toString());
    } else if (node is PartOfDirective) {
      if (node.uri != null) {
        dPartOf.addAll({0: node.uri.toString()});
      } else if (node.libraryName != null) {
        dPartOf.addAll({1: node.libraryName.toString()});
      }
    } else if (node is ExportDirective) {
      dExport.add(node.uri.toString());
    }
    return true;
  }

  @override
  List<AnalyzerStep> get path => [
        AnalyzerStep.libraryDirective,
        AnalyzerStep.partDirective,
        AnalyzerStep.partOfDirective,
        AnalyzerStep.exportDirective,
      ];
}