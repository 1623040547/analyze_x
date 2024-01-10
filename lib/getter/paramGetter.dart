import 'package:analyzer/dart/ast/ast.dart';

import '../base/base.dart';
import '../path/path.dart';
import '../tester/tester.dart';

///获取一个Class类型的数据信息，该类需满足一下条件
///(1)继承自类[BaseParam]
///(2)构造器中的super中应包含[name]字段
///(3)[name]字段类型为简单字符串
class ParamGetter extends Getter {
  List<ParamUnit> units = [];

  @override
  void reset() {
    if (testerAccept<SuperNameRTester>()) {
      units.add(
        ParamUnit(
          className: className,
          paramName: paramName,
        ),
      );
    }
  }

  String get className => tester<SuperNameRTester>()
      .retroFirstNode<ClassDeclaration>()
      .name
      .toString();

  String get paramName => tester<SuperNameRTester>().firstNode.value;

  @override
  List<RetroTester> testers = [
    SuperNameRTester(
      superClass: 'BaseParam',
      labelName: 'name',
    ),
  ];

  static bool mayTarget(String fileString) {
    return fileString.contains('super') &&
        fileString.contains('BaseParam') &&
        fileString.contains('name');
  }
}

class ParamUnit {
  final String className;
  final String paramName;

  ParamUnit({
    required this.className,
    required this.paramName,
  });
}

Map<DartFile, List<ParamUnit>> parseParam() {
  List<DartFile> inputFilePath = getDartFiles(isTarget: ParamGetter.mayTarget);
  Map<DartFile, List<ParamUnit>> unitsMap = {};

  for (var file in inputFilePath) {
    var getter = ParamGetter();
    MainAnalyzer(getters: [getter], filePath: file.filePath);
    unitsMap[file] = getter.units;
  }
  return unitsMap;
}
