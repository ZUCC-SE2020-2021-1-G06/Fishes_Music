import 'dart:convert' show json;

class HotSearchDataKuGou {

  int errcode;
  int status;
  String error;
  DataKuGou data;

  HotSearchDataKuGou.fromParams({this.errcode, this.status, this.error, this.data});

  factory HotSearchDataKuGou(jsonStr) => jsonStr == null ? null : jsonStr is String ? HotSearchDataKuGou.fromJson(json.decode(jsonStr)) : HotSearchDataKuGou.fromJson(jsonStr);

  HotSearchDataKuGou.fromJson(jsonRes) {
    errcode = jsonRes['errcode'];
    status = jsonRes['status'];
    error = jsonRes['error'];
    data = jsonRes['data'] == null ? null : DataKuGou.fromJson(jsonRes['data']);
  }

  @override
  String toString() {
    return '{"errcode": $errcode, "status": $status, "error": ${error != null?'${json.encode(error)}':'null'}, "data": $data}';
  }
}

class DataKuGou {

  int timestamp;
  List<Info> info;

  DataKuGou.fromParams({this.timestamp, this.info});

  DataKuGou.fromJson(jsonRes) {
    timestamp = jsonRes['timestamp'];
    info = jsonRes['info'] == null ? null : [];

    for (var infoItem in info == null ? [] : jsonRes['info']){
      info.add(infoItem == null ? null : Info.fromJson(infoItem));
    }
  }

  @override
  String toString() {
    return '{"timestamp": $timestamp, "info": $info}';
  }
}

class Info {

  int sort;
  String jumpurl;
  String keyword;

  Info.fromParams({this.sort, this.jumpurl, this.keyword});

  Info.fromJson(jsonRes) {
    sort = jsonRes['sort'];
    jumpurl = jsonRes['jumpurl'];
    keyword = jsonRes['keyword'];
  }

  @override
  String toString() {
    return '{"sort": $sort, "jumpurl": ${jumpurl != null?'${json.encode(jumpurl)}':'null'}, "keyword": ${keyword != null?'${json.encode(keyword)}':'null'}}';
  }
}