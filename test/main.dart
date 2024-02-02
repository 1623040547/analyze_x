import 'dart:async';
import 'package:analyzer_x/application/programTracer.dart';

Future<void> main() async {
  //代码自动生成
  //AnalyzerX.instance.generate();
  //程序打桩注入
  ProgramTracer.inject();
}
