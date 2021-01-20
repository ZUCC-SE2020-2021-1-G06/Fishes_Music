class Banner {
  List<Data> _data;
  int _code;

  Banner({List<Data> data, int code}) {
    this._data = data;
    this._code = code;
  }

  List<Data> get data => _data;
  set data(List<Data> data) => _data = data;
  int get code => _code;
  set code(int code) => _code = code;

  Banner.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      _data = new List<Data>();
      json['data'].forEach((v) {
        _data.add(new Data.fromJson(v));
      });
    }
    _code = json['code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this._data != null) {
      data['data'] = this._data.map((v) => v.toJson()).toList();
    }
    data['code'] = this._code;
    return data;
  }
}

class Data {
  String _pic;

  Data({String pic}) {
    this._pic = pic;
  }

  String get pic => _pic;
  set pic(String pic) => _pic = pic;

  Data.fromJson(Map<String, dynamic> json) {
    _pic = json['pic'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['pic'] = this._pic;
    return data;
  }
}
