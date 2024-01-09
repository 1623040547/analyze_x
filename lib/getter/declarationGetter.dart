import 'package:analyzer/dart/ast/ast.dart';

import '../base/base.dart';
import '../tester/tester.dart';

///获取一个dart文件中的[Class]||[Enum]||[Function] 声明
class DeclarationGetter extends Getter {
  DeclarationUnit unit = DeclarationUnit();

  @override
  void reset() {
    unit.dClass = tester<DeclarationRTester>().dClass.toList();
    unit.dFunction = tester<DeclarationRTester>().dFunction.toList();
    unit.dEnum = tester<DeclarationRTester>().dEnum.toList();
    super.reset();
  }

  @override
  List<RetroTester<AstNode>> testers = [
    DeclarationRTester(),
  ];
}

class DeclarationUnit {
  List<String> dClass = [];
  List<String> dFunction = [];
  List<String> dEnum = [];
}
