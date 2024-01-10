import 'package:analyzer/dart/ast/ast.dart';

import '../base/getter.dart';
import '../base/retro_tester.dart';
import '../base/step.dart';
import '../tester/tester.dart';

///获取一个dart文件中的[library]||[part]||[export]||[part_of]声明
class DirectiveGetter extends Getter {
  DirectiveUnit unit = DirectiveUnit();

  @override
  void reset() {
    unit.dLibrary.addAll(getLibraries() ?? []);
    unit.dExport.addAll(getExports() ?? []);
    unit.dPart.addAll(getParts() ?? []);
    unit.dPartOfLibrary.addAll(getPartOfLibrary() ?? []);
    unit.dPartOfUri.addAll(getPartOfUri() ?? []);
  }

  @override
  List<RetroTester<AstNode>> testers = [
    DirectiveRTester(),
  ];

  List<String>? getLibraries() => tester<DirectiveRTester>()
      .nodes[AnalyzerStep.libraryDirective]
      ?.map((node) => (node as LibraryDirective).name2.toString())
      .toList();

  List<String>? getParts() => tester<DirectiveRTester>()
      .nodes[AnalyzerStep.partDirective]
      ?.map((node) => (node as PartDirective).uri.toString())
      .toList();

  List<String>? getExports() => tester<DirectiveRTester>()
      .nodes[AnalyzerStep.exportDirective]
      ?.map((node) => (node as ExportDirective).uri.toString())
      .toList();

  List<String>? getPartOfLibrary() => tester<DirectiveRTester>()
      .nodes[AnalyzerStep.partOfDirective]
      ?.map((node) => (node as PartOfDirective).libraryName.toString())
      .toList();

  List<String>? getPartOfUri() => tester<DirectiveRTester>()
      .nodes[AnalyzerStep.partOfDirective]
      ?.map((node) => (node as PartOfDirective).uri.toString())
      .toList();
}

class DirectiveUnit{
  Set<String> dLibrary = {};
  Set<String> dPart = {};
  Set<String> dExport = {};
  Set<String> dPartOfLibrary = {};
  Set<String> dPartOfUri = {};
}
