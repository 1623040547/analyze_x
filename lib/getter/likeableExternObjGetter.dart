import 'package:analyzer/dart/ast/ast.dart';

import '../base/base.dart';
import '../tester/tester.dart';

///获取一个dart文件中疑似是外部引入对象的名字，
///具体为[PrefixedIdentifier]||[NamedType]||[MethodInvocation]
class LikeableExternObjGetter extends Getter {
  LikeableExternUnit unit = LikeableExternUnit();

  @override
  void reset() {
    unit.ids.addAll(getNamedTypes() ?? []);
    unit.ids.addAll(getMethodInvocations() ?? []);
    unit.ids.addAll(getPrefixedIdentifiers() ?? []);
  }

  @override
  List<RetroTester<AstNode>> testers = [
    MayExternRTester(),
  ];

  List<String>? getNamedTypes() => tester<MayExternRTester>()
      .nodes[AnalyzerStep.namedType]
      ?.map((node) => (node as NamedType).name.name)
      .toList();

  List<String>? getMethodInvocations() => tester<MayExternRTester>()
      .nodes[AnalyzerStep.methodInvocation]
      ?.map((node) => (node as MethodInvocation).methodName.name)
      .toList();

  List<String>? getPrefixedIdentifiers() => tester<MayExternRTester>()
      .nodes[AnalyzerStep.prefixedIdentifier]
      ?.map((node) => (node as PrefixedIdentifier).prefix.name)
      .toList();
}

class LikeableExternUnit {
  List<String> ids = [];
}
