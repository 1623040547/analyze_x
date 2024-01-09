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
    if (accept && testerAccept<SuperNameRTester>()) {
      units.add(EventUnit(
        className: tester<SuperNameRTester>().className,
        eventName: tester<SuperNameRTester>().labelStringValue,
        classParameters: tester<ClassParametersRTester>().classParameters,
        classParameterQuestions:
            tester<ClassParametersRTester>().classParameterQuestions,
        constructorParameters:
            tester<ConstructorParametersRTester>().constructorParameters,
      ));
    }
    super.reset();
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
