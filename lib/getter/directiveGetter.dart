import 'package:analyzer/dart/ast/ast.dart';

import '../base/getter.dart';
import '../base/retro_tester.dart';
import '../tester/tester.dart';

///获取一个dart文件中的[library]||[part]||[export]||[part_of]声明
class DirectiveGetter extends Getter {
  DirectiveUnit unit = DirectiveUnit();

  @override
  void reset() {
    unit.dLibrary.addAll(getLibraries());
    unit.dExport.addAll(getExports());
    unit.dPart.addAll(getParts());
    unit.dPartOfLibrary.addAll(getPartOfLibrary());
    unit.dPartOfUri.addAll(getPartOfUri());
  }

  @override
  List<RetroTester<AstNode>> testers = [
    DirectiveRTester(),
  ];

  List<String> getLibraries() => tester<DirectiveRTester>()
      .tList<LibraryDirective>()
      .map((e) => e.name2.toString())
      .toList();

  List<String> getParts() => tester<DirectiveRTester>()
      .tList<PartDirective>()
      .map((e) => e.uri.toString())
      .toList();

  List<String> getExports() => tester<DirectiveRTester>()
      .tList<ExportDirective>()
      .map((e) => e.uri.toString())
      .toList();

  List<String> getPartOfLibrary() => tester<DirectiveRTester>()
      .tList<PartOfDirective>()
      .map((e) => e.libraryName.toString())
      .toList();

  List<String> getPartOfUri() => tester<DirectiveRTester>()
      .tList<PartOfDirective>()
      .map((e) => e.uri.toString())
      .toList();
}

class DirectiveUnit {
  Set<String> dLibrary = {};
  Set<String> dPart = {};
  Set<String> dExport = {};
  Set<String> dPartOfLibrary = {};
  Set<String> dPartOfUri = {};
}
