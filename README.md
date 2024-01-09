## analyzer_x

基于对Dart语法的Ast分析，提取需求字段并自动生成代码

### 使用方法

```
//在测试环境中调用
main(){
    AnalyzerX.instance.generate();
}
```

### 调用关系

analyzer => tester => getter => gen

#### analyzer
通过dart提供的‘analyzer’插件，获取指定文件的Ast并进行遍历

#### tester
在tester中指明你需要的AstNode路径，当相应路径被访问时，tester会被调用

#### getter
集成复数个tester，获取需要用于代码生成的信息

#### gen
通过获取到的信息，构建生成代码


