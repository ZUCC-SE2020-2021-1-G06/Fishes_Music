import 'dart:async';

import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:huantin/application.dart';
import 'package:huantin/model/daily_songs.dart';
import 'package:huantin/model/feedback.dart';
import 'package:huantin/model/music.dart';
import 'package:huantin/model/song.dart';
import 'package:huantin/provider/feedback_model.dart';
import 'package:huantin/provider/local_user_model.dart';
import 'package:huantin/provider/play_list_model.dart';
import 'package:huantin/provider/play_songs_model.dart';
import 'package:huantin/utils/navigator_util.dart';
import 'package:huantin/utils/net_utils.dart';
import 'package:huantin/utils/utils.dart';
import 'package:huantin/widgets/login_button.dart';
import 'package:huantin/widgets/v_empty_view.dart';
import 'package:huantin/widgets/widget_feedback_admin_appbar.dart';
import 'package:huantin/widgets/widget_feedback_admin_item.dart';
import 'package:huantin/widgets/widget_feedback_appbar.dart';
import 'package:huantin/widgets/widget_feedback_list_item.dart';
import 'package:huantin/widgets/widget_music_list_item.dart';
import 'package:huantin/widgets/widget_play.dart';
import 'package:huantin/widgets/widget_play_history_app_bar.dart';
import 'package:huantin/widgets/widget_play_list_app_bar.dart';
import 'package:huantin/widgets/widget_sliver_future_builder.dart';
import 'package:provider/provider.dart';



class FeedbackAdminPage extends StatefulWidget {
  @override
  _FeedbackAdminPageState createState() => _FeedbackAdminPageState();
}

class _FeedbackAdminPageState extends State<FeedbackAdminPage> {
  FeedbackModel _feedbackModel;
  double _expandedHeight = ScreenUtil().setWidth(340);
  int _count;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((d) {
      if (mounted) {
        _feedbackModel = Provider.of<FeedbackModel>(context);
      }
    });
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
                //背景图片
                FeedbackAdminAppBarWidget(
                  backgroundImg: 'images/bg_feedback.jpg',
                  count: _count,
                  content: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Spacer(),
                      Container(
                        padding:
                        EdgeInsets.only(left: ScreenUtil().setWidth(40)),
                        margin:
                        EdgeInsets.only(bottom: ScreenUtil().setWidth(5)),
                        //设置时间
                        child: RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                  text:
                                  '${DateUtil.formatDate(DateTime.now(), format: 'dd')} ',
                                  style: TextStyle(fontSize: 30)),
                              TextSpan(
                                  text:
                                  '/ ${DateUtil.formatDate(DateTime.now(), format: 'MM')}月',
                                  style: TextStyle(fontSize: 16)),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        padding:
                        EdgeInsets.only(left: ScreenUtil().setWidth(40)),
                        margin:
                        EdgeInsets.only(bottom: ScreenUtil().setWidth(20)),
                        child: Text(
                          '衷心感谢您对管理做出的贡献',
                          style: TextStyle(fontSize: 14, color: Colors.white70),
                        ),
                      ),
                    ],
                  ),
                  expandedHeight: _expandedHeight,
                  title: '反馈建议',
                ),

                Consumer2<FeedbackModel, LocalUserModel>(
                    builder: (context, model, model2, child) {
                      var localUser = model2.localUser;
                      if (localUser == null) {
                        return SliverList(
                            delegate: SliverChildBuilderDelegate((context, index) {
                              return LoginButton(
                                callback: () {
                                  NavigatorUtil.goLoginLocalPage(context);
                                },
                                content: "请先登录",
                                fontSize: 22,
                              );
                            }, childCount: 1));
                      } else {
                        model.loadAllFeedback();
                        List<FeedbackLocal> feedbackList = model.load();
                        setCount(feedbackList.length);
                        return SliverList(
                            delegate: SliverChildBuilderDelegate((context, index) {
                              return WidgetFeedbackAdminItem(
                                FeedbackLocal(
                                    index: index + 1,
                                    id:feedbackList[index].id,
                                    username:feedbackList[index].username,
                                    suggestion: feedbackList[index].suggestion,
                                    state: feedbackList[index].state),
                              );
                            }, childCount: feedbackList.length));
                      }
                    })
              ],
            ),
          ),
        ],
      ),
    );
  }

  void setCount(int count) {
    Future.delayed(Duration(milliseconds: 300), () {
      if (mounted) {
        setState(() {
          _count = count;
        });
      }
    });
  }
}
