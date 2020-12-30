import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:huantin/model/play_list.dart';

import 'common_text_style.dart';

typedef SubmitCallback = Function(bool delete);

class DeletePlayListWidget extends StatefulWidget {
  final SubmitCallback submitCallback;

  DeletePlayListWidget({@required this.submitCallback});

  @override
  _DeletePlayListWidgetState createState() => _DeletePlayListWidgetState();
}

class _DeletePlayListWidgetState extends State<DeletePlayListWidget> {
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
        '确定要删除此歌单吗？',
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
