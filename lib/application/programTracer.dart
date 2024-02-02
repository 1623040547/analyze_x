import 'dart:io';
import '../base/analyzer.dart';
import '../getter/methodGetter.dart';
import '../path/path.dart';

class ProgramTracer {
  static List<int> paths = [];

  static String importName =
      "import 'package:analyzer_x/application/programTracer.dart';\n";

  static String dictPath =
      "/Users/qingdu/StudioProjects/my_healer/plugin/analyzer_helper/test/function.dict";

  static String logPath =
      "/Users/qingdu/StudioProjects/my_healer/plugin/analyzer_helper/test/log.txt";

  static String fileName = "programTracer.dart";

  static trace(int id) {
    paths.add(id);
    if (paths.length == 2000) {
      String text = File(logPath).readAsStringSync();
      File(logPath).writeAsString(text + paths.join(' '));
      paths.removeRange(0, 2001);
    }
  }

  static inject() {
    Map<DartFile, MethodGetter> getters = _genDict();
    for (DartFile file in getters.keys) {
      if (getters[file]!.units.isNotEmpty) {
        String newText = _traceInject(
            File(file.filePath).readAsStringSync(), getters[file]!.units);
        newText = _importInject(newText);
        var f = File(file.filePath);
        f.writeAsString(newText);
      }
    }
  }

  static _importInject(String text) {
    return importName + text;
  }

  static _traceInject(String text, List<MethodUnit> units) {
    Map<String, String> injectMap = {};
    for (MethodUnit unit in units) {
      String theOld = text.substring(unit.blockStart, unit.end);
      String theNew =
          theOld.replaceFirst('{', "{ ProgramTracer.trace(${unit.id});");
      injectMap[theOld] = theNew;
    }
    injectMap.forEach((key, value) {
      text = text.replaceAll(key, value);
    });
    return text;
  }

  static reject() {
    Map<DartFile, MethodGetter> getters = _genDict();
    for (DartFile file in getters.keys) {
      if (getters[file]!.units.isNotEmpty) {
        String newText = _traceReject(
            File(file.filePath).readAsStringSync(), getters[file]!.units);
        newText = _importReject(newText);
      }
    }
  }

  static _traceReject(String text, List<MethodUnit> units) {
    var reg = RegExp(r'ProgramTracer.trace\([^)]*\);');
    return text.replaceAll(reg, '');
  }

  static _importReject(String text) {
    return text.replaceAll(importName, '');
  }

  static _genDict() {
    Map<DartFile, MethodGetter> getters = {};
    int count = 0;
    String text = "";
    File dict = File(
      dictPath,
    );
    for (DartFile file in getDartFiles()) {
      ///过滤
      if (file.importName.contains('.g.dart') ||
          file.importName.contains('.freezed.dart') ||
          file.importName.contains(fileName) ||
          !file.package.isMainProj) {
        continue;
      }
      var getter = MethodGetter();
      MainAnalyzer(
        getters: [getter],
        filePath: file.filePath,
      );
      getters[file] = getter;
      for (var unit in getter.units) {
        text += "$count,${unit.className},${unit.method}\n";
        unit.id = count;
        count += 1;
      }
    }
    dict.create();
    dict.writeAsString(text);
    return getters;
  }
}
