import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:huantin/model/check.dart';
import 'package:huantin/model/comment_head.dart';

//import 'package:huantin/model/comment_head.dart';
import 'package:huantin/model/music.dart';
import 'package:huantin/model/play_list.dart';
import 'package:huantin/model/recommend.dart';
import 'package:huantin/model/song.dart';
import 'package:huantin/model/song_detail.dart';
import 'package:huantin/pages/comment_type.dart';
import 'package:huantin/pages/play_list/play_list_desc_dialog.dart';
import 'package:huantin/provider/play_songs_model.dart';
import 'package:huantin/utils/navigator_util.dart';
import 'package:huantin/utils/net_utils.dart';
import 'package:huantin/utils/utils.dart';
import 'package:huantin/widgets/common_text_style.dart';
import 'package:huantin/widgets/h_empty_view.dart';
import 'package:huantin/widgets/v_empty_view.dart';
import 'package:huantin/widgets/widget_footer_tab.dart';
import 'package:huantin/widgets/widget_music_list_item.dart';
import 'package:huantin/widgets/widget_play.dart';
import 'package:huantin/widgets/widget_round_img.dart';
import 'package:huantin/widgets/widget_play_list_app_bar.dart';
import 'package:huantin/widgets/widget_play_list_cover.dart';
import 'package:huantin/widgets/widget_sliver_future_builder.dart';
import 'package:provider/provider.dart';

import '../../application.dart';

class PlayListPage extends StatefulWidget {
  final Recommend data;

  PlayListPage(this.data);

  @override
  _PlayListPageState createState() => _PlayListPageState();
}

class _PlayListPageState extends State<PlayListPage> {
  double _expandedHeight = ScreenUtil().setWidth(630);
  Playlist _data;
  PlaySongsModel _playSongsModel;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((d) {
      if (mounted) {
        _playSongsModel = Provider.of<PlaySongsModel>(context);
      }
    });
  }

  /// 构建歌单简介
  Widget buildDescription() {
    return GestureDetector(
      onTap: () {
        showGeneralDialog(
          context: context,
          pageBuilder: (BuildContext buildContext, Animation<double> animation,
              Animation<double> secondaryAnimation) {
            return PlayListDescDialog(_data);
          },
          barrierDismissible: true,
          barrierLabel:
              MaterialLocalizations.of(context).modalBarrierDismissLabel,
          transitionDuration: const Duration(milliseconds: 150),
          transitionBuilder: _buildMaterialDialogTransitions,
        );
      },
      //显示歌单描述，若无描述，则不显示
      child: _data != null && _data.description != null
          ? Row(
              children: <Widget>[
                Expanded(
                  child: Text(
                    _data.description,
                    style: smallWhite70TextStyle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Icon(
                  Icons.keyboard_arrow_right,
                  color: Colors.white70,
                ),
              ],
            )
          : Container(),
    );
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
                PlayListAppBarWidget(
                  sigma: 20,
                  playOnTap: (model) {
                    playSongs(model, 0);
                  },
                  content: SafeArea(
                    child: Padding(
                      padding: EdgeInsets.only(
                        left: ScreenUtil().setWidth(35),
                        right: ScreenUtil().setWidth(35),
                        top: ScreenUtil().setWidth(120),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              PlayListCoverWidget(
                                '${widget.data.picUrl}?param=200y200',
                                width: 250,
                                playCount: widget.data.playcount,
                              ),
                              HEmptyView(20),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    Text(
                                      widget.data.name,
                                      softWrap: true,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: mWhiteBoldTextStyle,
                                    ),
                                    VEmptyView(10),
                                    Row(
                                      children: <Widget>[
                                        _data == null
                                            ? Container()
                                            : RoundImgWidget(
                                                '${_data.creator.avatarUrl}?param=50y50',
                                                40),
                                        HEmptyView(5),
                                        Expanded(
                                          child: _data == null
                                              ? Container()
                                              : Text(
                                                  _data.creator.nickname,
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: commonWhite70TextStyle,
                                                ),
                                        ),
                                        //显示创建者右侧的箭头图标
//                                        _data == null
//                                            ? Container()
//                                            : Icon(
//                                          Icons.keyboard_arrow_right,
//                                          color: Colors.white70,
//                                        ),
                                      ],
                                    ),
                                    VEmptyView(10),
                                    buildDescription(),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          VEmptyView(15),
                          Container(
                            margin:
                                EdgeInsets.only(top: ScreenUtil().setWidth(12)),
                            alignment: Alignment.center,
                            child: Row(
                              children: <Widget>[
                                FooterTabWidget('images/icon_comment.png',
                                    '${_data == null ? "评论" : _data.commentCount}',
                                    () {
                                  NavigatorUtil.goCommentPage(context,
                                      data: CommentHead(
                                          _data.coverImgUrl,
                                          _data.name,
                                          _data.creator.nickname,
                                          _data.commentCount,
                                          _data.id,
                                          CommentType.playList.index));
                                }),
                                FooterTabWidget(
                                    'images/icon_share.png',
                                    '${_data == null ? "分享" : _data.shareCount}',
                                    () {}),
                                FooterTabWidget(
                                    'images/icon_download.png', '下载', () {}),
                                FooterTabWidget('images/icon_multi_select.png',
                                    '多选', () {}),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  expandedHeight: _expandedHeight,
                  backgroundImg: widget.data.picUrl,
                  title: widget.data.name,
                  count: _data == null ? null : _data.trackCount,
                ),
                CustomSliverFutureBuilder<SongDetailData>(
                  futureFunc: NetUtils.getPlayListData2,
                  params: {'id': widget.data.id},
                  builder: (context, data) {
                    setData(data.playlist);
                    return Consumer<PlaySongsModel>(
                        builder: (context, model, child) {
                      return SliverList(
                          delegate:
                              SliverChildBuilderDelegate((context, index) {
                        var d = data.songs[index];
                        return WidgetMusicListItem(
                          MusicData(
                            mvid: d.mv,
                            index: index + 1,
                            songName: d.name,
                            artists:
                                '${d.ar.map((a) => a.name).toList().join('/')} - ${d.al.name}',
                          ),
                          onTap: () {
                            //判断是否有版权，由于接口问题，暂时无法准确适用
//                                NetUtils.getCheck(context,params: {'id': d.id}).then((value) => {
//                                  if(value.success == true ){
//                                    playSongs(model, index)
//                                  }
//                                  else{
//                                    Utils.showToast(value.message)
//                                  }
//                                });
                            //通过返回的url判断是否可以播放，准确性更高，但是暂时无法输出原因
                            NetUtils.getMusicURL(null, d.id).then((value) => {
                                  if (value == null)
                                    {Utils.showToast("暂时无法播放")}
                                  else
                                    playSongs(model, index)
                                });
                          },
                        );
                      }, childCount: data.playlist.trackIds.length));
                    });
                  },
                ),
              ],
            ),
          ),
          PlayWidget(),
        ],
      ),
    );
  }

  //正常播放
  void playSongs(PlaySongsModel model, int index) {
    model.playSongs(
      _data.tracks
          .map((r) => Song(
                r.id,
                0,
                name: r.name,
                picUrl: r.al.picUrl,
                artists: '${r.ar.map((a) => a.name).toList().join('/')}',
              ))
          .toList(),
      index: index,
    );
    NavigatorUtil.goPlaySongsPage(context);
  }

  void setData(Playlist data) {
    Future.delayed(Duration(milliseconds: 50), () {
      if (mounted) {
        setState(() {
          _data = data;
        });
      }
    });
  }

  Widget _buildMaterialDialogTransitions(
      BuildContext context,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
      Widget child) {
    return FadeTransition(
      opacity: CurvedAnimation(
        parent: animation,
        curve: Curves.easeOut,
      ),
      child: child,
    );
  }
}
