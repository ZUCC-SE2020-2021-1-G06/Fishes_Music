class LocalUser{
  String _username;
  String _avatar;

  LocalUser({
    String username,
    String avatar}){
    this._username = username;
    this._avatar = avatar;
  }
  String get username => _username;

  set username(String username) => _username = username;

  String get avatar => _avatar;

  set avatar(String avatar) => _avatar = avatar;

  LocalUser.fromJson(Map<String, dynamic> json) {
    _username = json['username'];
    _avatar = json['avatar'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['username'] = this._username;
    data['avatar'] = this._avatar;
  }
}