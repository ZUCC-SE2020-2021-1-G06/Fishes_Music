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
import 'package:huantin/model/song_qq.dart';
import 'package:huantin/model/song_kuwo.dart';
import 'package:huantin/provider/play_list_model.dart';
import 'package:huantin/provider/play_songs_model.dart';
import 'package:huantin/utils/navigator_util.dart';
import 'package:huantin/utils/net_utils.dart';
import 'package:huantin/utils/utils.dart';
import 'package:huantin/widgets/v_empty_view.dart';
import 'package:huantin/widgets/widget_music_list_item.dart';
import 'package:huantin/widgets/widget_music_myList_item.dart';
import 'package:huantin/widgets/widget_music_myList_item_kuwo.dart';
import 'package:huantin/widgets/widget_music_myList_item_qq.dart';
import 'package:huantin/widgets/widget_play.dart';
import 'package:huantin/widgets/widget_play_history_app_bar.dart';
import 'package:huantin/widgets/widget_play_list_app_bar.dart';
import 'package:huantin/widgets/widget_sliver_future_builder.dart';
import 'package:provider/provider.dart';

//最近播放（历史播放记录）

class HistorySongsPage extends StatefulWidget {
  @override
  _HistorySongsPageState createState() => _HistorySongsPageState();
}

class _HistorySongsPageState extends State<HistorySongsPage> {
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
                PlayHistoryAppBarWidget(
                  backgroundImg: 'images/bg_history.jpg',
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
                          '遇见时光里的自己，记录你的春夏秋冬',
                          style: TextStyle(fontSize: 14, color: Colors.white70),
                        ),
                      ),
                    ],
                  ),
                  expandedHeight: _expandedHeight,
                  title: '最近播放',
                ),
                Consumer<PlaySongsModel>(builder: (context, model, child) {
                  List<Song> hs = model.getHistorySongs();
                  List<SongQQ> hsqq = model.getHistorySongQQ();
                  List<SongKuwo> hskuwo = model.getHistorySongKuwo();
                  setCount(hs.length + hsqq.length + hskuwo.length);
                  return SliverList(
                    delegate: SliverChildBuilderDelegate((context, index) {
                      if(index < hs.length){
                        return WidgetMusicMyListItem(
                          MyMusicData(
                            //设置mvid为1，放置播放按钮
                              mvid: 1,
                              index: index + 1,
                              songId:hs[index].id,
                              songName: hs[index].name,
                              artists: '网易云 - ' + hs[index].artists,
                              picUrl: hs[index].picUrl
                          ),
                          onTap: () {
                            //通过返回的url判断是否可以播放，准确性更高，但是暂时无法输出原因
                            NetUtils.getMusicURL(null, hs[index].id)
                                .then((value) => {
                              if (value == null)
                                {Utils.showToast("暂时无法播放")}
                              else
                                playSongs(model, hs[index])
                            });
                          },
                        );}
                      else if(index >= hs.length && index < (hsqq.length + hs.length)){
                        return WidgetMusicMyListItemQQ(
                          MyMusicDataQQ(
                            //设置mvid为1，放置播放按钮
                              mvid: 1,
                              index: index + 1,
                              songId:hsqq[index - hs.length].id,
                              songName: hsqq[index - hs.length].name,
                              artists: 'QQ音乐 - ' + hsqq[index - hs.length].artists,
                              picUrl: hsqq[index - hs.length].picUrl
                          ),
                          onTap: () {
                            //通过返回的url判断是否可以播放，准确性更高，但是暂时无法输出原因
                            NetUtils.getMusicURL2(null, hsqq[index - hs.length].id)
                                .then((value) => {
                              if (value == null)
                                {Utils.showToast("暂时无法播放")}
                              else
                                playSongQQ(model, hsqq[index - hs.length])
                            });
                          },
                        );
                      }else{
                        return WidgetMusicMyListItemKuwo(
                          MyMusicDataKuwo(
                            //设置mvid为1，放置播放按钮
                              mvid: 1,
                              index: index + 1,
                              songId:hskuwo[index - (hsqq.length + hs.length)].id,
                              songName: hskuwo[index - (hsqq.length + hs.length)].name,
                              artists: '酷我 - ' + hskuwo[index - (hsqq.length + hs.length)].artists,
                              picUrl: hskuwo[index - (hsqq.length + hs.length)].picUrl
                          ),
                          onTap: () {
                            //通过返回的url判断是否可以播放，准确性更高，但是暂时无法输出原因
                            NetUtils.getMusicURL3(null, hskuwo[index - (hsqq.length + hs.length)].id)
                                .then((value) => {
                              if (value == null)
                                {Utils.showToast("暂时无法播放")}
                              else
                                playSongKuwo(model, hskuwo[index - (hsqq.length + hs.length)])
                            });
                          },
                        );
                      }
                    }, childCount: hs.length + hsqq.length + hskuwo.length),
                  );
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
