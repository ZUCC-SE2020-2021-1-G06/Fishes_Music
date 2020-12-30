import 'package:extended_image/extended_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:huantin/model/lyric.dart';

class Utils {
  static void showToast(String msg) {
    Fluttertoast.showToast(msg: msg, gravity: ToastGravity.CENTER);
  }

  static Widget showNetImage(String url,
      {double width, double height, BoxFit fit}) {
    return Image(
      image: ExtendedNetworkImageProvider(url, cache: true),
      width: width,
      height: height,
      fit: fit,
    );
  }


  /*
  所有的歌词的格式都是：
  所有的标签都是由 [] 包裹起来
  "ti"表示标题、"ar"表示歌手、"al"表示专辑、"by"表示制作、"offset:"表示时间偏移量
  [mm:ss.ms] 是这一行歌词的时间
 */
  /// 格式化歌词
  static List<Lyric> formatLyric(String lyricStr) {

//    1.首先根据\n 来切割字符串
//    2.然后用正则reg挑选出所有带时间的行
    RegExp reg = RegExp(r"^\[\d{2}");
    List<Lyric> result = lyricStr.split("\n").where((r) => reg.hasMatch(r)).map((s) {
      String time = s.substring(0, s.indexOf(']'));
      String lyric = s.substring(s.indexOf(']') + 1);
      time = s.substring(1, time.length - 1);
      int hourSeparatorIndex = time.indexOf(":");
      int minuteSeparatorIndex = time.indexOf(".");
//    3.循环列表创建 Lyric 类，赋值当前文字和起始时间
      return Lyric(
        //当前文字
        lyric,
        //起始时间
        startTime: Duration(
          //分钟
          minutes: int.parse(
            time.substring(0, hourSeparatorIndex),
          ),
          //秒钟
          seconds: int.parse(
              time.substring(hourSeparatorIndex + 1, minuteSeparatorIndex)),
          milliseconds: int.parse(time.substring(minuteSeparatorIndex + 1)),
        ),
      );
    }).toList();
//  4.最后再循环一次，把下一个的起始时间赋值到当前行的结束时间中
    for (int i = 0; i < result.length - 1; i++) {
      result[i].endTime = result[i + 1].startTime;
    }
    result[result.length - 1].endTime = Duration(hours: 1);
    return result;
  }


  /*
  当前歌词高亮展示，判断当前歌词；
  歌词对象当中含有三个属性：
  1.lyric：当前歌词/文字
  2.startTime：当前歌词/文字起始时间
  3.endTime：当前歌词/文字结束时间
  当歌曲播放时间变化以后，通过当前播放时间来循环列表，判断时间戳是否在某一行内
  可以通过当前播放时间来找到当前所在的行数i
  */
  /// 查找歌词
  static int findLyricIndex(double curDuration, List<Lyric> lyrics) {
    for (int i = 0; i < lyrics.length; i++) {
      if (curDuration >= lyrics[i].startTime.inMilliseconds &&
          curDuration <= lyrics[i].endTime.inMilliseconds) {
        return i;
      }
    }
    return 0;
  }
}
