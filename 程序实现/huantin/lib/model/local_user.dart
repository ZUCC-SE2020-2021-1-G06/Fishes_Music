class LocalUser{
  int _userId;
  String _username;
  String _avatar;

  LocalUser({
    int userId,
    String username,
    String avatar}){
    this._userId = userId;
    this._username = username;
    this._avatar = avatar;
  }

  int get userId => _userId;

  set userId(int value) {
    _userId = value;
  }

  String get username => _username;

  set username(String username) => _username = username;

  String get avatar => _avatar;

  set avatar(String avatar) => _avatar = avatar;

  LocalUser.fromJson(Map<String, dynamic> json) {
    _userId = json['id'];
    _username = json['username'];
    _avatar = json['avatar'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this._userId;
    data['username'] = this._username;
    data['avatar'] = this._avatar;
  }
}