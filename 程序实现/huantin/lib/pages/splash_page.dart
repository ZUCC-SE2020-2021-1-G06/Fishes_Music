import 'package:flutter/material.dart';
import 'package:huantin/application.dart';
import 'package:huantin/model/song.dart';
import 'package:huantin/model/song_kuwo.dart';
import 'package:huantin/model/song_qq.dart';
import 'package:huantin/model/user.dart';
import 'package:huantin/provider/local_user_model.dart';
import 'package:huantin/provider/play_list_model.dart';
import 'package:huantin/provider/play_songs_model.dart';
import 'package:huantin/provider/user_model.dart';
import 'package:huantin/utils/fluro_convert_utils.dart';
import 'package:huantin/utils/navigator_util.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:huantin/utils/net_utils.dart';
import 'package:provider/provider.dart';


import '../application.dart';

class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> with TickerProviderStateMixin {
  AnimationController _logoController;
  Tween _scaleTween;
  CurvedAnimation _logoAnimation;

  @override
  void initState() {
    super.initState();
    _scaleTween = Tween(begin: 0, end: 1);
    _logoController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500))
          ..drive(_scaleTween);
    Future.delayed(Duration(milliseconds: 500), () {
      _logoController.forward();
    });
    _logoAnimation =
        CurvedAnimation(parent: _logoController, curve: Curves.easeOutQuart);

    _logoController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Future.delayed(Duration(milliseconds: 500), () {
          goPage();
        });
      }
    });
  }

  void goPage() async{
    await Application.initSp();
    UserModel userModel = Provider.of<UserModel>(context);
    userModel.initUser();
    PlaySongsModel playSongsModel = Provider.of<PlaySongsModel>(context);

    LocalUserModel localUserModel = Provider.of<LocalUserModel>(context);
    //localUserModel.initLocalUser();
    // 判断是否有保存的歌曲列表
    if(Application.sp.containsKey('playing_songs')){
      List<String> songs = Application.sp.getStringList('playing_songs');
      playSongsModel.addSongs(songs.map((s) => Song.fromJson(FluroConvertUtils.string2map(s))).toList());
      int index = Application.sp.getInt('playing_index');
      playSongsModel.curIndex = index;
    }
    // 判断是否有保存的QQ歌曲列表
    if(Application.sp.containsKey('playing_songsQQ')){
      List<String> songQQ = Application.sp.getStringList('playing_songsQQ');
      playSongsModel.addSongQQ(songQQ.map((s) => SongQQ.fromJson(FluroConvertUtils.string2map(s))).toList());
      int indexQQ = Application.sp.getInt('playing_indexQQ');
      playSongsModel.curIndexQQ = indexQQ;
    }
    // 判断是否有保存的酷我歌曲列表
    if(Application.sp.containsKey('playing_songsKuwo')){
      List<String> songKuwo = Application.sp.getStringList('playing_songsKuwo');
      playSongsModel.addSongKuwo(songKuwo.map((s) => SongKuwo.fromJson(FluroConvertUtils.string2map(s))).toList());
      int indexKuwo = Application.sp.getInt('playing_indexKuwo');
      playSongsModel.curIndexKuwo = indexKuwo;
    }
    // 判断是否有听歌历史记录
    if(Application.sp.containsKey('history_songs')){
      List<String> songs = Application.sp.getStringList('history_songs');
      playSongsModel.addHistorySongs(songs.map((s) => Song.fromJson(FluroConvertUtils.string2map(s))).toList());
    }
    // 判断是否有QQ听歌历史记录
    if(Application.sp.containsKey('history_songQQ')){
      List<String> songs = Application.sp.getStringList('history_songQQ');
      playSongsModel.addHistorySongQQ(songs.map((s) => SongQQ.fromJson(FluroConvertUtils.string2map(s))).toList());
    }
    // 判断是否有酷我听歌历史记录
    if(Application.sp.containsKey('history_songKuwo')){
      List<String> songs = Application.sp.getStringList('history_songKuwo');
      playSongsModel.addHistorySongKuwo(songs.map((s) => SongKuwo.fromJson(FluroConvertUtils.string2map(s))).toList());
    }
    // 判断上次听的平台
    if(Application.sp.containsKey('playing_cur')){
      int cur = Application.sp.getInt('playing_cur');
      playSongsModel.cur = cur;
    }
    if (userModel.user != null) {
      await NetUtils.refreshLogin(context).then((value){
        if(value.data != -1){
          NavigatorUtil.goHomePage(context);
        }
      });
      Provider.of<PlayListModel>(context).user = userModel.user;
    } else
      NavigatorUtil.goHomePage(context);

    if (localUserModel.localUser != null) {
      await NetUtils.refreshLogin(context).then((value){
        if(value.data != -1){
          NavigatorUtil.goHomePage(context);
        }
      });
      Provider.of<PlayListModel>(context).localUser = localUserModel.localUser;
    } else
      NavigatorUtil.goHomePage(context);
  }

  @override
  Widget build(BuildContext context) {
    NetUtils.init();
    ScreenUtil.init(context, width: 750, height: 1334);
    final size = MediaQuery.of(context).size;
    Application.screenWidth = size.width;
    Application.screenHeight = size.height;
    Application.statusBarHeight = MediaQuery.of(context).padding.top;
    Application.bottomBarHeight = MediaQuery.of(context).padding.bottom;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        height: double.infinity,
        width: double.infinity,
        child: ScaleTransition(
          scale: _logoAnimation,
          child: Hero(
            tag: 'logo',
            child: Image.asset('images/logo2.png'),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _logoController.dispose();
  }
}
