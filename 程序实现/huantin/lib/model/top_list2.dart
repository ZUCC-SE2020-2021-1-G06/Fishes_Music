import 'dart:convert' show json;
import 'package:flutter/foundation.dart';

dynamic convertValueByType(value, Type type, {String stack: ""}) {
  if (value == null) {
    debugPrint("$stack : value is null");
    if (type == String) {
      return "";
    } else if (type == int) {
      return 0;
    } else if (type == double) {
      return 0.0;
    } else if (type == bool) {
      return false;
    }
    return null;
  }

  if (value.runtimeType == type) {
    return value;
  }
  var valueS = value.toString();
  debugPrint("$stack : ${value.runtimeType} is not $type type");
  if (type == String) {
    return valueS;
  } else if (type == int) {
    return int.tryParse(valueS);
  } else if (type == double) {
    return double.tryParse(valueS);
  } else if (type == bool) {
    valueS = valueS.toLowerCase();
    var intValue = int.tryParse(valueS);
    if (intValue != null) {
      return intValue == 1;
    }
    return valueS == "true";
  }
}

void tryCatch(Function f) {
  try {
    f?.call();
  } catch (e, stack) {
    debugPrint("$e");
    debugPrint("$stack");
  }
}

class TopListData {
  int code;
  List<TopData> data;

  TopListData({
    this.code,
    this.data,
  });

  factory TopListData.fromJson(jsonRes) {
    if (jsonRes == null) return null;

    List<TopData> data = jsonRes['data'] is List ? [] : null;
    if (data != null) {
      for (var item in jsonRes['data']) {
        if (item != null) {
          tryCatch(() {
            data.add(TopData.fromJson(item));
          });
        }
      }
    }
    return TopListData(
      code: convertValueByType(jsonRes['code'], int, stack: "TopListData-code"),
      data: data,
    );
  }

  Map<String, dynamic> toJson() => {
    'code': code,
    'data': data,
  };

  @override
  String toString() {
    return json.encode(this);
  }
}

class TopData {
  List<Lists> list;
  String name;

  TopData({
    this.list,
    this.name,
  });

  factory TopData.fromJson(jsonRes) {
    if (jsonRes == null) return null;

    List<Lists> list = jsonRes['list'] is List ? [] : null;
    if (list != null) {
      for (var item in jsonRes['list']) {
        if (item != null) {
          tryCatch(() {
            list.add(Lists.fromJson(item));
          });
        }
      }
    }
    return TopData(
      list: list,
      name: convertValueByType(jsonRes['name'], String,
          stack: "TopData-name"),
    );
  }

  Map<String, dynamic> toJson() => {
    'list': list,
    'name': name,
  };

  @override
  String toString() {
    return json.encode(this);
  }
}

class Lists {
  String intro;
  String sourceid;
  String name;
  String pic;
  String pub;
  String id;

  Lists({
    this.intro,
    this.sourceid,
    this.name,
    this.pic,
    this.pub,
    this.id,
  });

  factory Lists.fromJson(jsonRes) => jsonRes == null
      ? null
      : Lists(
    intro: convertValueByType(jsonRes['intro'], String,
        stack: "List-intro"),
    name: convertValueByType(jsonRes['name'], String,
        stack: "List-name"),
    sourceid: convertValueByType(jsonRes['sourceid'], String,
        stack: "List-sourceid"),
    pic: convertValueByType(jsonRes['pic'], String,
        stack: "List-pic"),
    pub: convertValueByType(jsonRes['pub'], String,
        stack: "List-pub"),
    id: convertValueByType(jsonRes['id'], String,
        stack: "List-id"),
  );

  Map<String, dynamic> toJson() => {
    'intro':intro,
    'sourceid':sourceid,
    'name':name,
    'pic':pic,
    'pub':pub,
    'id':id,
  };

  @override
  String toString() {
    return json.encode(this);
  }
}
