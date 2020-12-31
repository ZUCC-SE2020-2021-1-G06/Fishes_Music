import 'dart:convert' show json;
import 'package:flutter/foundation.dart';

dynamic convertValueByType(value, Type type, {String stack: ""}) {
  if (value == null) {
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

class HotSearchDataQQ {
  int result;
  List<DataQQ> data;

  HotSearchDataQQ({
    this.result,
    this.data,
  });

  factory HotSearchDataQQ.fromJson(jsonRes) {
    if (jsonRes == null) return null;

    List<DataQQ> data = jsonRes['data'] is List ? [] : null;
    if (data != null) {
      for (var item in jsonRes['data']) {
        if (item != null) {
          data.add(DataQQ.fromJson(item));
        }
      }
    }
    return HotSearchDataQQ(
      result: convertValueByType(jsonRes['result'], int, stack: "HotSearchDataQQ-result"),
      data: data,
    );
  }

  Map<String, dynamic> toJson() => {
    'result': result,
    'data': data,
  };

  @override
  String toString() {
    return json.encode(this);
  }
}

class DataQQ {
  String k;
  int n;

  DataQQ({
    this.k,
    this.n,
  });

  factory DataQQ.fromJson(jsonRes) => jsonRes == null
      ? null
      : DataQQ(
    k: convertValueByType(jsonRes['k'], String, stack: "DataQQ-k"),
    n: convertValueByType(jsonRes['n'], int, stack: "DataQQ-n"),
  );

  Map<String, dynamic> toJson() => {
    'k': k,
    'n': n,
  };

  @override
  String toString() {
    return json.encode(this);
  }
}
