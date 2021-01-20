import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:huantin/model/feedback.dart';
import 'package:huantin/widgets/v_empty_view.dart';

import '../application.dart';
import 'common_text_style.dart';
import 'h_empty_view.dart';

class WidgetFeedbackListItem extends StatelessWidget {
  final FeedbackLocal _data;
  final VoidCallback onTap;

  WidgetFeedbackListItem(this._data, {this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: onTap,
      child: Container(
        width: Application.screenWidth,
        height: ScreenUtil().setWidth(120),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            _data.suggestion == null
                ? Container()
                : Container(
              alignment: Alignment.center,
              width: ScreenUtil().setWidth(60),
              height: ScreenUtil().setWidth(50),
              child: Text(
                _data.index.toString(),
                style: mGrayTextStyle,
              ),
            ),
            _data.suggestion == null
                ? Container()
                : HEmptyView(10),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    _data.suggestion,
                    maxLines: 5,
                    overflow: TextOverflow.ellipsis,
                    style: commonTextStyle,
                  ),
                  VEmptyView(10),

                ],
              ),
            ),
            Align(
                  alignment: Alignment.center,
                  child: Text(
                      _data.state + "       ",
                      style: (_data.state == "已读")?TextStyle(color: Colors.green,fontSize: 15):TextStyle(fontSize: 15),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),

              ),


          ],
        ),
      ),
    );
  }
}
