import 'dart:async';

import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:huantin/application.dart';
import 'package:huantin/model/lyric.dart';
import 'package:huantin/pages/play_songs/widget_lyric.dart';
import 'package:huantin/provider/play_songs_model.dart';
import 'package:huantin/utils/net_utils.dart';
import 'package:huantin/utils/utils.dart';
import 'package:huantin/widgets/common_text_style.dart';

class LyricPage extends StatefulWidget {
  final PlaySongsModel model;

  LyricPage(this.model);

  @override
  _LyricPageState createState() => _LyricPageState();
}

class _LyricPageState extends State<LyricPage> with TickerProviderStateMixin {
  LyricWidget _lyricWidget;
  LyricData _lyricData;
  List<Lyric> lyrics;
  AnimationController _lyricOffsetYController;
  int curSongId;
  Timer dragEndTimer; // 拖动结束任务
  Function dragEndFunc; //定义拖动防抖方法
  Duration dragEndDuration = Duration(milliseconds: 1000);  //定义拖动防抖延迟时间

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((call) {
      curSongId = widget.model.curSong.id;
      _request();
    });

    dragEndFunc = () {
      if (_lyricWidget.isDragging) {
        setState(() {
          _lyricWidget.isDragging = false;
        });
      }
    };
  }

  void _request() async {
    _lyricData = await NetUtils.getLyricData(context, params: {'id': curSongId});
    setState(() {
      lyrics = Utils.formatLyric(_lyricData.lrc.lyric);
      _lyricWidget = LyricWidget(lyrics, 0);
    });
  }

  @override
  Widget build(BuildContext context) {
    print('lyric_build');
    // 当前歌的id变化之后要重新获取歌词
    if (curSongId != widget.model.curSong.id) {
      lyrics = null;
      curSongId = widget.model.curSong.id;
      _request();
    }

    return Scaffold(
        backgroundColor: Colors.transparent,
        body: lyrics == null
            ? Container(
                alignment: Alignment.center,
                child: Text(
                  '歌词加载中...',
                  style: commonWhiteTextStyle,
                ),
              )
            : GestureDetector(
              /*
              让点击跳转播放时不跳转至歌曲封面页，解决办法为不走父组件的 onTap() 方法。
              这里有一点，如果子组件有点击事件，并且父组件没有设置相对应的 behavior，那么事件是不会冒泡到父组件的。
              如果是在拖动状态中，那么设置上点击事件，如果不是的话，设置为null
              这也能解释我们上面给 isDragging 赋值的时候为什么会 setState() ，就是因为要设置这个点击事件。
               */
                onTapDown: _lyricWidget.isDragging
                    ? (e) {
                        if (e.localPosition.dx > 0 &&
                            e.localPosition.dx < ScreenUtil().setWidth(100) &&
                            e.localPosition.dy > _lyricWidget.canvasSize.height / 2 - ScreenUtil().setWidth(100) &&
                            e.localPosition.dy < _lyricWidget.canvasSize.height / 2 + ScreenUtil().setWidth(100)) {
                          /// 跳转到固定时间
                          widget.model.seekPlay(_lyricWidget.dragLineTime);
                        }
                      }
                    : null,
                onVerticalDragUpdate: (e) {
                  if (!_lyricWidget.isDragging) {
                    setState(() {
                      _lyricWidget.isDragging = true;
                    });
                  }
                  _lyricWidget.offsetY += e.delta.dy;
                },
                onVerticalDragEnd: (e) {
                  // 拖动防抖
                  cancelDragTimer();
                },
                child: StreamBuilder<String>(
                  stream: widget.model.curPositionStream,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      var curTime = double.parse(snapshot.data
                          .substring(0, snapshot.data.indexOf('-')));
                      // 获取当前在哪一行
                      int curLine = Utils.findLyricIndex(curTime, lyrics);
                      if (!_lyricWidget.isDragging) {
                        startLineAnim(curLine);
                      }
                      // 给 customPaint 赋值当前行
                      _lyricWidget.curLine = curLine;
                      return CustomPaint(
                        size: Size(
                            Application.screenWidth,
                            Application.screenHeight -
                                kToolbarHeight -
                                ScreenUtil().setWidth(150) -
                                ScreenUtil().setWidth(50) -
                                Application.statusBarHeight -
                                ScreenUtil().setWidth(120)),
                        painter: _lyricWidget,
                      );
                    } else {
                      return Container();
                    }
                  },
                ),
              ));
  }

// 通过查看网易云官方APP，拖动结束后大约一两秒钟的时间才会消失，
// 这个时间差是为了给用户点击时间线上的播放按钮准备的。
  void cancelDragTimer() {
    //1.首先判断该 Timer 是否为空
    //2.如果不为空则判断是否在活跃状态
    //3.如果都满足条件，则取消这个 Timer 的任务，并且置为空
    //4.最后重新赋值任务
    if (dragEndTimer != null) {
      if (dragEndTimer.isActive) {
        dragEndTimer.cancel();
        dragEndTimer = null;
      }
    }
    dragEndTimer = Timer(dragEndDuration, dragEndFunc);
    //这样就可以达到预期的结果：在最后一次拖动结束的一秒钟后，把时间线消失。
  }

  /// 开始下一行动画
  void startLineAnim(int curLine) {
    // 判断当前行和 customPaint 里的当前行是否一致，不一致才做动画
    if (_lyricWidget.curLine != curLine) {
      // 如果动画控制器不是空，那么则证明上次的动画未完成，
      // 未完成的情况下直接 stop 当前动画，做下一次的动画
      if (_lyricOffsetYController != null) {
        _lyricOffsetYController.stop();
      }

      // 初始化动画控制器，切换歌词时间为300ms，并且添加状态监听，
      // 如果为 completed，则消除掉当前controller，并且置为空。
      _lyricOffsetYController = AnimationController(
          vsync: this, duration: Duration(milliseconds: 300))
        ..addStatusListener((status) {
          if (status == AnimationStatus.completed) {
            _lyricOffsetYController.dispose();
            _lyricOffsetYController = null;
          }
        });
      // 计算出来当前行的偏移量
      var end = _lyricWidget.computeScrollY(curLine) * -1;
      // 起始为当前偏移量，结束点为计算出来的偏移量
      Animation animation = Tween<double>(begin: _lyricWidget.offsetY, end: end)
          .animate(_lyricOffsetYController);
      // 添加监听，在动画做效果的时候给 offsetY 赋值
      _lyricOffsetYController.addListener(() {
        _lyricWidget.offsetY = animation.value;
      });
      // 启动动画
      _lyricOffsetYController.forward();
    }
  }
}
