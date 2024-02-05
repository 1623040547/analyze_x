import 'dart:convert';
import 'dart:io';

import 'package:analyzer_x/base/analyzer.dart';
import 'package:analyzer_x/getter/eventGetter.dart';
import 'package:analyzer_x/path/path.dart';

import '../getter/paramGetter.dart';
import '../getter/unionParamGetter.dart';

///将事件/参数必要信息转换为json文件
class EventToJson {
  static EventGetter eventGetter = EventGetter();
  static ParamGetter paramGetter = ParamGetter();
  static UnionParamGetter unionParamGetter = UnionParamGetter();

  static ParamUnit? param(String p) {
    List<ParamUnit> params =
        paramGetter.units.where((element) => element.className == p).toList();
    return params.isEmpty ? null : params.first;
  }

  static UnionParamUnit? unionParam(String p) {
    List<UnionParamUnit> params = unionParamGetter.units
        .where((element) => element.className == p)
        .toList();
    return params.isEmpty ? null : params.first;
  }

  static toJson() {
    ///获取需求数据
    for (var file in getDartFiles()) {
      MainAnalyzer(
        getters: [
          eventGetter,
          paramGetter,
          unionParamGetter,
        ],
        filePath: file.filePath,
      );
    }

    ///过滤
    List<String> patterns = paramGetter.units.map((e) => e.className).toList();
    for (var unit in unionParamGetter.units) {
      unit.filter(patterns);
    }

    ///构建json文件
    List jsonList = [];
    for (EventUnit unit in eventGetter.units) {
      Map<String, dynamic> map = {};
      map["event_name"] = unit.eventName;
      map["event_desc"] = unit.eventDesc;
      map["panels"] = unit.panels.isEmpty
          ? [
              'xlog',
              'appEvent',
              'grpc',
              'firebase',
              'mixpanel',
            ]
          : unit.panels;

      ///todo:确定事件在代码中的位置
      map["locations"] = [];

      List paramList = [];
      for (var key in unit.classParameters.keys) {
        ParamUnit? u1 = param(unit.classParameters[key]!);
        UnionParamUnit? u2 = unionParam(unit.classParameters[key]!);
        Map<String, dynamic> paramMap = {};
        if (u1 != null) {
          paramMap["param_name"] = u1.paramName;
          paramMap["param_type"] = u1.paramType;
          paramMap["param_desc"] =
              unit.classParametersMeta[key] ?? u1.paramDesc;
          paramMap["param_check"] = u1.paramCheck;
          paramMap["type"] = "base";
          paramMap["params"] = [];
        } else if (u2 != null) {
          paramMap["param_name"] = u2.paramName;
          paramMap["param_type"] = "";
          paramMap["param_desc"] =
              unit.classParametersMeta[key] ?? u2.paramDesc;
          paramMap["param_check"] = "";
          paramMap["type"] = "union";
          paramMap["params"] = u2.children;
        } else {
          paramMap["param_name"] = key;
          paramMap["param_type"] = unit.classParameters[key];
          paramMap["param_desc"] = "Not a specific param";
          paramMap["param_check"] = "";
          paramMap["type"] = "unknown";
          paramMap["params"] = [];
        }
        paramList.add(paramMap);
      }
      map["param_list"] = paramList;
      jsonList.add(map);
    }

    ///输出
    String jsonStr = json.encode(jsonList);
    File('/Users/qingdu/StudioProjects/my_healer/plugin/analyzer_helper/test/events.json')
        .writeAsString(jsonStr);
  }
}
