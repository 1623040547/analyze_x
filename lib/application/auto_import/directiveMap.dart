import 'dart:io';

import 'package:analyzer_x/getter/directiveGetterX.dart';
import 'package:analyzer_x/path/path.dart';

import '../../base/analyzer.dart';

class DirectiveMap {
  Map<Package, Map<DartFile, DirectiveXData>> map = {};
  Map<String, DartFile> librariesFile = {};

  static DirectiveMap? _instance;

  static DirectiveMap get instance => _instance ??= DirectiveMap();

  void analyze() {
    DirectiveGetterX getterX = DirectiveGetterX();
    getDartFiles().forEach((file) {
      MainAnalyzer(
        filePath: file.filePath,
        getters: [
          getterX,
        ],
      );
      if (map[file.package] == null) {
        map[file.package] = {};
      }
      map[file.package]![file] = getterX.data;
      if (getterX.data.libraryData?.library != null) {
        librariesFile[getterX.data.libraryData!.library!] = file;
      }
      getterX.data = DirectiveXData();
    });
    getDartFiles().forEach((file) {
      directivePathGen(file, map[file.package]![file]!);
    });
  }

  ///为所有directive赋予其所在文件的绝对路径
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
        String packageName = Uri.parse(path.origin.replaceAll('package:', ''))
            .pathSegments
            .first;
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
      path.file = getDartFiles().firstWhere((e) => e.filePath == path.origin);
    });
  }
}
