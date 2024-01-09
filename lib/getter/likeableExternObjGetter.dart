import 'package:analyzer/dart/ast/ast.dart';

import '../base/base.dart';
import '../tester/tester.dart';

///获取一个dart文件中疑似是外部引入对象的名字，
///具体为[PrefixedIdentifier]||[NamedType]||[MethodInvocation]
class LikeableExternObjGetter extends Getter {
  List<String> ids = [];

  @override
  void reset() {
    ids = tester<MayExternRTester>().ids.toList();
    super.reset();
  }

  @override
  List<RetroTester<AstNode>> testers = [
    MayExternRTester(),
  ];
}
