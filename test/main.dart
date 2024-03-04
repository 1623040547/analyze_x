import 'dart:async';
import 'package:analyzer_x/application/eventToJson.dart';
import 'package:analyzer_x/application/gitAnalyzer.dart';

Future<void> main() async {
  //代码自动生成
  //AnalyzerX.instance.generate();
  //程序打桩插入
  //ProgramTracer.inject();
  //程序打桩取出
  // ProgramTracer.reject();
  //ProgramTracer.createProgramStream();
  // ParamGetter getter = ParamGetter();
  // var files = getDartFiles();
  // for (var file in files) {
  //   MainAnalyzer(getters: [getter], filePath: file.filePath);
  // }
  //  EventToJson.toJson();
   GitAnalyzer.instance.gitLog();
}
