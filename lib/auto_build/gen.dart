import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer_x/base/log.dart';
import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';

import 'package:analyzer_x/analyzer_x.dart';
import 'auto.dart';

class AutoGenerator extends GeneratorForAnnotation<AutoPath> {
  @override
  generateForAnnotatedElement(
      Element element, ConstantReader annotation, BuildStep buildStep) async {
    String buildMsg = '';
    try {
      AnalyzerX.instance.generate();
      buildMsg = 'Build Success';
    } catch (e) {
      buildMsg = '$e';
    }
    analyzerLog(buildMsg);
    return '';
  }
}
