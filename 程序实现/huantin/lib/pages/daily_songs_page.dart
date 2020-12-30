import 'dart:async';

import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:huantin/model/daily_songs.dart';
import 'package:huantin/model/music.dart';
import 'package:huantin/model/song.dart';
import 'package:huantin/provider/play_songs_model.dart';
import 'package:huantin/utils/navigator_util.dart';
import 'package:huantin/utils/net_utils.dart';
import 'package:huantin/widgets/v_empty_view.dart';
import 'package:huantin/widgets/widget_music_list_item.dart';
import 'package:huantin/widgets/widget_play.dart';
import 'package:huantin/widgets/widget_play_list_app_bar.dart';
import 'package:huantin/widgets/widget_sliver_future_builder.dart';
import 'package:provider/provider.dart';

import '../application.dart';


//每日推荐歌单页面

class DailySongsPage extends StatefulWidget {
  @override
  _DailySongsPageState createState() => _DailySongsPageState();
}

class _DailySongsPageState extends State<DailySongsPage> {
  double _expandedHeight = ScreenUtil().setWidth(340);
  int _count;
  DailySongsData data;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(bottom: ScreenUtil().setWidth(80) + Application.bottomBarHeight),
            child: CustomScrollView(
              slivers: <Widget>[
                //背景图片
                PlayListAppBarWidget(
                  backgroundImg: 'images/bg_daily.png',
                  count: _count,
                  playOnTap: (model) {
                    playSongs(model, 0);
                  },
                  content: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Spacer(),
                      Container(
                        padding: EdgeInsets.only(left: ScreenUtil().setWidth(40)),
                        margin: EdgeInsets.only(bottom: ScreenUtil().setWidth(5)),
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
                        padding: EdgeInsets.only(left: ScreenUtil().setWidth(40)),
                        margin: EdgeInsets.only(bottom: ScreenUtil().setWidth(20)),
                        child: Text(
                          '根据你的音乐口味，为你推荐好音乐。',
                          style: TextStyle(fontSize: 14, color: Colors.white70),
                        ),
                      ),
                    ],
                  ),
                  expandedHeight: _expandedHeight,
                  title: '每日推荐',
                ),
                CustomSliverFutureBuilder<DailySongsData>(
                  futureFunc: NetUtils.getDailySongsData,
                  builder: (context, data) {
                    setCount(data.recommend.length);
                    return Consumer<PlaySongsModel>(
                      builder: (context, model, child) {
                        return SliverList(
                          delegate: SliverChildBuilderDelegate(
                                (context, index) {
                              this.data = data;
                              var d = data.recommend[index];
                              return WidgetMusicListItem(
                                MusicData(
                                    mvid: d.mvid,
                                    picUrl: d.album.picUrl,
                                    songName: d.name,
                                    artists:
                                    "${d.artists.map((a) => a.name).toList().join('/')} - ${d.album.name}"),
                                onTap: () {
                                  playSongs(model, index);
                                },
                              );
                            },
                            childCount: data.recommend.length,
                          ),
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ),
//        所有页面下面的播放条
          PlayWidget(),
        ],
      ),
    );
  }

  void playSongs(PlaySongsModel model, int index) {
    model.playSongs(
      data.recommend.map((r) => Song(
                r.id,
                name: r.name,
                picUrl: r.album.picUrl,
                artists: '${r.artists.map((a) => a.name).toList().join('/')}',
              )).toList(),
      index: index,
    );
//    前往播放页面
//    NavigatorUtil.goPlaySongsPage(context);
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
