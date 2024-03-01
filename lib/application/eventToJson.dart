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
    Map<String, String> patterns = Map.fromIterables(
        paramGetter.units.map((e) => e.className),
        paramGetter.units.map((e) => e.paramName));
    for (var unit in unionParamGetter.units) {
      unit.filter(patterns);
    }

    _eventToJson();

    _paramToJson();

    _unionParamToJson();
  }

  static _eventToJson() {
    ///构建json文件
    List eventJsonList = [];
    Set<String> names = {};
    for (EventUnit unit in eventGetter.units) {
      Map<String, dynamic> map = {};
      if (names.contains(unit.eventName)) {
        continue;
      }
      names.add(unit.eventName);
      map["event_name"] = unit.eventName;
      map["event_desc"] = unit.eventDesc.isEmpty
          ? ""
          : unit.eventDesc.substring(1, unit.eventDesc.length - 1);
      map["event_plate"] = unit.eventDesc.isEmpty
          ? ""
          : unit.eventPlate.substring(1, unit.eventPlate.length - 1);
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
      List unionParamList = [];
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
          paramMap["params"] = [];
          paramList.add(paramMap);
        } else if (u2 != null) {
          paramMap["param_name"] = u2.paramName;
          paramMap["param_type"] = u2.className;
          paramMap["param_desc"] =
              unit.classParametersMeta[key] ?? u2.paramDesc;
          paramMap["param_check"] = "";
          paramMap["params"] = u2.children;
          unionParamList.add(paramMap);
        } else {
          paramMap["param_name"] = key;
          paramMap["param_type"] = unit.classParameters[key];
          paramMap["param_desc"] = "Not a specific param";
          paramMap["param_check"] = "";
          paramMap["params"] = [];
          paramList.add(paramMap);
        }
      }
      map["param_list"] = paramList;
      map["union_param_list"] = unionParamList;
      eventJsonList.add(map);
    }

    ///输出
    String jsonStr = json.encode(eventJsonList);

    File('${PackageConfig.projPath}/plugin/analyzer_helper/test/events.json')
        .writeAsString(jsonStr);
  }

  static _paramToJson() {
    ///构建json文件
    List paramJsonList = [];
    for (ParamUnit unit in paramGetter.units) {
      Map<String, dynamic> paramMap = {};
      paramMap["param_name"] = unit.paramName;
      paramMap["param_desc"] = unit.paramDesc;
      paramMap["param_type"] = unit.paramType;
      paramMap["param_check"] = unit.paramCheck;
      paramJsonList.add(paramMap);
    }

    ///输出
    String jsonStr = json.encode(paramJsonList);
    File('${PackageConfig.projPath}/plugin/analyzer_helper/test/params.json')
        .writeAsString(jsonStr);
  }

  static _unionParamToJson() {
    ///构建json文件
    List paramJsonList = [];
    for (UnionParamUnit unit in unionParamGetter.units) {
      Map<String, dynamic> paramMap = {};
      paramMap["param_name"] = unit.paramName;
      paramMap["param_desc"] = unit.paramDesc;
      paramMap["param_type"] = unit.className;
      paramMap["params"] = unit.children;
      paramJsonList.add(paramMap);
    }

    ///输出
    String jsonStr = json.encode(paramJsonList);
    File('${PackageConfig.projPath}/plugin/analyzer_helper/test/union_params.json')
        .writeAsString(jsonStr);
  }
}
