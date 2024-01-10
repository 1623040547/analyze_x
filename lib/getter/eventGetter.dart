import 'package:analyzer/dart/ast/ast.dart';

import '../base/base.dart';
import '../path/path.dart';
import '../tester/tester.dart';

///获取一个Class类型的数据信息，该类需满足一下条件
///(1)继承自类[BaseEvent]
///(2)构造器中的super中应包含[name]字段
///(3)[name]字段类型为简单字符串
class EventGetter extends Getter {
  List<EventUnit> units = [];

  @override
  void reset() {
    if (testerAccept<SuperNameRTester>()) {
      units.add(EventUnit(
        className: className,
        eventName: eventName,
        classParameters: classParameters,
        classParameterQuestions: classParameterQuestions,
        constructorParameters: constructorParameters,
      ));
    }
  }

  @override
  List<RetroTester> testers = [
    SuperNameRTester(
      superClass: 'BaseEvent',
      labelName: 'name',
    ),
    ClassParametersRTester(),
    ConstructorParametersRTester(),
  ];

  String get className => tester<SuperNameRTester>()
      .retroFirstNode<ClassDeclaration>()
      .name
      .toString();

  String get eventName => tester<SuperNameRTester>().firstNode.value;

  Map<String, String> get classParameters => Map.fromIterables(
        tester<ClassParametersRTester>()
            .firstList
            .map((e) => e.name.toString()),
        tester<ClassParametersRTester>()
            .retroFirstList<VariableDeclarationList>()
            .map((e) => e.type.toString().replaceAll('?', '')),
      );

  Map<String, bool> get classParameterQuestions => Map.fromIterables(
        tester<ClassParametersRTester>()
            .firstList
            .map((e) => e.name.toString()),
        tester<ClassParametersRTester>()
            .retroFirstList<VariableDeclarationList>()
            .map((e) => e.type?.question != null),
      );

  Map<String, bool> get constructorParameters => Map.fromIterables(
        tester<ConstructorParametersRTester>()
            .firstList
            .map((e) => e.name.toString()),
        tester<ConstructorParametersRTester>()
            .firstList
            .map((e) => e.isRequiredNamed || e.isNamed),
      );

  static bool mayTarget(String fileString) {
    return fileString.contains('super') &&
        fileString.contains('BaseEvent') &&
        fileString.contains('name');
  }
}

class EventUnit {
  final String className;
  final String eventName;

  ///构造器形参列表，{形参变量名：形参类型}
  final Map<String, String> classParameters;

  ///记录参数是否可以为空,{形参变量名: 是否可为空}
  final Map<String, bool> classParameterQuestions;

  ///构造器形参列表，{形参变量名:是否必须},
  ///bool类型代表是否[isRequiredNamed]
  final Map<String, bool> constructorParameters;

  EventUnit({
    required this.className,
    required this.eventName,
    required this.classParameters,
    required this.classParameterQuestions,
    required this.constructorParameters,
  });
}

Map<DartFile, List<EventUnit>> parseEvent() {
  List<DartFile> inputFilePath = getDartFiles(isTarget: EventGetter.mayTarget);
  Map<DartFile, List<EventUnit>> unitsMap = {};

  for (var file in inputFilePath) {
    var getter = EventGetter();
    MainAnalyzer(getters: [getter], filePath: file.filePath);
    unitsMap[file] = getter.units;
  }
  return unitsMap;
}
