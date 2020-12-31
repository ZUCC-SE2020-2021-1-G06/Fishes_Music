import 'package:flutter/material.dart';
import 'package:huantin/provider/feedback_model.dart';
import 'package:huantin/provider/local_user_model.dart';
import 'package:huantin/utils/navigator_util.dart';
import 'package:huantin/widgets/login_button.dart';
import 'package:huantin/widgets/v_empty_view.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class FeedbackUserPage extends StatefulWidget {
  @override
  _FeedbackUserPageState createState() => _FeedbackUserPageState();
}

class _FeedbackUserPageState extends State<FeedbackUserPage>
    with TickerProviderStateMixin {
  Animation<double> _animation;
  AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    _animation = CurvedAnimation(parent: _controller, curve: Curves.linear);
    Future.delayed(Duration(milliseconds: 500), () {
      _controller.forward();
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
            NavigatorUtil.goFeedbackListPage(context);
          },
        ),
        elevation: 0, //去除阴影
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(
            left: ScreenUtil().setWidth(200),
            right: ScreenUtil().setWidth(200),
            top: ScreenUtil().setWidth(100),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _LoginAnimatedWidget(
                animation: _animation,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FeedbackUserWidget extends StatefulWidget {
  @override
  __FeedbackUserWidgetState createState() => __FeedbackUserWidgetState();
}

class __FeedbackUserWidgetState extends State<_FeedbackUserWidget> {
  final TextEditingController _suggestionController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(primaryColor: Color(0xFF18E3B7)),
      child:Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Consumer<LocalUserModel>(builder: (_, model, __){
              var localUser = model.localUser;
                return Container(
                    child:Form(
                        key: _formKey,
                        child: Column(
                          children: <Widget>[
                            VEmptyView(150),
                            Container(
                              width: ScreenUtil().setWidth(500),
                              alignment: Alignment.center,
                              child: TextFormField(
                                controller: _suggestionController,
                                keyboardType: TextInputType.phone,
                                style: TextStyle(fontSize: 20, color: Colors.black),
                                maxLength: 100,
                                maxLines: 10,
                                maxLengthEnforced: true,
                                cursorColor: Color(0xFF18E3B7),
                                decoration: InputDecoration(
                                  hintText: '请填写您的宝贵意见',
                                  border: OutlineInputBorder(
                                    //未选中时候的颜色
                                    borderRadius: BorderRadius.circular(5.0),
                                    borderSide: BorderSide(
                                      color: Color(0xFF18E3B7),
                                    ),
                                  ),
                                ),
                                validator: (value) {
                                  if (value.trim().length > 100 || value.trim().length <= 0) {
                                    return "请输入您的意见";
                                  } else
                                    return null;
                                },
                              ),
                            ),
                          VEmptyView(100),
                          /*Container(
                              child: Column(
                                children: <Widget>[
                                     LoginButton(
                                      callback: () {
                                        if ((_formKey.currentState as FormState).validate()) {
                                          String suggestion = _suggestionController.text;
                                          String username = localUser.username;
                                          FeedbackModel()
                                              .addSug(context, username, suggestion)
                                              .then((value){
                                            if (value != null) {
                                              NavigatorUtil.goHomePage(context);
                                            }
                                          });
                                        }
                                      },
                                      content: "提交",
                                      fontSize: 22,
                                      width: 250,
                                    ),
                                ],
                              )
                            ),*/
                        ],)
                    ),
                );
              }
        ),
          ]
      )
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
        child: _FeedbackUserWidget(),
      ),
    );
  }
}
