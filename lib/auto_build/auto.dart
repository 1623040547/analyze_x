
///借由此注解，绑定build_runner自动生成代码
class AutoPath {
  final String path;

  const AutoPath({this.path = ''});
}

@AutoPath()
class AutoPathInstance {}
