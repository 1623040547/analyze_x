import 'package:analyzer/dart/ast/ast.dart';

import '../base/base.dart';
import '../tester/tester.dart';

///获取一个dart文件中的[Class]||[Enum]||[Function] 声明
class DeclarationGetter extends Getter {
  DeclarationUnit unit = DeclarationUnit();

  @override
  void reset() {
    unit.dClass.addAll(getClasses() ?? []);
    unit.dFunction.addAll(getFunctions() ?? []);
    unit.dEnum.addAll(getEnums() ?? []);
  }

  @override
  List<RetroTester<AstNode>> testers = [
    DeclarationRTester(),
  ];

  List<String>? getClasses() => tester<DeclarationRTester>()
      .nodes[AnalyzerStep.classDeclaration]
      ?.map((node) => (node as ClassDeclaration).name.toString())
      .toList();

  List<String>? getFunctions() => tester<DeclarationRTester>()
      .nodes[AnalyzerStep.functionDeclaration]
      ?.map((node) => (node as FunctionDeclaration).name.toString())
      .toList();

  List<String>? getEnums() => tester<DeclarationRTester>()
      .nodes[AnalyzerStep.enumDeclaration]
      ?.map((node) => (node as EnumDeclaration).name.toString())
      .toList();
}

class DeclarationUnit {
  List<String> dClass = [];
  List<String> dFunction = [];
  List<String> dEnum = [];
}
