import 'package:analyzer/dart/ast/ast.dart';

///包含所有语法节点的枚举
enum AnalyzerStep {
  ///编译单元
  compilationUnit(_checker<CompilationUnit>),

  ///类声明
  classDeclaration(_checker<ClassDeclaration>),

  ///继承关键字及其继承对象
  extendsClause(_checker<ExtendsClause>),

  ///构造器声明
  constructorDeclaration(_checker<ConstructorDeclaration>),

  ///超级构造函数调用
  superConstructorInvocation(_checker<SuperConstructorInvocation>),

  ///参数列表
  argumentList(_checker<ArgumentList>),

  ///命名表达式
  namedExpression(_checker<NamedExpression>),

  ///标签
  label(_checker<Label>),

  ///简单字符串
  simpleStringLiteral(_checker<SimpleStringLiteral>),

  ///构造器名称
  constructorName(_checker<ConstructorName>),

  ///形式参数列表
  formalParameterList(_checker<FormalParameterList>),

  ///默认形式参数
  defaultFormalParameter(_checker<DefaultFormalParameter>),

  ///字段形式参数
  fieldFormalParameter(_checker<FieldFormalParameter>),

  ///字段声明
  fieldDeclaration(_checker<FieldDeclaration>),

  ///变量声明列表
  variableDeclarationList(_checker<VariableDeclarationList>),

  ///命名类型
  namedType(_checker<NamedType>),

  ///变量声明
  variableDeclaration(_checker<VariableDeclaration>),

  ///方法声明
  methodDeclaration(_checker<MethodDeclaration>),
  adjacentStrings(_checker<AdjacentStrings>),
  annotation(_checker<Annotation>),
  asExpression(_checker<AsExpression>),
  assertInitializer(_checker<AssertInitializer>),
  assertStatement(_checker<AssertStatement>),
  assignmentExpression(_checker<AssignmentExpression>),
  augmentationImportDirective(_checker<AugmentationImportDirective>),
  awaitExpression(_checker<AwaitExpression>),
  binaryExpression(_checker<BinaryExpression>),
  binaryPattern(_checker<BinaryPattern>),
  block(_checker<Block>),
  blockFunctionBody(_checker<BlockFunctionBody>),
  booleanLiteral(_checker<BooleanLiteral>),
  breakStatement(_checker<BreakStatement>),
  cascadeExpression(_checker<CascadeExpression>),
  caseClause(_checker<CaseClause>),
  castPattern(_checker<CastPattern>),
  catchClause(_checker<CatchClause>),
  catchClauseParameter(_checker<CatchClauseParameter>),
  classTypeAlias(_checker<ClassTypeAlias>),
  comment(_checker<Comment>),
  commentReference(_checker<CommentReference>),
  conditionalExpression(_checker<ConditionalExpression>),
  configuration(_checker<Configuration>),
  constantPattern(_checker<ConstantPattern>),
  constructorFieldInitializer(_checker<ConstructorFieldInitializer>),
  constructorReference(_checker<ConstructorReference>),
  constructorSelector(_checker<ConstructorSelector>),
  continueStatement(_checker<ContinueStatement>),
  declaredIdentifier(_checker<DeclaredIdentifier>),
  doStatement(_checker<DoStatement>),
  dottedName(_checker<DottedName>),
  doubleLiteral(_checker<DoubleLiteral>),
  emptyFunctionBody(_checker<EmptyFunctionBody>),
  emptyStatement(_checker<EmptyStatement>),
  enumConstantArguments(_checker<EnumConstantArguments>),
  enumConstantDeclaration(_checker<EnumConstantDeclaration>),
  enumDeclaration(_checker<EnumDeclaration>),
  exportDirective(_checker<ExportDirective>),
  expressionFunctionBody(_checker<ExpressionFunctionBody>),
  expressionStatement(_checker<ExpressionStatement>),
  extensionDeclaration(_checker<ExtensionDeclaration>),
  extensionOverride(_checker<ExtensionOverride>),
  extractorPattern(_checker<ExtractorPattern>),
  forEachPartsWithDeclaration(_checker<ForEachPartsWithDeclaration>),
  forEachPartsWithIdentifier(_checker<ForEachPartsWithIdentifier>),
  forEachPartsWithPattern(_checker<ForEachPartsWithPattern>),
  forElement(_checker<ForElement>),
  forPartsWithDeclarations(_checker<ForPartsWithDeclarations>),
  forPartsWithExpression(_checker<ForPartsWithExpression>),
  forPartsWithPattern(_checker<ForPartsWithPattern>),
  forStatement(_checker<ForStatement>),
  functionDeclaration(_checker<FunctionDeclaration>),
  functionDeclarationStatement(_checker<FunctionDeclarationStatement>),
  functionExpression(_checker<FunctionExpression>),
  functionExpressionInvocation(_checker<FunctionExpressionInvocation>),
  functionReference(_checker<FunctionReference>),
  functionTypeAlias(_checker<FunctionTypeAlias>),
  functionTypedFormalParameter(_checker<FunctionTypedFormalParameter>),
  genericFunctionType(_checker<GenericFunctionType>),
  genericTypeAlias(_checker<GenericTypeAlias>),
  hideClause(_checker<HideClause>),
  hideCombinator(_checker<HideCombinator>),
  ifElement(_checker<IfElement>),
  ifStatement(_checker<IfStatement>),
  implementsClause(_checker<ImplementsClause>),
  implicitCallReference(_checker<ImplicitCallReference>),
  importDirective(_checker<ImportDirective>),
  indexExpression(_checker<IndexExpression>),
  instanceCreationExpression(_checker<InstanceCreationExpression>),
  integerLiteral(_checker<IntegerLiteral>),
  interpolationExpression(_checker<InterpolationExpression>),
  interpolationString(_checker<InterpolationString>),
  isExpression(_checker<IsExpression>),
  labeledStatement(_checker<LabeledStatement>),
  libraryAugmentationDirective(_checker<LibraryAugmentationDirective>),
  libraryDirective(_checker<LibraryDirective>),
  libraryIdentifier(_checker<LibraryIdentifier>),
  listLiteral(_checker<ListLiteral>),
  listPattern(_checker<ListPattern>),
  mapLiteralEntry(_checker<MapLiteralEntry>),
  mapPattern(_checker<MapPattern>),
  mapPatternEntry(_checker<MapPatternEntry>),
  methodInvocation(_checker<MethodInvocation>),
  mixinDeclaration(_checker<MixinDeclaration>),
  nativeClause(_checker<NativeClause>),
  nativeFunctionBody(_checker<NativeFunctionBody>),
  nullLiteral(_checker<NullLiteral>),
  onClause(_checker<OnClause>),
  parenthesizedExpression(_checker<ParenthesizedExpression>),
  parenthesizedPattern(_checker<ParenthesizedPattern>),
  partDirective(_checker<PartDirective>),
  partOfDirective(_checker<PartOfDirective>),
  patternAssignment(_checker<PatternAssignment>),
  patternAssignmentStatement(_checker<PatternAssignmentStatement>),
  patternVariableDeclaration(_checker<PatternVariableDeclaration>),
  patternVariableDeclarationStatement(
      _checker<PatternVariableDeclarationStatement>),
  postfixExpression(_checker<PostfixExpression>),
  postfixPattern(_checker<PostfixPattern>),
  prefixedIdentifier(_checker<PrefixedIdentifier>),
  prefixExpression(_checker<PrefixExpression>),
  propertyAccess(_checker<PropertyAccess>),
  recordLiteral(_checker<RecordLiteral>),
  recordPattern(_checker<RecordPattern>),
  recordPatternField(_checker<RecordPatternField>),
  recordPatternFieldName(_checker<RecordPatternFieldName>),
  recordTypeAnnotation(_checker<RecordTypeAnnotation>),
  recordTypeAnnotationNamedField(_checker<RecordTypeAnnotationNamedField>),
  recordTypeAnnotationNamedFields(_checker<RecordTypeAnnotationNamedFields>),
  recordTypeAnnotationPositionalField(
      _checker<RecordTypeAnnotationPositionalField>),
  redirectingConstructorInvocation(_checker<RedirectingConstructorInvocation>),
  relationalPattern(_checker<RelationalPattern>),
  rethrowExpression(_checker<RethrowExpression>),
  returnStatement(_checker<ReturnStatement>),
  scriptTag(_checker<ScriptTag>),
  setOrMapLiteral(_checker<SetOrMapLiteral>),
  showClause(_checker<ShowClause>),
  showCombinator(_checker<ShowCombinator>),
  showHideElement(_checker<ShowHideElement>),
  simpleFormalParameter(_checker<SimpleFormalParameter>),
  simpleIdentifier(_checker<SimpleIdentifier>),
  spreadElement(_checker<SpreadElement>),
  stringInterpolation(_checker<StringInterpolation>),
  superExpression(_checker<SuperExpression>),
  superFormalParameter(_checker<SuperFormalParameter>),
  switchCase(_checker<SwitchCase>),
  switchDefault(_checker<SwitchDefault>),
  switchExpression(_checker<SwitchExpression>),
  switchExpressionCase(_checker<SwitchExpressionCase>),
  switchExpressionDefault(_checker<SwitchExpressionDefault>),
  switchPatternCase(_checker<SwitchPatternCase>),
  switchStatement(_checker<SwitchStatement>),
  symbolLiteral(_checker<SymbolLiteral>),
  thisExpression(_checker<ThisExpression>),
  throwExpression(_checker<ThrowExpression>),
  topLevelVariableDeclaration(_checker<TopLevelVariableDeclaration>),
  tryStatement(_checker<TryStatement>),
  typeArgumentList(_checker<TypeArgumentList>),
  typeLiteral(_checker<TypeLiteral>),
  typeParameter(_checker<TypeParameter>),
  typeParameterList(_checker<TypeParameterList>),
  variableDeclarationStatement(_checker<VariableDeclarationStatement>),
  variablePattern(_checker<VariablePattern>),
  whenClause(_checker<WhenClause>),
  whileStatement(_checker<WhileStatement>),
  withClause(_checker<WithClause>),
  yieldStatement(_checker<YieldStatement>);

  final bool Function(dynamic obj) typeChecker;

  const AnalyzerStep(this.typeChecker);
}

bool _checker<T>(dynamic obj) => obj is T;
