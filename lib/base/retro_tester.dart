import 'package:analyzer/dart/ast/ast.dart';
import 'step.dart';

///[AstNode]路径检测器,
///Retro代表回溯，因此指定路径时应当遵循从[叶子结点]=>[根结点]
abstract class RetroTester<T extends AstNode> {
  List<AnalyzerStep> get path;

  ///当前节点在路径上
  bool inPath(node) {
    if (node is T) {
      int state = 0;
      dynamic parent = node;
      while (parent != null) {
        if (path[state].typeChecker(parent)) {
          state += 1;
        }
        if (state == path.length) {
          break;
        }
        parent = parent.parent;
      }
      return state == path.length;
    }
    return false;
  }

  ///从当前结点出发，回溯获取指定类型的父节点
  ///当指定类型不存在时会抛出异常[assert(parent != null)]
  R retroNode<R>(node) {
    dynamic parent = node;
    while (parent != null) {
      if (parent is R) {
        return parent;
      }
      parent = parent.parent;
    }
    assert(parent != null);
    return node;
  }

  bool accept(T node);

  void reset();
}

///部分Tester并非需求[path]为一条路径
///继承此抽象类，将[path]转换为[set]，
///每一个在[path]上的节点调用[inPath]均返回true
abstract class SimpleRetroTester extends RetroTester {
  @override
  List<AnalyzerStep> get path;

  @override
  bool inPath(node) {
    return true;
  }

  @override
  R retroNode<R>(node) {
    dynamic parent = node;
    while (parent != null) {
      if (parent is R) {
        return parent;
      }
      parent = parent.parent;
    }
    assert(parent != null);
    return node;
  }

  @override
  bool accept(node);

  @override
  void reset() {}
}
