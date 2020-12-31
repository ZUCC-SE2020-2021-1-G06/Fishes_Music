import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:huantin/application.dart';
import 'package:huantin/model/local_user.dart';
import 'package:huantin/model/user.dart';
import 'package:huantin/utils/navigator_util.dart';
import 'package:huantin/utils/net_utils.dart';
import 'package:huantin/utils/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';


class LocalUserModel with ChangeNotifier {
  LocalUser _localUser;

  LocalUser get localUser => _localUser;

  set localUser(LocalUser localUser) => _localUser = localUser;

  /// 初始化 本地User
  void initLocalUser() {
    if (Application.sp.containsKey('localuser')) {
      String s = Application.sp.getString('localuser');
      _localUser = LocalUser.fromJson(json.decode(s));
    }
  }

  /// 登录
  Future<LocalUser> login(BuildContext context, String username, String password) async {

    Response response = await Dio().get(
        "http://121.196.105.48:8080/user/login?username=" +
            username + "&password=" + password);
    if (response.data != "") {
      LocalUser localUser = LocalUser.fromJson(response.data);
      Utils.showToast( '登录成功');
      _saveUserInfo(localUser);
      return localUser;
    }
    else{
      Utils.showToast('登录失败，请检查用户名密码');
      return null;
    }

  }
  ///注册
  Future<LocalUser> register(BuildContext context, String username, String password) async {

    Response response = await Dio().get(
        "http://121.196.105.48:8080/user/register?username=" +
            username + "&password=" + password);
    if (response.data != "") {
      LocalUser localUser = LocalUser.fromJson(response.data);
      Utils.showToast( '注册成功');
      _saveUserInfo(localUser);
      return localUser;
    }
    else{
      Utils.showToast('注册失败，存在同名用户');
      return null;
    }

  }

  /// 保存用户信息到 sp
  _saveUserInfo(LocalUser localUser) {
    _localUser = localUser;
    Application.sp.setString('localuser', json.encode(_localUser.toJson()));
  }

  /// 退出
  Future<LocalUser> logout(BuildContext context) async {
    _delete();
    return _localUser;
  }

  /// 删除
  _delete() {
    Application.sp.clear();
    _localUser = null;
  }

}
