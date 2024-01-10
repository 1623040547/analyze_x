
///借由此注解，绑定build_runner自动生成代码
class AnalyzerXAutoBuild {
  final String path;

  const AnalyzerXAutoBuild({this.path = ''});
}

@AnalyzerXAutoBuild()
class AutoPathInstance {}
