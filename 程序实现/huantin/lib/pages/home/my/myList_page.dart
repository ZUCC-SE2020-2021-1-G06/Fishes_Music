import 'dart:async';

import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:huantin/application.dart';
import 'package:huantin/model/daily_songs.dart';
import 'package:huantin/model/music.dart';
import 'package:huantin/model/myMusic.dart';
import 'package:huantin/model/myMusicKuwo.dart';
import 'package:huantin/model/myMusicQQ.dart';
import 'package:huantin/model/song.dart';
import 'package:huantin/model/song_kuwo.dart';
import 'package:huantin/model/song_qq.dart';
import 'package:huantin/provider/local_user_model.dart';
import 'package:huantin/provider/play_list_model.dart';
import 'package:huantin/provider/play_songs_model.dart';
import 'package:huantin/utils/navigator_util.dart';
import 'package:huantin/utils/net_utils.dart';
import 'package:huantin/utils/utils.dart';
import 'package:huantin/widgets/v_empty_view.dart';
import 'package:huantin/widgets/widget_feedback_appbar.dart';
import 'package:huantin/widgets/widget_music_list_item.dart';
import 'package:huantin/widgets/widget_music_myList_item.dart';
import 'package:huantin/widgets/widget_music_myList_item_kuwo.dart';
import 'package:huantin/widgets/widget_music_myList_item_qq.dart';
import 'package:huantin/widgets/widget_myList_appbar.dart';
import 'package:huantin/widgets/widget_play.dart';
import 'package:huantin/widgets/widget_play_history_app_bar.dart';
import 'package:huantin/widgets/widget_play_list_app_bar.dart';
import 'package:huantin/widgets/widget_sliver_future_builder.dart';
import 'package:provider/provider.dart';

//自建歌单

class MyListPage extends StatefulWidget {
  @override
  _MyListPageState createState() => _MyListPageState();
}

class _MyListPageState extends State<MyListPage> {
  PlaySongsModel _playSongsModel;
  double _expandedHeight = ScreenUtil().setWidth(340);
  int _count;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((d) {
      if (mounted) {
        _playSongsModel = Provider.of<PlaySongsModel>(context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(
                bottom:
                ScreenUtil().setWidth(80) + Application.bottomBarHeight),
            child: CustomScrollView(
              slivers: <Widget>[
                //背景图片
                MyListAppBarWidget(
                  backgroundImg: 'images/bg_myList.png',
                  count: _count,
                  playOnTap: (model) {
                    _playSongsModel.clearHistorySong();
                  },
                  content: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Spacer(),
                      Container(
                        padding:
                        EdgeInsets.only(left: ScreenUtil().setWidth(40)),
                        margin:
                        EdgeInsets.only(bottom: ScreenUtil().setWidth(5)),
                        //设置时间
                        child: RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                  text:
                                  '${DateUtil.formatDate(DateTime.now(), format: 'dd')} ',
                                  style: TextStyle(fontSize: 30)),
                              TextSpan(
                                  text:
                                  '/ ${DateUtil.formatDate(DateTime.now(), format: 'MM')}月',
                                  style: TextStyle(fontSize: 16)),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        padding:
                        EdgeInsets.only(left: ScreenUtil().setWidth(40)),
                        margin:
                        EdgeInsets.only(bottom: ScreenUtil().setWidth(20)),
                        child: Text(
                          '可能是时光让耳朵变得温柔',
                          style: TextStyle(fontSize: 14, color: Colors.white70),
                        ),
                      ),
                    ],
                  ),
                  expandedHeight: _expandedHeight,
                  title: '自建歌单',
                ),
                Consumer2<PlaySongsModel,LocalUserModel>(builder: (context, model, model2, child) {
                  var localUser = model2.localUser;
                  if (localUser == null) {
                    return SliverList(
                        delegate: SliverChildBuilderDelegate((context, index) {
                          return GestureDetector(
                            child: Text(
                              "请先登录",
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Color(0xFF18E3B7),fontSize: 20),
                            ),
                            onTap:() {
                              NavigatorUtil.goLoginLocalPage(context);
                            },
                          );
                        }, childCount: 1));
                  }
                  else{
                    model.checkList(localUser.userId);
                    if(model.check == 0){
                      model.addList(localUser.userId);
                    }
                    model.loadMyList(localUser.userId);
                    List<Song> myListSongs = model.getMyListSongs();
                    List<SongQQ> myListSongQQ = model.getMyListSongQQ();
                    List<SongKuwo> myListSongKuwo = model.getMyListSongKuwo();
                    setCount(myListSongs.length + myListSongQQ.length + myListSongKuwo.length);
                    return SliverList(
                        delegate: SliverChildBuilderDelegate((context, index) {
                          if(index < myListSongs.length){
                          return WidgetMusicMyListItem(
                            MyMusicData(
                              //设置mvid为1，放置播放按钮
                              mvid: 1,
                              index: index + 1,
                              songId:myListSongs[index].id,
                              songName: myListSongs[index].name,
                              artists: '网易云 - ' + myListSongs[index].artists,
                              picUrl: myListSongs[index].picUrl
                            ),
                            onTap: () {
                              //通过返回的url判断是否可以播放，准确性更高，但是暂时无法输出原因
                              NetUtils.getMusicURL(null, myListSongs[index].id)
                                  .then((value) => {
                                if (value == null)
                                  {Utils.showToast("暂时无法播放")}
                                else{
                                  if(index < myListSongs.length)playSongs(model, myListSongs[index])
                                }
                              });
                            },
                          );}
                          else if(index >= myListSongs.length && index < (myListSongQQ.length + myListSongs.length)){
                            return WidgetMusicMyListItemQQ(
                              MyMusicDataQQ(
                                //设置mvid为1，放置播放按钮
                                  mvid: 1,
                                  index: index + 1,
                                  songId:myListSongQQ[index - myListSongs.length].id,
                                  songName: myListSongQQ[index - myListSongs.length].name,
                                  artists: 'QQ音乐 - ' + myListSongQQ[index - myListSongs.length].artists,
                                  picUrl: myListSongQQ[index - myListSongs.length].picUrl
                              ),
                              onTap: () {
                                //通过返回的url判断是否可以播放，准确性更高，但是暂时无法输出原因
                                NetUtils.getMusicURL2(null, myListSongQQ[index - myListSongs.length].id)
                                    .then((value) => {
                                  if (value == null)
                                    {Utils.showToast("暂时无法播放")}
                                  else
                                    playSongQQ(model, myListSongQQ[index - myListSongs.length])
                                });
                              },
                            );
                          }else{
                            return WidgetMusicMyListItemKuwo(
                              MyMusicDataKuwo(
                                //设置mvid为1，放置播放按钮
                                  mvid: 1,
                                  index: index + 1,
                                  songId:myListSongKuwo[index - (myListSongQQ.length + myListSongs.length)].id,
                                  songName: myListSongKuwo[index - (myListSongQQ.length + myListSongs.length)].name,
                                  artists: '酷我 - ' + myListSongKuwo[index - (myListSongQQ.length + myListSongs.length)].artists,
                                  picUrl: myListSongKuwo[index - (myListSongQQ.length + myListSongs.length)].picUrl
                              ),
                              onTap: () {
                                //通过返回的url判断是否可以播放，准确性更高，但是暂时无法输出原因
                                NetUtils.getMusicURL3(null, myListSongKuwo[index - (myListSongQQ.length + myListSongs.length)].id)
                                    .then((value) => {
                                  if (value == null)
                                    {Utils.showToast("暂时无法播放")}
                                  else
                                    playSongKuwo(model, myListSongKuwo[index - (myListSongQQ.length + myListSongs.length)])
                                });
                              },
                            );
                          }
                        }, childCount: myListSongs.length + myListSongQQ.length + myListSongKuwo.length),
                    );
                  }

                })
              ],
            ),
          ),
//        所有页面下面的播放条
          PlayWidget(),
        ],
      ),
    );
  }

  //正常播放
  void playSongs(PlaySongsModel model, Song song) {
    model.playSong(
      song,
    );
    NavigatorUtil.goPlaySongsPage(context);
  }

  //正常播放
  void playSongQQ(PlaySongsModel model, SongQQ song) {
    model.playSongQQ(
      song,
    );
    NavigatorUtil.goPlaySongsPageQQ(context);
  }

  //正常播放
  void playSongKuwo(PlaySongsModel model, SongKuwo song) {
    model.playSongKuwo(
      song,
    );
    NavigatorUtil.goPlaySongsPageKuwo(context);
  }

  void setCount(int count) {
    Future.delayed(Duration(milliseconds: 300), () {
      if (mounted) {
        setState(() {
          _count = count;
        });
      }
    });
  }
}
