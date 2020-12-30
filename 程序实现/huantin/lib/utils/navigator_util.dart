import 'dart:io';
import 'package:extended_image/extended_image.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:huantin/model/comment_head.dart';
import 'package:huantin/model/recommend.dart';
import 'package:huantin/route/routes.dart';
import 'package:huantin/utils/fluro_convert_utils.dart';

import '../application.dart';


class NavigatorUtil {
  static _navigateTo(BuildContext context, String path,
      {bool replace = false,
      bool clearStack = false,
      Duration transitionDuration = const Duration(milliseconds: 250),
      RouteTransitionsBuilder transitionBuilder}) {
      Application.router.navigateTo(context, path,
        replace: replace,
        clearStack: clearStack,
        transitionDuration: transitionDuration,
        transitionBuilder: transitionBuilder,
        transition: TransitionType.material);
  }

  /// 启动页
  static void goSplashPage(BuildContext context) {
    _navigateTo(context, Routes.root, clearStack: true);
  }

  /// 首页
  static void goHomePage(BuildContext context) {
    _navigateTo(context, Routes.home, clearStack: true);
  }

  /// 每日推荐歌曲
  static void goDailySongsPage(BuildContext context) {
    _navigateTo(context, Routes.dailySongs);
  }

  /// 歌单详情
  static void goPlayListPage(BuildContext context, {@required Recommend data}) {
    _navigateTo(context, "${Routes.playList}?data=${FluroConvertUtils.object2string(data)}");
  }

  /// 排行榜首页
  static void goTopListPage(BuildContext context) {
    _navigateTo(context, Routes.topList);
  }

  /// 用户详情页面
  static void goUserDetailPage(BuildContext context, int userId) {
    _navigateTo(context, "${Routes.userDetail}?id=$userId");
  }

  /// 登录页
  static void goLoginPage(BuildContext context) {
    _navigateTo(context, Routes.login, clearStack: true);
  }

  /// 绑定页
  static void goBDPage(BuildContext context) {
    _navigateTo(context, Routes.bd, clearStack: true);
  }

  /// 播放歌曲页面
  static void goPlaySongsPage(BuildContext context) {
    _navigateTo(context, Routes.playSongs);
  }

  /// 评论页面
  static void goCommentPage(BuildContext context,
      {@required CommentHead data}) {
    _navigateTo(context,
        "${Routes.comment}?data=${FluroConvertUtils.object2string(data)}");
  }

}
