import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:huantin/model/feedback.dart';
import 'package:huantin/provider/feedback_model.dart';
import 'package:huantin/utils/utils.dart';
import 'package:huantin/widgets/v_empty_view.dart';
import 'package:provider/provider.dart';

import '../application.dart';
import 'common_text_style.dart';
import 'h_empty_view.dart';

class WidgetFeedbackAdminItem extends StatelessWidget {
  final FeedbackLocal _data;
  final VoidCallback onTap;

  WidgetFeedbackAdminItem(this._data, {this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: onTap,
      child: Container(
        width: Application.screenWidth,
        height: ScreenUtil().setWidth(150),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            _data.username == null
                ? Container()
                : Container(
              alignment: Alignment.center,
              width: ScreenUtil().setWidth(50),
              height: ScreenUtil().setWidth(50),
              child: Text(
                _data.index.toString(),
                style: mGrayTextStyle,
              ),
            ),
            _data.username == null
                ? Container()
                : HEmptyView(10),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    _data.username,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: commonTextStyle,
                  ),
                ],
              ),
              flex: 1,
            ),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    _data.suggestion,
                    maxLines: 6,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize:15),
                  ),
                ],
              ),
              flex: 4,
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
            Consumer<FeedbackModel>(builder: (context, model,child){
              return Align(
                alignment: Alignment.center,
                child: IconButton(
                  icon: Icon(Icons.done),
                  onPressed: () {
                    (_data.state == "未处理")? model.checkFeedback(_data.id.toString()): Utils.showToast('已处理');
                  },
                  color: Colors.grey,
                ),
              );
            })

          ],
        ),
      ),
    );
  }
}
