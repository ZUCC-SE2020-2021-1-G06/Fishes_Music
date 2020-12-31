import 'dart:async';

import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:huantin/application.dart';
import 'package:huantin/model/daily_songs.dart';
import 'package:huantin/model/music.dart';
import 'package:huantin/model/song.dart';
import 'package:huantin/provider/play_list_model.dart';
import 'package:huantin/provider/play_songs_model.dart';
import 'package:huantin/utils/navigator_util.dart';
import 'package:huantin/utils/net_utils.dart';
import 'package:huantin/utils/utils.dart';
import 'package:huantin/widgets/v_empty_view.dart';
import 'package:huantin/widgets/widget_music_list_item.dart';
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
                  setCount(hs.length);
                  return SliverList(
                      delegate: SliverChildBuilderDelegate((context, index) {
                    return WidgetMusicListItem(
                      MusicData(
                        //设置mvid为1，放置播放按钮
                        mvid: 1,
                        index: index + 1,
                        songName: hs[index].name,
                        artists: hs[index].artists,
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
                    );
                  }, childCount: hs.length));
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
