import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:huantin/provider/play_songs_model.dart';
import 'package:huantin/widgets/common_text_style.dart';

class SongProgressWidget extends StatelessWidget {
  final PlaySongsModel model;

  SongProgressWidget(this.model);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<String>(
      stream: model.curPositionStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          var totalTime =
          snapshot.data.substring(snapshot.data.indexOf('-') + 1);
          var curTime = double.parse(snapshot.data.substring(0, snapshot.data.indexOf('-')));
          var curTimeStr = DateUtil.formatDateMs(curTime.toInt(), format: "mm:ss");
          return buildProgress(curTime, totalTime, curTimeStr);
        } else {
          return buildProgress(0, "0", "00:00");
        }
      },
    );
  }

  Widget buildProgress(double curTime, String totalTime, String curTimeStr){
    return Container(
      height: ScreenUtil().setWidth(50),
      child: Row(
        children: <Widget>[
          Text(
            curTimeStr,
            style: smallWhiteTextStyle,
          ),
          Expanded(
            child: SliderTheme(
              data: SliderThemeData(
                trackHeight: ScreenUtil().setWidth(2),
                thumbShape: RoundSliderThumbShape(
                  enabledThumbRadius: ScreenUtil().setWidth(10),
                ),
              ),
              /*
              进度条使用的控件是Slider，设置几个参数：
              1.value：当前值
              2.onChanged：拖拽过程中
              3.onChangeStart：开始拖拽
              4.onChangeEnd：拖拽结束
              5.activeColor：活动过的color
              6.inactiveColor：还没活动过的color
              7.min：最小值
              8.max：最大值
               */
              child: Slider(
                value: curTime,
                onChanged: (data) {
                  model.sinkProgress(data.toInt());
                },
                onChangeStart: (data) {
                  model.pausePlay();
                },
                onChangeEnd: (data) {
                  model.seekPlay(data.toInt());
                },
                activeColor: Colors.white,
                inactiveColor: Colors.white30,
                min: 0,
                max: double.parse(totalTime),
              ),
            ),
          ),
          Text(
            DateUtil.formatDateMs(int.parse(totalTime), format: "mm:ss"),
            style: smallWhite30TextStyle,
          ),
        ],
      ),
    );
  }
}

