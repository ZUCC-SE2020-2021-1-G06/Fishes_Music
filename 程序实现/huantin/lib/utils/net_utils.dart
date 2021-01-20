import 'dart:io';

import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:flutter/material.dart';
import 'package:huantin/model/album.dart';
import 'package:huantin/model/check.dart';
import 'package:huantin/model/daily_songs.dart';
import 'package:huantin/model/hot_search.dart';
import 'package:huantin/model/hot_search_kugou.dart';
import 'package:huantin/model/hot_search_qq.dart';
import 'package:huantin/model/lyric.dart';
import 'package:huantin/model/mv.dart';
import 'package:huantin/model/play_list.dart';
import 'package:huantin/model/recommend.dart';
import 'package:huantin/model/search_result.dart' hide User;
import 'package:huantin/model/search_result_kuwo.dart';
import 'package:huantin/model/search_result_qq.dart';
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
import 'package:huantin/model/banner2.dart' as nBanner;

import "dart:math";
import '../application.dart';


class NetUtils {
  static Dio _dio;  //网易云
  static Dio _dio2; //QQ音乐
  static Dio _dio3; //酷我
  static Dio _dio4; //酷狗
  static Dio _dio5; //QQ音乐（音乐URL）
  static final String baseUrl = 'http://118.24.63.15';
  static final String baseUrl2 = 'http://121.196.105.48';
  static final String baseUrl3 = 'http://121.196.105.48';
  static final String baseUrl4 = 'http://mobilecdn.kugou.com';
  static final String baseUrl5 = 'http://121.196.105.48';

//  初始化代码
  static void init() async {
    //网易云
    Directory tempDir = await getTemporaryDirectory();
    String tempPath = tempDir.path;
    CookieJar cj = PersistCookieJar(dir: tempPath);
    _dio = Dio(BaseOptions(baseUrl: '$baseUrl:1020', followRedirects: false))
      ..interceptors.add(CookieManager(cj))
      ..interceptors.add(LogInterceptor(responseBody: true, requestBody: true));

    //QQ音乐
    Directory tempDir2 = await getTemporaryDirectory();
    String tempPath2 = tempDir2.path;
    CookieJar cj2 = PersistCookieJar(dir: tempPath2);
    _dio2 = Dio(BaseOptions(baseUrl: '$baseUrl2:3300', followRedirects: false))
      ..interceptors.add(CookieManager(cj2))
      ..interceptors.add(LogInterceptor(responseBody: true, requestBody: true));

    //酷我音乐
    Directory tempDir3 = await getTemporaryDirectory();
    String tempPath3 = tempDir3.path;
    CookieJar cj3 = PersistCookieJar(dir: tempPath3);
    _dio3 = Dio(BaseOptions(baseUrl: '$baseUrl3:3330', followRedirects: false))
      ..interceptors.add(CookieManager(cj3))
      ..interceptors.add(LogInterceptor(responseBody: true, requestBody: true));

    //酷狗音乐(热搜）
    Directory tempDir4 = await getTemporaryDirectory();
    String tempPath4 = tempDir4.path;
    CookieJar cj4 = PersistCookieJar(dir: tempPath4);
    _dio4 = Dio(BaseOptions(baseUrl: '$baseUrl4', followRedirects: false))
      ..interceptors.add(CookieManager(cj4))
      ..interceptors.add(LogInterceptor(responseBody: true, requestBody: true));

    //QQ音乐（音乐URL）
    Directory tempDir5 = await getTemporaryDirectory();
    String tempPath5 = tempDir5.path;
    CookieJar cj5 = PersistCookieJar(dir: tempPath5);
    _dio5 = Dio(BaseOptions(baseUrl: '$baseUrl5:3300', followRedirects: false))
      ..interceptors.add(CookieManager(cj5))
      ..interceptors.add(LogInterceptor(responseBody: true, requestBody: true));
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

  //QQ音乐API的请求
  static Future<Response> _get2(
      BuildContext context,
      String url, {
        Map<String, dynamic> params,
        bool isShowLoading = true,
      }) async {
    if (isShowLoading) Loading.showLoading(context);
    try {
      return await _dio2.get(url, queryParameters: params);
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

  //酷我音乐API的请求
  static Future<Response> _get3(
      BuildContext context,
      String url, {
        Map<String, dynamic> params,
        bool isShowLoading = true,
      }) async {
    if (isShowLoading) Loading.showLoading(context);
    try {
      return await _dio3.get(url, queryParameters: params);
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

  //酷狗音乐API的请求
  static Future<Response> _get4(
      BuildContext context,
      String url, {
        Map<String, dynamic> params,
        bool isShowLoading = true,
      }) async {
    if (isShowLoading) Loading.showLoading(context);
    try {
      return await _dio4.get(url, queryParameters: params);
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

  //QQ音乐（音乐URL）
  static Future<Response> _get5(
      BuildContext context,
      String url, {
        Map<String, dynamic> params,
        bool isShowLoading = true,
      }) async {
    if (isShowLoading) Loading.showLoading(context);
    try {
      return await _dio5.get(url, queryParameters: params);
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

  // 首页网易云Banner
  static Future<mBanner.Banner> getBannerData(BuildContext context) async {
    var response = await _get(context, '/banner', params: {'type': 1});
    return mBanner.Banner.fromJson(response.data);
  }

  // 首页酷我Banner
  static Future<nBanner.Banner> getBanner2Data(BuildContext context) async {
    var response = await _get3(context, '/banner', params: {'type': 1});
    return nBanner.Banner.fromJson(response.data);
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
    var response = await _get(context, '/song/url?id=$id', isShowLoading: context != null);
    return response.data['data'][0]["url"];
  }

  //获取QQ音乐播放源
  static Future<String> getMusicURL2(BuildContext context, id) async {
    var response = await _get5(context, '/song/urls?id=$id', isShowLoading: context != null);
    return response.data['data']['$id'];
  }

  //获取酷我音乐播放源
  static Future<String> getMusicURL3(BuildContext context, id) async {
    var response = await _get3(context, '/url?rid=$id', isShowLoading: context != null);
    return response.data['url'];
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

  /// 音乐是否可用
  /// 说明: 调用此接口,传入歌曲 id, 可获取音乐是否可用
  /// 返回 { success: true, message: 'ok' } 或者 { success: false, message: '亲爱的,暂无版权' }
  static Future<Check> getCheck(
      BuildContext context, {
        Map<String, dynamic> params,
      }) async {
    var response = await _get(context, '/check/music', params: params);
    return Check.fromJson(response.data);
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

  /// 获取歌曲评论列表
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

  /// 网易云发送评论
  static Future<SongCommentData> sendComment(
      BuildContext context, {
        @required Map<String, dynamic> params,
      }) async {
    var response =
    await _get(context, '/comment', params: params, isShowLoading: true);
    return SongCommentData.fromJson(response.data);
  }

  /// 获取网易云热门搜索数据：热搜列表(详细)
  static Future<HotSearchData> getHotSearchData(BuildContext context) async {
    var response =
    await _get(context, '/search/hot/detail', isShowLoading: false);
    return HotSearchData.fromJson(response.data);
  }

  /// 获取QQ音乐热门搜索数据：热搜列表(简略)
  static Future<HotSearchDataQQ> getHotSearchDataQQ(BuildContext context) async {
    var response =
    await _get2(context, '/search/hot', isShowLoading: false);
    return HotSearchDataQQ.fromJson(response.data);
  }

  /// 获取酷狗音乐热门搜索数据：热搜列表(简略)
  static Future<HotSearchDataKuGou> getHotSearchDataKugou(BuildContext context) async {
    var response =
    await _get4(context, '/api/v3/search/hot?format=json&plat=0&count=30', isShowLoading: false);
    return HotSearchDataKuGou.fromJson(response.data);
  }

  /// 综合搜索
  /// type: 搜索类型；默认为 1 即单曲 , 取值意义 :
  /// 1: 单曲, 10: 专辑, 100: 歌手, 1000: 歌单, 1002: 用户, 1004: MV, 1006: 歌词, 1009: 电台, 1014: 视频, 1018:综合
  static Future<SearchMultipleData> searchMultiple(
      BuildContext context, {
        @required Map<String, dynamic> params,
      }) async {
    var response = await _get(context, '/search',
        params: params, isShowLoading: false);
    return SearchMultipleData.fromJson(response.data);
  }

  static Future<SearchMultipleDataQQ> searchMultipleQQ(
      BuildContext context, {
        @required Map<String, dynamic> params,
      }) async {
    var response = await _get2(context, '/search',
        params: params, isShowLoading: false);
    return SearchMultipleDataQQ.fromJson(response.data);
  }

  static Future<SearchMultipleDataKuwo> searchMultipleKuwo(
      BuildContext context, {
        @required Map<String, dynamic> params,
      }) async {
    var response = await _get3(context, '/search/searchMusicBykeyWord',
        params: params, isShowLoading: false);
    return SearchMultipleDataKuwo.fromJson(response.data);
  }

}

