import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:huantin/application.dart';
import 'package:huantin/model/feedback.dart';
import 'package:huantin/provider/feedback_model.dart';
import 'package:huantin/provider/local_user_model.dart';
import 'package:huantin/utils/navigator_util.dart';
import 'package:huantin/widgets/login_button.dart';
import 'package:huantin/widgets/v_empty_view.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:huantin/widgets/widget_feedback_appbar.dart';
import 'package:huantin/widgets/widget_play_history_app_bar.dart';
import 'package:provider/provider.dart';

class FeedbackListPage extends StatefulWidget {
  @override
  _FeedbackListPageState createState() => _FeedbackListPageState();
}

class _FeedbackListPageState extends State<FeedbackListPage>
    with TickerProviderStateMixin {
  FeedbackModel _feedbackModel;
  double _expandedHeight = ScreenUtil().setWidth(340);
  int _count;

  AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    Future.delayed(Duration(milliseconds: 500), () {
      _controller.forward();
    });
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
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.chevron_left),
          iconSize: 40,
          onPressed: () {
            NavigatorUtil.goHomePage(context);
          },
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            iconSize: 40,
            onPressed: (){
              NavigatorUtil.goFeedbackUserPage(context);
            },
          )
        ],

        elevation: 0, //去除阴影
      ),
      body: Stack(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(
                bottom:
                ScreenUtil().setWidth(80) + Application.bottomBarHeight),
            child: CustomScrollView(
              slivers: <Widget>[
                //背景图片
                FeedbackAppBarWidget(
                  backgroundImg: 'images/bg_history.jpg',
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
                          '衷心感谢您的反馈建议',
                          style: TextStyle(fontSize: 14, color: Colors.white70),
                        ),
                      ),
                    ],
                  ),
                  expandedHeight: _expandedHeight,
                  title: '反馈建议',
                ),
              /*Consumer<LocalUserModel>(builder: (_, model, __){
                var localUser = model.localUser;
                if(localUser == null){
                  return LoginButton(
                      callback: null,
                      content: null);
                }
                else{*/
                  /*Consumer<FeedbackModel>(builder: (context, model, child) {
                    model.loadFeedback(localUser.username)
                    List<FeedbackLocal> feedbackList = model.load();
                    setCount(feedbackList);
                    return Container(

                    )SliverList(
                        delegate: SliverChildBuilderDelegate((context, index) {
                          return WidgetFeedbackListItem(
                            MusicData(
                              //设置mvid为1，放置播放按钮
                              mvid: 1,
                              index: index + 1,
                              songName: hs[index].name,
                              artists: hs[index].artists,
                            ),
                            onTap: () {
                              //通过返回的url判断是否可以播放，准确性更高，但是暂时无法输出原因
                              NetUtils.getMusicURL(null, hs[index].id)
                                  .then((value) => {
                                if (value == null)
                                  {Utils.showToast("暂时无法播放")}
                                else
                                  playSongs(model, hs[index])
                              });
                            },
                          );
                        }, childCount: hs.length));
                  }
                }
              }
                )*/
              ],
            ),
          ),

        ],
      ),
    );
  }
}



class _LoginAnimatedWidget extends AnimatedWidget {
  final Tween<double> _opacityTween = Tween(begin: 0, end: 1);
  final Tween<double> _offsetTween = Tween(begin: 40, end: 0);
  final Animation animation;

  _LoginAnimatedWidget({
    @required this.animation,
  }) : super(listenable: animation);

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: _opacityTween.evaluate(animation),
      child: Container(
        margin: EdgeInsets.only(top: _offsetTween.evaluate(animation)),
       // child: _FeedbackListWidget(),
      ),
    );
  }
}
