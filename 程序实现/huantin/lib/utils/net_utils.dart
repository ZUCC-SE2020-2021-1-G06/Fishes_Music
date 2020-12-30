import 'dart:io';

import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:flutter/material.dart';
import 'package:huantin/model/album.dart';
import 'package:huantin/model/daily_songs.dart';
import 'package:huantin/model/lyric.dart';
import 'package:huantin/model/mv.dart';
import 'package:huantin/model/play_list.dart';
import 'package:huantin/model/recommend.dart';
import 'package:huantin/model/song_comment.dart' hide User;
import 'package:huantin/model/song_detail.dart';
import 'package:huantin/model/top_list.dart';
import 'package:huantin/route/navigate_service.dart';
import 'package:huantin/route/routes.dart';
import 'package:huantin/utils/utils.dart';
import 'package:huantin/widgets/loading.dart';
import 'package:path_provider/path_provider.dart';
import 'package:huantin/model/user.dart';
import 'package:huantin/model/banner.dart' as mBanner;

import "dart:math";
import '../application.dart';


class NetUtils {
  static Dio _dio;
  static final String baseUrl = 'http://118.24.63.15';
  //通过 InternetAddress.lookup('xxxx.com');获取状态判断是否有网络
  static Future<List<InternetAddress>> _fm10s = InternetAddress.lookup("ws.acgvideo.com");

//  初始化代码
  static void init() async {
    Directory tempDir = await getTemporaryDirectory();
    String tempPath = tempDir.path;
    CookieJar cj = PersistCookieJar(dir: tempPath);
    _dio = Dio(BaseOptions(baseUrl: '$baseUrl:1020', followRedirects: false))
      ..interceptors.add(CookieManager(cj))
      ..interceptors.add(LogInterceptor(responseBody: true, requestBody: true));

    // 海外華人可使用 nondanee/UnblockNeteaseMusic
    (_dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (client) {
      client.findProxy = (uri) {
        var host = uri.host;
        if (host == 'music.163.com' ||
            host == 'interface.music.163.com' ||
            host == 'interface3.music.163.com' ||
            host == 'apm.music.163.com' ||
            host == 'apm3.music.163.com' ||
            host == '59.111.181.60' ||
            host == '223.252.199.66' ||
            host == '223.252.199.67' ||
            host == '59.111.160.195' ||
            host == '59.111.160.197' ||
            host == '59.111.181.38' ||
            host == '193.112.159.225' ||
            host == '118.24.63.156' ||
            host == '59.111.181.35' ||
            host == '39.105.63.80' ||
            host == '47.100.127.239' ||
            host == '103.126.92.133' ||
            host == '103.126.92.132') {
          return 'PROXY YOURPROXY;DIRECT';
        }
        return 'DIRECT';
      };
    };
  }

//  定义一个通用的网络请求
//  方法需要传入三个参数：
//  1.context：用于 showLoading
//  2.url：API 地址
//  3.params：该网络请求的参数，可以为空
//  方法内部我们捕获了 DioError，然后判断接口是否还返回了正常的内容。
//  例如：状态码不为2xx，但是仍然返回了数据，这样 Dio 是会抛出 DioError 的，需要我们自己捕获来处理。
//  如果返回了正常的数据，那我们还是返回回去，如果不是正常的数据，则直接抛出 Future.error(0)。
  static Future<Response> _get(
      BuildContext context,
      String url, {
        Map<String, dynamic> params,
        bool isShowLoading = true,
      }) async {
    if (isShowLoading) Loading.showLoading(context);
    try {
      return await _dio.get(url, queryParameters: params);
    } on DioError catch (e) {
      if (e == null) {
        return Future.error(Response(data: -1));
      } else if (e.response != null) {
        if (e.response.statusCode >= 300 && e.response.statusCode < 400) {
          _reLogin();
          return Future.error(Response(data: -1));
        } else {
          return Future.value(e.response);
        }
      } else {
        return Future.error(Response(data: -1));
      }
    } finally {
      Loading.hideLoading(context);
    }
  }

  static void _reLogin() {
    Future.delayed(Duration(milliseconds: 200), () {
      Application.getIt<NavigateService>().popAndPushNamed(Routes.login);
      Utils.showToast('登录失效，请重新登录');
    });
  }

  /// 登录
  static Future<User> login(
      BuildContext context, String phone, String password) async {
    var response = await _get(context, '/login/cellphone', params: {
      'phone': phone,
      'password': password,
    });

    return User.fromJson(response.data);
  }

  /// 退出登录
  static Future<User> logout(BuildContext context) async {
    var response = await _get(context, '/logout');
    return User.fromJson(response.data);
  }

  static Future<Response> refreshLogin(BuildContext context) async {
    return await _get(context, '/login/refresh', isShowLoading: false).catchError((e) {
      Utils.showToast('网络错误！');
    });
  }

  // 首页 Banner
  static Future<mBanner.Banner> getBannerData(BuildContext context) async {
    var response = await _get(context, '/banner', params: {'type': 1});
    return mBanner.Banner.fromJson(response.data);
  }

  /// 推荐歌单
  static Future<RecommendData> getRecommendData(BuildContext context) async {
    var response = await _get(context, '/recommend/resource');
    return RecommendData.fromJson(response.data);
  }

  // 新碟上架
  static Future<AlbumData> getAlbumData(
      BuildContext context, {
        Map<String, dynamic> params = const {
          'offset': 1,
          'limit': 10,
        },
      }) async {
    var response = await _get(context, '/top/album', params: params);
    return AlbumData.fromJson(response.data);
  }

  /// MV 排行
  static Future<MVData> getTopMvData(
      BuildContext context, {
        Map<String, dynamic> params = const {
          'offset': 1,
          'limit': 10,
        },
      }) async {
    var response = await _get(context, '/top/mv', params: params);
    return MVData.fromJson(response.data);
  }

  /// 获取网易云音乐播放源
  /*
  获取音乐 url
  说明 : 使用歌单详情接口后 , 能得到的音乐的 id, 但不能得到的音乐 url,
  调用此接口, 传入的音乐 id( 可多个 , 用逗号隔开 ), 可以获取对应的音乐的 url,
  未登录状态返回试听片段(返回字段包含被截取的正常歌曲的开始时间和结束时间)
   */
  static Future<String> getMusicURL(BuildContext context, id) async {
//    var m10s = await _fm10s;
//    final _random = new Random();
//    var m10 = m10s[_random.nextInt(m10s.length)].address;
    var response = await _get(context, '/song/url?id=$id', isShowLoading: context != null);
//    return response.data['data'][0]["url"].replaceFirst('m10.music.126.net', m10 + '/m10.music.126.net');
    return response.data['data'][0]["url"].replaceFirst('m10.music.126.net', '/m10.music.126.net');
  }

  /// 获取个人歌单（包括自建和收藏）
  static Future<MyPlayListData> getSelfPlaylistData(
      BuildContext context, {
        @required Map<String, dynamic> params,
      }) async {
    var response = await _get(context, '/user/playlist', params: params, isShowLoading: false);
    return MyPlayListData.fromJson(response.data);
  }

  /// 创建歌单
  static Future<PlayListData> createPlaylist(
      BuildContext context, {
        @required Map<String, dynamic> params,
      }) async {
    var response = await _get(context, '/playlist/create',
        params: params, isShowLoading: true);
    return PlayListData.fromJson(response.data);
  }

  /// 删除歌单
  static Future<PlayListData> deletePlaylist(
      BuildContext context, {
        @required Map<String, dynamic> params,
      }) async {
    var response = await _get(context, '/playlist/delete',
        params: params, isShowLoading: true);
    return PlayListData.fromJson(response.data);
  }

  /// 修改歌单
  static Future<PlayListData> editPlaylist(
      BuildContext context, {
        @required Map<String, dynamic> params,
      }) async {
    var response = await _get(context, '/playlist/update',
        params: params, isShowLoading: true);
    return PlayListData.fromJson(response.data);
  }

  /// 每日推荐歌曲
  static Future<DailySongsData> getDailySongsData(BuildContext context) async {
    var response = await _get(
      context,
      '/recommend/songs',
    );
    return DailySongsData.fromJson(response.data);
  }

  /// 歌曲详情
  static Future<SongDetailData> getSongsDetailData(
      BuildContext context, {
        Map<String, dynamic> params,
      }) async {
    var response = await _get(context, '/song/detail', params: params);
    return SongDetailData.fromJson(response.data);
  }

  /// 歌单详情
  static Future<PlayListData> getPlayListData(
      BuildContext context, {
        Map<String, dynamic> params,
      }) async {
    var response = await _get(context, '/playlist/detail', params: params);
    return PlayListData.fromJson(response.data);
  }

  /*
  说明 : 歌单能看到歌单名字, 但看不到具体歌单内容 , 调用此接口 , 传入歌单 id,
  可以获取对应歌单内的所有的音乐(未登录状态只能获取不完整的歌单,登录后是完整的)，
  但是返回的trackIds是完整的，tracks 则是不完整的，可拿全部 trackIds 请求一次 song/detail
  接口获取所有歌曲的详情
  */
  /// 因为歌单详情只能获取歌单信息，并不能获取到歌曲信息，所以要请求两个接口，先获取歌单详情，再获取歌曲详情
  static Future<SongDetailData> getPlayListData2(
      BuildContext context, {
        Map<String, dynamic> params,
      }) async {
    var r = await getPlayListData(context, params: params);
    var response = await getSongsDetailData(context, params: {
      'ids': r.playlist.trackIds.map((t) => t.id).toList().join(',')
    });
    response.playlist = r.playlist;
    return response;
  }

  /// 排行榜首页
  static Future<TopListData> getTopListData(BuildContext context) async {
    var response = await _get(context, '/toplist/detail');
    return TopListData.fromJson(response.data);
  }

  /// 获取歌词
  static Future<LyricData> getLyricData(
      BuildContext context, {
        @required Map<String, dynamic> params,
      }) async {
    var response =
    await _get(context, '/lyric', params: params, isShowLoading: false);
    return LyricData.fromJson(response.data);
  }

  /// 获取评论列表
  static Future<SongCommentData> getSongCommentData(
      BuildContext context, {
        @required Map<String, dynamic> params,
      }) async {
    var response = await _get(context, '/comment/music',
        params: params, isShowLoading: false);
    return SongCommentData.fromJson(response.data);
  }

  /// 获取评论列表
  static Future<SongCommentData> getCommentData(
      BuildContext context,
      int type, {
        @required Map<String, dynamic> params,
      }) async {
    var funcName;
    switch (type) {
      case 0: // song
        funcName = 'music';
        break;
      case 1: // mv
        funcName = 'mv';
        break;
      case 2: // 歌单
        funcName = 'playlist';
        break;
      case 3: // 专辑
        funcName = 'album';
        break;
      case 4: // 电台
        funcName = 'dj';
        break;
      case 5: // 视频
        funcName = 'video';
        break;
    // 动态评论需要threadId，后续再做
    }
    var response = await _get(context, '/comment/$funcName',
        params: params, isShowLoading: false);
    return SongCommentData.fromJson(response.data);
  }

  /// 获取评论列表
  static Future<SongCommentData> sendComment(
      BuildContext context, {
        @required Map<String, dynamic> params,
      }) async {
    var response =
    await _get(context, '/comment', params: params, isShowLoading: true);
    return SongCommentData.fromJson(response.data);
  }

}

