import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer_x/base/base.dart';

import '../tester/tester.dart';

class UnionParamGetter extends Getter {
  List<UnionParamUnit> units = [];

  @override
  void reset() {
    if (testerAccept<SuperNameBTester>()) {
      units.add(
        UnionParamUnit(
          className: className,
          paramName: paramName,
          children: methodInvocations,
          paramDesc: paramDesc,
          paramType: paramType
        ),
      );
    }
  }

  String get paramDesc {
    for (var meta in tester<SuperNameBTester>()
        .backFirstNode<ClassDeclaration>()
        .metadata) {
      if (meta.name.name == "ParamDesc") {
        return meta.arguments!.arguments[0].toString();
      }
    }
    return "";
  }

  String get className => tester<SuperNameBTester>()
      .backFirstNode<ClassDeclaration>()
      .name
      .toString();

  String get paramName => tester<SuperNameBTester>().firstNode.value;

  List<String> get methodInvocations => tester<MayExternRTester>()
      .tList<MethodInvocation>()
      .map((node) => node.methodName.toString())
      .toList();

  String get paramType {
    for (var param in tester<SuperNameBTester>()
        .backFirstNode<ConstructorDeclaration>()
        .parameters
        .parameters) {
      if (param is SimpleFormalParameter) {
        return param.type?.toString() ?? '';
      }
    }
    return "";
  }

  @override
  List<BackTester> testers = [
    SuperNameBTester(
      superClass: 'UnionParam',
      labelName: 'name',
    ),
    MayExternRTester(),
  ];

  static bool mayTarget(String fileString) {
    return fileString.contains('super') &&
        fileString.contains('UnionParam') &&
        fileString.contains('name');
  }
}

class UnionParamUnit {
  final String className;
  final String paramName;
  final String paramDesc;
  final String paramType;

  ///可能是BaseParam Class的Method Invocation
  final List<String> children;

  void filter(List<String> patterns) {
    for (var child in children.toList()) {
      if (!patterns.contains(child)) {
        children.remove(child);
      }
    }
  }

  UnionParamUnit({
    required this.className,
    required this.paramName,
    required this.paramDesc,
    required this.children,
    required this.paramType,
  });
}
