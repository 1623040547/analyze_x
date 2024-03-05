import 'dart:io';

import 'package:analyzer_x/base/log.dart';
import 'package:dart_style/dart_style.dart';

import '../../getter/eventGetter.dart';
import '../../path/path.dart';
import 'importGen.dart';

class EventFactoryGen {
  final List<String> importFiles = [];
  final String typeOneMethod = '_whereTypeOne';
  final String typeOneOrNullMethod = '_whereTypeOneOrNull';
  final String onCheckFailMethod = 'onEventCheckFail';

  EventFactoryGen();

  void execute() {
    analyzerLog(DateTime.now());
    analyzerLog('parse event');
    Map<DartFile, List<EventUnit>> units = parseEvent();

    assert(units.values.expand((e) => e).toList().isNotEmpty);

    ///生成代码
    String fileString = classBlock(
      methods: [
        fromMethod(
          units.values.expand((e) => e).toList(),
        ),
        whereTypeOneMethod(),
        whereTypeOneOrNullMethod(),
        onEventCheckFailMethod(),
      ],
    );

    ///自动引入
    analyzerLog(DateTime.now());
    analyzerLog('auto import');
    importFiles.clear();
    importFiles.addAll(ImportGen.instance.analyse(fileString));
    fileString = dartFile(header: header(), classBlock: [fileString]);

    ///代码格式化
    DartFormatter formatter = DartFormatter(indent: 0);
    String code = formatter.format(fileString);

    ///设置生成[EventUnit]最多的文件为输出文件
    DartFile? outFile;
    int count = 0;
    units.forEach((key, value) {
      if (value.length > count) {
        outFile = key;
        count = value.length;
      }
    });
    File(outFile!.filePath.replaceAll('.dart', '.g.dart')).writeAsString(code);
    analyzerLog(DateTime.now());
    analyzerLog(
        'EventFactoryGen: ${outFile!.importName.replaceAll('.dart', '.g.dart')}');
  }

  String header() {
    return """
    // GENERATED CODE - DO NOT MODIFY BY HAND

    // **************************************************************************
    // $EventFactoryGen
    // **************************************************************************

    ${importFiles.join()}

    """;
  }

  String dartFile({required header, required List<String> classBlock}) {
    return """
    $header
    ${classBlock.join()}
    """;
  }

  String classBlock({required List<String> methods}) {
    return """
    abstract class ProtoEventFactory {
      ${methods.join()}
    }
    """;
  }

  String whereTypeOneMethod() {
    return """
    T $typeOneMethod<T>(List<BaseParam> params) {
      assert(params.whereType<T>().length == 1);
      T e = params.whereType<T>().first;
      params.remove(e);
      return e;
    }
    """;
  }

  String whereTypeOneOrNullMethod() {
    return """
    T? $typeOneOrNullMethod<T>(List<BaseParam> params) {
      assert(params.whereType<T>().length <= 1);
      if (params.whereType<T>().isEmpty) {
        return null;
      }
      T e = params.whereType<T>().first;
      params.remove(e);
      return e;
    }
    """;
  }

  String onEventCheckFailMethod() {
    return """
    void $onCheckFailMethod(String name, List<BaseParam> params, Object error);
    """;
  }

  String fromMethod(List<EventUnit> units) {
    return """
    BaseEvent from(String name, List<BaseParam> params) {
      BaseEvent? event;
      List<BaseParam> origin = params;
      params = params.toList();
      try {
        switch (name) {
        ${caseParts(units).join()}
          default:
              break;
        }
      }
      catch(error){
        $onCheckFailMethod(name,params,error);
      }
      event?.additionParams.addAll(params);
      return event ?? GeneralEvent(name: name, parameters: origin);
    }
    """;
  }

  List<String> caseParts(List<EventUnit> units) {
    String paramDefine(String parameter, EventUnit unit) {
      String method = unit.classParameterQuestions[parameter] == true
          ? typeOneOrNullMethod
          : typeOneMethod;
      if (unit.constructorParameters[parameter] == true) {
        return "$parameter: $method<${unit.classParameters[parameter]}>(params),";
      } else {
        return "$method<${unit.classParameters[parameter]}>(params),";
      }
    }

    String casePart(EventUnit unit) {
      List<String> params = unit.constructorParameters.keys
          .map((e) => paramDefine(e, unit))
          .toList();
      return """
        case '${unit.eventName}':
          event = ${unit.className}(
              ${params.join()}
          );
          break;
      """;
    }

    return units.map((e) => casePart(e)).toList();
  }
}
