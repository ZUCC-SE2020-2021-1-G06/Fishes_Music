import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:huantin/model/comment_head.dart';
import 'package:huantin/model/recommend.dart';
import 'package:huantin/pages/bangding.dart';
import 'package:huantin/pages/comment/comment_page.dart';
import 'package:huantin/pages/daily_songs_page.dart';
import 'package:huantin/pages/home/home_page.dart';
import 'package:huantin/pages/home/my/my_page.dart';
import 'package:huantin/pages/login_page.dart';
import 'package:huantin/pages/play_list/play_list_page.dart';
import 'package:huantin/pages/play_songs/play_songs_page.dart';
import 'package:huantin/pages/splash_page.dart';
import 'package:huantin/pages/top_list_page.dart';
import 'package:huantin/utils/fluro_convert_utils.dart';

import '../main.dart';


// splash 页面
var splashHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, List<Object>> params) {
      return SplashPage();
    });

// 跳转到主页
var homeHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, List<Object>> params) {
      return HomePage();
    });

// 登录页
var loginHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, List<Object>> params) {
      return LoginPage();
    });

// 绑定页
var bdHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, List<Object>> params) {
      return BdPage();
    });

// 跳转到每日推荐歌曲
var dailySongsHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, List<Object>> params) {
      return DailySongsPage();
    });

// 跳转到排行榜页
var topListHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, List<Object>> params) {
      return TopListPage();
    });

// 跳转到歌单
var playListHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, List<Object>> params) {
      String data = params['data'].first;
      return PlayListPage(Recommend.fromJson(FluroConvertUtils.string2map(data)));
    });

// 跳转到播放歌曲
var playSongsHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, List<Object>> params) {
      return PlaySongsPage();
    });

// 跳转到评论
var commentHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, List<Object>> params) {
      String data = params['data'].first;
      return CommentPage(CommentHead.fromJson(FluroConvertUtils.string2map(data)));
    });


