import 'dart:ui';
import 'dart:ui' as prefix0;

import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:huantin/model/lyric.dart';
import 'package:huantin/widgets/common_text_style.dart';

/*
  自定义组件使用CustomPainter。
  调用 TextPainter.paint() 方法，该方法需要传入两个参数：
  1.画布，也就是canvas
  2.偏移量
*/

class LyricWidget extends CustomPainter with ChangeNotifier {
  List<Lyric> lyric;
  List<TextPainter> lyricPaints = []; // 其他歌词
  double _offsetY = 0;
  int curLine;
  Paint linePaint;
  bool isDragging = false; // 是否正在人为拖动
  double totalHeight = 0; // 总长度
  TextPainter draggingLineTimeTextPainter; // 正在拖动中当前行的时间
  Size canvasSize = Size.zero;
  int dragLineTime;

  get offsetY => _offsetY;

  set offsetY(double value) {
    // 判断如果是在拖动状态下
    if (isDragging) {
      // 不能小于最开始的位置
      if (_offsetY.abs() < lyricPaints[0].height + ScreenUtil().setWidth(30)) {
        _offsetY = (lyricPaints[0].height + ScreenUtil().setWidth(30)) * -1;
      } else if (_offsetY.abs() > (totalHeight + lyricPaints[0].height + ScreenUtil().setWidth(30))) {
        // 不能大于最大位置
        _offsetY = (totalHeight + lyricPaints[0].height + ScreenUtil().setWidth(30)) * -1;
      } else {
        _offsetY = value;
      }
    } else {
      _offsetY = value;
    }
    notifyListeners();
  }

  LyricWidget(this.lyric, this.curLine) {
    linePaint = Paint()
      ..color = Colors.white12
      ..strokeWidth = ScreenUtil().setWidth(1);
    lyricPaints.addAll(lyric
        .map((l) => TextPainter(
            text: TextSpan(text: l.lyric, style: commonGrayTextStyle),
            textDirection: TextDirection.ltr))
        .toList());
    // 首先对TextPainter 进行 layout，否则会报错
    _layoutTextPainters();
  }

// 绘制歌词的方法
  @override
  void paint(Canvas canvas, Size size) {
    canvasSize = size;

//  1.首先确定中间位置 size.height / 2 + lyricPaints[0].height / 2
    var y = _offsetY + size.height / 2 + lyricPaints[0].height / 2;

//  2.然后判断当前偏移量是否超出或小于当前的size，如果超出则不画
    for (int i = 0; i < lyric.length; i++) {
      if (y > size.height || y < (0 - lyricPaints[i].height / 2)) {
      } else {
        // 画每一行歌词
        // 判断条件：当前循环的 i 是否等于查找出来的 index，如果等于那么则高亮显示，如果不是，则还是原来的颜色。
        if (curLine == i) {
          // 如果是当前行
          lyricPaints[i].text = TextSpan(text: lyric[i].lyric, style: commonWhiteTextStyle);
          lyricPaints[i].layout();
        } else if (isDragging &&
            i == (_offsetY / (lyricPaints[0].height + ScreenUtil().setWidth(30))).abs().round() - 1) {
          // 如果是拖动状态中的当前行
          lyricPaints[i].text = TextSpan(text: lyric[i].lyric, style: commonWhite70TextStyle);
          lyricPaints[i].layout();
        } else {
          lyricPaints[i].text = TextSpan(text: lyric[i].lyric, style: commonGrayTextStyle);
          lyricPaints[i].layout();
        }

        lyricPaints[i].paint(
          canvas,
          Offset((size.width - lyricPaints[i].width) / 2, y),
        );
      }
      // 计算偏移量
      y += lyricPaints[i].height + ScreenUtil().setWidth(30);
      lyric[i].offset = y;
    }

    // 拖动状态下显示横线
    if (isDragging) {
      // 画 icon
      final icon = Icons.play_arrow;
      var builder = prefix0.ParagraphBuilder(prefix0.ParagraphStyle(
        fontFamily: icon.fontFamily,
        fontSize: ScreenUtil().setWidth(60),
      ))
        ..addText(String.fromCharCode(icon.codePoint));
      var para = builder.build();
      para.layout(prefix0.ParagraphConstraints(
        width: ScreenUtil().setWidth(60),
      ));
      canvas.drawParagraph(
          para,
          Offset(ScreenUtil().setWidth(10),
              size.height / 2 - ScreenUtil().setWidth(60)));

      // 画线
      canvas.drawLine(
          Offset(ScreenUtil().setWidth(80),
              size.height / 2 - ScreenUtil().setWidth(30)),
          Offset(size.width - ScreenUtil().setWidth(120),
              size.height / 2 - ScreenUtil().setWidth(30)),
          linePaint);
      // 画当前行的时间
      dragLineTime = lyric[
              (_offsetY / (lyricPaints[0].height + ScreenUtil().setWidth(30)))
                      .abs()
                      .round() -
                  1]
          .startTime.inMilliseconds;
      draggingLineTimeTextPainter = TextPainter(
        text: TextSpan(
            text: DateUtil.formatDateMs(dragLineTime,
                format: "mm:ss"),
            style: smallGrayTextStyle),
        textDirection: TextDirection.ltr,
      );
      draggingLineTimeTextPainter.layout();
      draggingLineTimeTextPainter.paint(
          canvas,
          Offset(size.width - ScreenUtil().setWidth(80),
              size.height / 2 - ScreenUtil().setWidth(45)));
    }
  }

  /// 计算传入行和第一行的偏移量
  double computeScrollY(int curLine) {
    return (lyricPaints[0].height + ScreenUtil().setWidth(30)) * (curLine + 1);
  }

  void _layoutTextPainters() {
    lyricPaints.forEach((lp) => lp.layout());

    // 延迟一下计算总高度
    Future.delayed(Duration(milliseconds: 300), () {
      totalHeight = (lyricPaints[0].height + ScreenUtil().setWidth(30)) *
          (lyricPaints.length - 1);
    });
  }

//判断两次的 _offsetY 是否一致，如果不一致，就重绘。
  @override
  bool shouldRepaint(LyricWidget oldDelegate) {
    return oldDelegate._offsetY != _offsetY || oldDelegate.isDragging != isDragging;
  }
}
