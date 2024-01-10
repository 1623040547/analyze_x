import 'package:analyzer/dart/ast/ast.dart';
import 'step.dart';

///[AstNode]路径检测器,
///Retro代表回溯，因此指定路径时应当遵循从[叶子结点]=>[根结点]
abstract class RetroTester<T extends AstNode> {
  List<AnalyzerStep> get path;

  ///收集符合需求的节点，在类[RetroTester]中，它们一定是类型[T]
  final List<AstNode> _nodes = [];

  ///对于符合需求的节点
  ///它们的类型一定通过[path]中[AnalyzerStep.typeChecker]
  Map<AnalyzerStep, List<AstNode>> get nodes {
    Map<AnalyzerStep, List<AstNode>> map = {}
      ..addEntries(path.map((e) => MapEntry(e, [])));
    for (var node in _nodes) {
      AnalyzerStep step = path.firstWhere((s) => s.typeChecker(node));
      map[step]!.add(node);
    }
    return map;
  }

  T get firstNode => _nodes.first as T;

  List<T> get firstList => _nodes.map((e) => e as T).toList();

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

      ///当一个节点位于路径上并且被接受，将其加入
      if (state == path.length && accept(node)) {
        _nodes.add(node);
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

  R retroFirstNode<R>() {
    return retroNode<R>(firstNode);
  }

  List<R> retroFirstList<R>() {
    return firstList.map((e) => retroNode<R>(e)).toList();
  }

  bool accept(T node);

  void reset() {
    _nodes.clear();
  }
}

///部分Tester并非需求[path]为一条路径
///继承此抽象类，将[path]转换为[set]，
///每一个在[path]上的节点调用[inPath]均返回true
abstract class SimpleRetroTester extends RetroTester {
  @override
  List<AnalyzerStep> get path;

  @override
  bool inPath(node) {
    if (path.where((element) => element.typeChecker(node)).isNotEmpty) {
      _nodes.add(node);
      return true;
    }
    return false;
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
  bool accept(node) {
    return true;
  }

  @override
  get firstNode => throw UnimplementedError();

  @override
  get firstList => throw UnimplementedError();

  @override
  R retroFirstNode<R>() => throw UnimplementedError();

  @override
  List<R> retroFirstList<R>() => throw UnimplementedError();
}
