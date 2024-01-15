import 'package:analyzer/src/dart/ast/ast.dart';
import 'package:analyzer_x/base/base.dart';
import 'package:analyzer_x/path/path.dart';

import '../tester/tester.dart';

class DirectiveGetterX extends Getter {
  DirectiveXData data = DirectiveXData();

  @override
  List<RetroTester<AstNode>> testers = [DirectiveRTester()];

  @override
  void reset() {
    if (getLibraries().isNotEmpty) {
      data.libraryData = LibraryData(getLibraries().first);
    }
    if (getPartOf().isNotEmpty) {
      data.partOfData = PartOfData(getPartOf().first);
    }
    data.partData.addAll(getParts().map((e) => PartData(e)));
    data.exportData.addAll(getExports().map((e) => ExportData(e)));
    data.importData.addAll(getImport().map((e) => ImportData(e)));
  }

  List<LibraryDirective> getLibraries() =>
      tester<DirectiveRTester>().tList<LibraryDirective>();

  List<PartDirective> getParts() =>
      tester<DirectiveRTester>().tList<PartDirective>();

  List<ExportDirective> getExports() =>
      tester<DirectiveRTester>().tList<ExportDirective>();

  List<PartOfDirective> getPartOf() =>
      tester<DirectiveRTester>().tList<PartOfDirective>();

  List<ImportDirective> getImport() =>
      tester<DirectiveRTester>().tList<ImportDirective>();
}

class DirectiveXData {
  LibraryData? libraryData;
  PartOfData? partOfData;
  List<ImportData> importData = [];
  List<PartData> partData = [];
  List<ExportData> exportData = [];

  dynamic data;
}

class ImportData {
  DirectivePath? path;
  List<String> showIds = [];
  List<String> hideIds = [];
  String? asId;
  String? deferredAsId;

  ImportData(ImportDirective importDirective) {
    path = DirectivePath(importDirective.uri.stringValue!);
    for (var e in importDirective.combinators) {
      if (e.keyword.toString() == 'show') {
        for (var name in (e as ShowCombinator).shownNames) {
          hideIds.add(name.name);
        }
      } else if (e.keyword.toString() == 'hide') {
        for (var name in (e as HideCombinator).hiddenNames) {
          hideIds.add(name.name);
        }
      }
    }
    if (importDirective.asKeyword != null) {
      asId = importDirective.prefix!.name;
    }
    if (importDirective.deferredKeyword != null) {
      deferredAsId = importDirective.prefix!.name;
    }
  }
}

class PartData {
  DirectivePath? path;

  PartData(PartDirective partDirective) {
    path = DirectivePath(partDirective.uri.stringValue!);
  }
}

class PartOfData {
  String? library;
  DirectivePath? path;

  PartOfData(PartOfDirective partOfDirective) {
    library = partOfDirective.libraryName?.name ?? '';
    if (partOfDirective.uri != null) {
      path = DirectivePath(partOfDirective.uri!.stringValue!);
    }
  }
}

class LibraryData {
  String? library;

  LibraryData(LibraryDirective libraryDirective) {
    library = libraryDirective.name2?.name;
  }
}

class ExportData {
  DirectivePath? path;
  List<String> showIds = [];
  List<String> hideIds = [];

  ExportData(ExportDirective exportDirective) {
    path = DirectivePath(exportDirective.uri.stringValue!);
    for (var e in exportDirective.combinators) {
      if (e.keyword.toString() == 'show') {
        for (var name in (e as ShowCombinator).shownNames) {
          hideIds.add(name.name);
        }
      } else if (e.keyword.toString() == 'hide') {
        for (var name in (e as HideCombinator).hiddenNames) {
          hideIds.add(name.name);
        }
      }
    }
  }
}

class DirectivePath {
  final String origin;

  String filePath = '';

  DartFile? file;

  bool get isDart => origin.contains('dart:');

  bool get isPackage => origin.contains('package:');

  bool get isAbsolutePath =>
      !isPackage && !isDart && Uri.parse(origin).isAbsolute;

  bool get isRelativePath =>
      !isPackage && !isDart && !Uri.parse(origin).isAbsolute;

  DirectivePath(this.origin);
}
