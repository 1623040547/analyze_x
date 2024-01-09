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

  ///在每一次reset时重置为true，该变量用以记录每一个在路径上的节点是否被tester接收，
  ///当所有节点都不在teseter指定路径[RetroTester.path]上时，accept会为true
  bool accept = false;

  ///用于记录每一个[RetroTester]的接收情况
  @override
  Map<RetroTester, bool> accepts = {};

  ///获取某一个[RetroTester]的接收情况，当该tester未在路径上而未被记录时，返回false
  bool testerAccept<T>() => accepts[testers.whereType<T>().first] ?? false;

  ///记录特征节点，为所有[RetroTester.path]的并集
  List<AnalyzerStep> get patterns {
    Set<AnalyzerStep> steps = {};
    for (var tester in testers) {
      steps.addAll(tester.path);
    }
    return steps.toList();
  }

  ///触发器，当遍历到特征节点时的调用方法
  ///该函数首先通过[resetFlag]判断当前节点是否标志着getter需要重置
  ///需要重置：执行重置方法
  ///不需要重置：执行每一个tester的[inPath]与[accept]方法
  void trigger(node, AnalyzerStep step) {
    if (resetFlag(node, step)) {
      reset();
    }
    for (var tester in testers) {
      if (tester.inPath(node)) {
        accepts[tester] = tester.accept(node);
        accept &= accepts[tester]!;
      }
    }
  }

  ///指定重置条件，默认为类声明节点[ClassDeclaration]
  bool resetFlag(node, AnalyzerStep step) {
    return step == AnalyzerStep.classDeclaration;
  }

  ///重置函数，会重置[Getter]当前的接受状态
  ///如果在其上层需求需求获取数据并重置，可以覆盖此方法并调用[super.reset]
  void reset() {
    accept = true;
    accepts.clear();
    for (var tester in testers) {
      tester.reset();
    }
  }
}

abstract class Testers {
  List<RetroTester> testers = [];

  Map<RetroTester, bool> accepts = {};
}
