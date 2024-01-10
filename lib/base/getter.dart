import 'retro_tester.dart';
import 'step.dart';

///用于从[MainAnalyzer]中获取数据信息
///数据分别存储在每一个[RetroTester]中
abstract class Getter implements Testers {
  Getter();

  T tester<T>() {
    assert(testers.whereType<T>().length == 1);
    return testers.whereType<T>().first;
  }

  ///用于记录每一个[RetroTester]的接收情况
  final Map<RetroTester, bool> _accepts = {};

  ///获取某一个[RetroTester]的接收情况，当该tester未在路径上而未被记录时，返回false
  bool testerAccept<T>() => _accepts[testers.whereType<T>().first] ?? false;

  ///记录特征节点，为所有[RetroTester.path]的并集
  List<AnalyzerStep> get patterns {
    Set<AnalyzerStep> steps = {};
    for (var tester in testers) {
      steps.addAll(tester.path);
    }
    steps.add(AnalyzerStep.classDeclaration);
    return steps.toList();
  }

  ///触发器，当遍历到特征节点时的调用方法
  ///该函数首先通过[resetFlag]判断当前节点是否标志着getter需要重置
  ///需要重置：执行重置方法
  ///不需要重置：执行每一个tester的[inPath]与[accept]方法
  void trigger(node, AnalyzerStep step) {
    if (resetFlag(node, step)) {
      _reset();
    }
    for (var tester in testers) {
      if (tester.inPath(node)) {
        _accepts[tester] = tester.accept(node);
      }
    }
  }

  ///指定重置条件，默认为类声明节点[ClassDeclaration]
  bool resetFlag(node, AnalyzerStep step) {
    return step == AnalyzerStep.classDeclaration;
  }

  void _reset() {
    reset();
    _accepts.clear();
    for (var tester in testers) {
      tester.reset();
    }
  }

  ///重置函数，会重置[Getter]当前的接受状态
  void reset();
}

abstract class Testers {
  List<RetroTester> testers = [];
}
