import 'dart:io';

import 'package:intl/intl.dart';

import '../path/package.dart';

class GitAnalyzer {
  List<BranchHistory> histories = [];

  static GitAnalyzer? _instance;

  static GitAnalyzer get instance => _instance ??= GitAnalyzer();

  gitLog() {
    _processLog();
    _processTag();
  }

  _processLog() {
    ProcessResult logs = Process.runSync('git', ['log'],
        workingDirectory: PackageConfig.projPath);
    List<String> slices = logs.stdout.toString().split('\n');
    BranchHistory? h;
    for (var s in slices) {
      if (s.startsWith('commit ')) {
        if (h != null) {
          histories.add(h);
        }
        h = BranchHistory.instance;
        h.branchId = s.replaceAll('commit ', '');
      } else if (s.startsWith('Date: ')) {
        const String dateFormat = 'E MMM dd HH:mm:ss yyyy Z';
        h?.timeStamp = DateFormat(dateFormat)
            .parse(s.replaceAll('Date: ', '').trim())
            .millisecondsSinceEpoch;
      } else if (s.isNotEmpty) {
        h?.commitMsg += '$s\n';
      }
    }
  }

  _processTag() {
    ProcessResult tags = Process.runSync('git', ['tag'],
        workingDirectory: PackageConfig.projPath);
    List<String> slices = tags.stdout.toString().split('\n');
    for (var slice in slices) {
      ProcessResult msg = Process.runSync(
        'git',
        ['show', slice],
        workingDirectory: PackageConfig.projPath,
      );
      for (var m in msg.stdout.toString().split('\n')) {
        if (m.startsWith('commit ')) {
          String branchId = m.split(' ')[1];
          histories.firstWhere((e) => e.branchId == branchId).tag.add(slice);
          break;
        }
      }
    }
  }
}

class BranchHistory {
  ///分支时间
  int timeStamp;

  ///分支包含tag
  List<String> tag;

  ///分支的提交信息
  String commitMsg;

  ///分支的id
  String branchId;

  BranchHistory({
    required this.timeStamp,
    required this.tag,
    required this.commitMsg,
    required this.branchId,
  });

  static BranchHistory get instance => BranchHistory(
        timeStamp: 0,
        tag: [],
        commitMsg: '',
        branchId: '',
      );
}
