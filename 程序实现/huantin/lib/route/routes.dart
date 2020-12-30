import 'package:fluro/fluro.dart';
import 'package:huantin/route/route_handles.dart';

class Routes {
  static String root = "/";       //登录闪屏页
  static String home = "/home";   //主界面
  static String login = "/login"; //网易云账号登录页
  static String bd = "/bd";       //绑定页
  static String userDetail = "/user_detail";  //网易云用户信息页
  static String dailySongs = "/daily_songs";  //每日推荐歌单页
  static String topList = "/top_list";        //排行榜
  static String playList = "/play_list";      //歌单页
  static String playSongs = "/play_songs";    //音乐播放页
  static String comment = "/comment";     //网易云歌曲评论页

  static void configureRoutes(FluroRouter router) {
    router.notFoundHandler = new Handler(
        handlerFunc: (context, Map<String, List<String>> params) {
          print("ROUTE WAS NOT FOUND !!!");
          return null;
        });
    //登录闪屏页
    router.define(root, handler: splashHandler);
    //主界面
    router.define(home, handler: homeHandler);
    //绑定页
    router.define(bd, handler: bdHandler);
    //网易云账号登录页
    router.define(login, handler: loginHandler);
    //每日推荐歌单页
    router.define(dailySongs, handler: dailySongsHandler);
    //歌单页
    router.define(playList, handler: playListHandler);
    //排行榜
    router.define(topList, handler: topListHandler);
    //音乐播放页
    router.define(playSongs, handler: playSongsHandler);
    //网易云歌曲评论页
    router.define(comment, handler: commentHandler);
  }
}