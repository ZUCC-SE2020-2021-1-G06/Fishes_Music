class FeedbackLocal{
  int _id;
  String _username;
  String _suggestion;
  String _state;

  FeedbackLocal({
    id,
    username,
    suggestion,
    state}){
    this._id = id;
    this._username = username;
    this._suggestion = suggestion;
    this._state = state;

  }

  int get id => _id;

  set id(int value) {
    _id = value;
  }

  String get state => _state;

  set state(String value) {
    _state = value;
  }

  String get suggestion => _suggestion;

  set suggestion(String value) {
    _suggestion = value;
  }

  String get username => _username;

  set username(String value) {
    _username = value;
  }

  FeedbackLocal.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _username = json['username'];
    _suggestion = json['suggestion'];
    _state = json['state'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this._id;
    data['username'] = this._username;
    data['suggestion'] = this._suggestion;
    data['state'] = this._state;
  }




}