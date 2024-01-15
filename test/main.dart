import 'dart:async';
import 'dart:io';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer_x/application/auto_import/directiveMap.dart';
import 'package:analyzer_x/base/base.dart';
import 'package:analyzer_x/getter/directiveGetterX.dart';
import 'package:analyzer_x/path/path.dart';

Map<Package, Map<DartFile, DirectiveXData>> map = {};
Map<String, DartFile> librariesFile = {};

///type alias
///typedef ComplexFunction = void Function(int a, {required bool b});
///class alias
///typedef StringGenericClass = GenericClass<String>;
///function alias
///typedef Compare<T> = int Function(T a, T b);

Future<void> main() async {
  print(DateTime.now());
  DirectiveMap.instance.analyze();
  // MainAnalyzer(
  //   filePath: '/Users/qingdu/StudioProjects/analyzer_x/test/main.dart',
  //   getters: [getter1, getter2],
  // );
  //
  // print(getter2.data.classDec);
  // print(getter2.data.classTypeAliasDec);
  // print(getter2.data.enumDec);
  // print(getter2.data.extensionDec);
  // print(getter2.data.functionDec);
  // print(getter2.data.functionTypeAliasDec);
  // print(getter2.data.genericTypeAliasDec);
  // print(getter2.data.mixinDec);
  // print(getter2.data.topVariableDec);
  //
  // print(getter1.data.libraryId);
  // print(getter1.data.prefixId);
  // print(getter1.data.simpleId);
  // print(getter1.data.namedType);
  // getDartFiles().forEach((file) {
  //   MainAnalyzer(
  //     filePath: file.filePath,
  //     getters: [getterX],
  //   );
  //   if (map[file.package] == null) {
  //     map[file.package] = {};
  //   }
  //   map[file.package]![file] = getterX.data;
  //   if (getterX.data.libraryData?.library != null) {
  //     librariesFile[getterX.data.libraryData!.library!] = file;
  //   }
  //   getterX.data = DirectiveXData();
  // });
  // getDartFiles().forEach((file) {
  //   directivePathGen(file, map[file.package]![file]!);
  // });
  print(DateTime.now());
  print(map.values.length);
}

void directivePathGen(DartFile file, DirectiveXData data) {
  data.importData.forEach((importData) {
    DirectivePath path = importData.path!;
    if (path.isAbsolutePath) {
      path.filePath = path.origin;
    } else if (path.isRelativePath) {
      ///[./path/to/file] => [path/to/file] || [(../)+path/to/file]
      String dirPath = File(file.filePath).parent.path;
      String relatePath = Uri.parse(path.origin).toFilePath();
      if (!relatePath.contains('../')) {
        path.filePath = dirPath + Platform.pathSeparator + relatePath;
      } else {
        int retroCount = relatePath.split('../').length - 1;
        Directory dir = File(file.filePath).parent;
        for (int i = 0; i < retroCount; i++) {
          dir = dir.parent;
        }
        path.filePath = dir.path +
            Platform.pathSeparator +
            relatePath.replaceAll('../', '');
      }
    } else if (path.isPackage) {
      String packageName =
          Uri.parse(path.origin.replaceAll('package:', '')).pathSegments.first;
      Package package =
          map.keys.firstWhere((element) => element.name == packageName);
      file = map[package]!
          .keys
          .firstWhere((element) => element.importName == path.origin);
      path.filePath = file.filePath;
    } else if (path.isDart) {
      try {
        String library = path.origin.replaceAll('dart:', '');
        librariesFile.keys.forEach((element) {
          if (element.split('.').first == 'dart' &&
              element.split('.').last == library) {
            path.filePath = librariesFile[element]!.filePath;
          }
        });
      } catch (e) {
        print('invalid dart import: ${path.origin}');
        path.filePath = '';
      }
    }
    path.filePath = path.filePath.replaceAll('/', Platform.pathSeparator);
  });
}

class SimpleIdGetter extends Getter {
  @override
  List<RetroTester<AstNode>> testers = [SimpleIdRetroTester()];

  @override
  void reset() {
    tester<SimpleIdRetroTester>()
        .nodes[AnalyzerStep.simpleIdentifier]!
        .forEach((element) {
      SimpleIdentifier node = (element as SimpleIdentifier);
      print('${node.name}: ${node.isQualified} ${node.inDeclarationContext()}');
    });
    tester<SimpleIdRetroTester>()
        .nodes[AnalyzerStep.namedType]!
        .forEach((element) {
      NamedType node = (element as NamedType);
      print('${node.name2}:');
    });
  }
}

class SimpleIdRetroTester extends SimpleRetroTester {
  @override
  List<AnalyzerStep> get path => [
        AnalyzerStep.simpleIdentifier,
        AnalyzerStep.namedType,
      ];
}
