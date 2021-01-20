import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:huantin/provider/feedback_model.dart';
import 'package:huantin/provider/play_songs_model.dart';
import 'package:provider/provider.dart';

import 'common_text_style.dart';
import 'h_empty_view.dart';

typedef FeedbackCallback = void Function(FeedbackModel model);

class FeedbackHeader extends StatelessWidget implements PreferredSizeWidget {
  FeedbackHeader({this.count, this.tail, this.onTap});

  final int count;
  final Widget tail;
  final FeedbackCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.vertical(
          top: Radius.circular(ScreenUtil().setWidth(30))),
      child: Container(
        color: Colors.white,
        child: Consumer<FeedbackModel>(builder: (context, model, child) {
          return Container(
            child: SizedBox.fromSize(
              size: preferredSize,
              child: Row(
                children: <Widget>[

                  Padding(
                    padding: const EdgeInsets.only(top: 3.0),
                    child: count == null
                        ? Container()
                        : Text(
                      "  共$count条 ",
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                  Spacer(),
                  tail ?? Container(),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(ScreenUtil().setWidth(100));
}
