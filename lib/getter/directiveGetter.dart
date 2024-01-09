import 'package:analyzer/dart/ast/ast.dart';

import '../base/getter.dart';
import '../base/retro_tester.dart';
import '../tester/tester.dart';

///获取一个dart文件中的[library]||[part]||[export]||[part_of]声明
class DirectiveGetter extends Getter {
  DirectiveUnit unit = DirectiveUnit();

  @override
  void reset() {
    unit.dLibrary = tester<DirectiveRTester>().dLibrary;
    unit.dPart = tester<DirectiveRTester>().dPart;
    unit.dExport = tester<DirectiveRTester>().dExport;
    unit.dPartOf = tester<DirectiveRTester>().dPartOf;
    super.reset();
  }

  @override
  List<RetroTester<AstNode>> testers = [
    DirectiveRTester(),
  ];
}

class DirectiveUnit{
  Set<String> dLibrary = {};
  Set<String> dPart = {};
  Set<String> dExport = {};
  Map<int, String> dPartOf = {};
}
