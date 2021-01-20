import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:huantin/application.dart';
import 'package:huantin/model/song.dart';
import 'package:huantin/model/song_kuwo.dart';
import 'package:huantin/model/song_qq.dart';
import 'package:huantin/provider/play_songs_model.dart';
import 'package:huantin/utils/navigator_util.dart';
import 'package:huantin/widgets/common_text_style.dart';
import 'package:huantin/widgets/h_empty_view.dart';
import 'package:huantin/widgets/widget_round_img.dart';
import 'package:huantin/widgets/widget_songs_list.dart';
import 'package:provider/provider.dart';

/// 所有页面下面的播放条
class PlayWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Consumer<PlaySongsModel>(builder: (context, model, child) {
        Widget child;
        //若当前无在播放的歌曲
        if (model.allSongs.isEmpty && model.allSongKuwo.isEmpty && model.allSongQQ.isEmpty) {
          child = GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () {
              //设置点击事件为空
            },
            child: Row(
              children: <Widget>[
                RoundImgWidget('images/logo.png', 80),
                HEmptyView(10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(
                        "",
                        style: commonTextStyle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        "",
                        style: common13TextStyle,
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {},
                  child: Image.asset(
                    model.curState == AudioPlayerState.PLAYING
                        ? 'images/pause.png'
                        : 'images/play.png',
                    width: ScreenUtil().setWidth(50),
                  ),
                ),
                HEmptyView(15),
                GestureDetector(
                  onTap: () {},
                  child: Image.asset(
                    'images/list.png',
                    width: ScreenUtil().setWidth(50),
                  ),
                ),
              ],
            ),
          );
        }
        //当前有在播放的歌曲
        else {
          Song curSong = model.curSong;
          String name;
          String artists;
          String picUrl;
          if(model.cur == 1 && model.allSongQQ.isNotEmpty){
            SongQQ curSongQQ = model.curSongQQ;
            name = curSongQQ.name;
            artists = curSongQQ.artists;
            picUrl = curSongQQ.picUrl;
          }
          else if(model.cur == 2 && model.allSongKuwo.isNotEmpty){
            SongKuwo curSongKuwo = model.curSongKuwo;
            name = curSongKuwo.name;
            artists = curSongKuwo.artists;
            picUrl = curSongKuwo.picUrl;
          }
          else {
            name = curSong.name;
            artists = curSong.artists;
            picUrl = curSong.picUrl;
          }
          child = GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () {
              if(model.cur == 1)NavigatorUtil.goPlaySongsPageQQ(context);
              else if(model.cur == 2)NavigatorUtil.goPlaySongsPageKuwo(context);
              else NavigatorUtil.goPlaySongsPage(context);
            },
            child: Row(
              children: <Widget>[
                RoundImgWidget(picUrl, 80),
                HEmptyView(10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(
                        name,
                        style: commonTextStyle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        artists,
                        style: common13TextStyle,
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    if (model.curState == null) {
                      if(model.cur == 1)model.playQQ();
                      else if (model.cur == 2)model.playKuwo();
                      else model.play();
                    } else {
                      model.togglePlay();
                    }
                  },
                  child: Image.asset(
                    model.curState == AudioPlayerState.PLAYING
                        ? 'images/pause.png'
                        : 'images/play.png',
                    width: ScreenUtil().setWidth(50),
                  ),
                ),
                HEmptyView(15),
                GestureDetector(
                  onTap: () {
                    //展示播放列表
                    List<Song> d = model.getSongs();
                    if(d.isNotEmpty){
                      showModalBottomSheet<PlaySongsModel>(
                          context: context,
                          builder: (context) {
                            return SongsListWidget(model);
                          },
                          backgroundColor: Colors.white);
                    }
                  },
                  child: Image.asset(
                    'images/list.png',
                    width: ScreenUtil().setWidth(50),
                  ),
                ),
              ],
            ),
          );
        }

        return Container(
          width: Application.screenWidth,
          height: ScreenUtil().setWidth(110) + Application.bottomBarHeight,
          decoration: BoxDecoration(
              border: Border(top: BorderSide(color: Colors.grey[200])),
              color: Colors.white),
          alignment: Alignment.topCenter,
          padding: EdgeInsets.symmetric(vertical: ScreenUtil().setWidth(10)),
          child: Container(
            width: Application.screenWidth,
            height: ScreenUtil().setWidth(110),
            padding:
                EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(30)),
            alignment: Alignment.center,
            child: child,
          ),
        );
      }),
    );
  }
}
