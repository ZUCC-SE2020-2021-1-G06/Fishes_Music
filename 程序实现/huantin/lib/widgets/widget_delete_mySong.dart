import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:huantin/model/play_list.dart';

import 'common_text_style.dart';

typedef SubmitCallback = Function(bool delete);

class DeleteMySongWidget extends StatefulWidget {
  final SubmitCallback submitCallback;

  DeleteMySongWidget({@required this.submitCallback});

  @override
  _DeleteMySongWidgetState createState() => _DeleteMySongWidgetState();
}

class _DeleteMySongWidgetState extends State<DeleteMySongWidget> {
  bool delete = false;
  SubmitCallback submitCallback;

  @override
  void initState() {
    super.initState();

    submitCallback = widget.submitCallback;

  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        '确定要取消收藏这首歌曲吗？',
        style: bold16TextStyle,
      ),
      shape: RoundedRectangleBorder(
          borderRadius:
          BorderRadius.all(Radius.circular(ScreenUtil().setWidth(20)))),
      actions: <Widget>[
        FlatButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text('取消'),
          textColor: Colors.red,
        ),
        FlatButton(
          onPressed: () {
            delete = true;
            submitCallback(delete);
          },
          child: Text('删除'),
          textColor: Colors.red,
        ),
      ],
    );
  }
}
