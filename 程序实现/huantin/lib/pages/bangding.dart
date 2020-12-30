import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:huantin/provider/play_list_model.dart';
import 'package:huantin/provider/user_model.dart';
import 'package:huantin/utils/navigator_util.dart';
import 'package:huantin/utils/utils.dart';
import 'package:huantin/widgets/common_button.dart';
import 'package:huantin/widgets/common_button_back.dart';
import 'package:huantin/widgets/common_button_blue.dart';
import 'package:huantin/widgets/common_button_green.dart';
import 'package:huantin/widgets/common_button_yellow.dart';
import 'package:huantin/widgets/v_empty_view.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:huantin/widgets/widget_round_img.dart';
import 'package:provider/provider.dart';

import '../application.dart';

class BdPage extends StatefulWidget {
  @override
  _BdPageState createState() => _BdPageState();
}

class _BdPageState extends State<BdPage> with TickerProviderStateMixin {
  Animation<double> _animation;
  AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: Duration(milliseconds: 300));
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
        backgroundColor: Colors.white,
        elevation: 0,
        brightness: Brightness.light,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(
            left: ScreenUtil().setWidth(80),
            right: ScreenUtil().setWidth(80),
            top: ScreenUtil().setWidth(30),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _LoginAnimatedWidget(
                animation: _animation,
              ),
              CommonButtonBack(
                callback: () {
                  NavigatorUtil.goHomePage(context);
                },
                content: '返  回',
                width: double.infinity,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BdWidget extends StatefulWidget {
  @override
  __BdWidgetState createState() => __BdWidgetState();
}

class __BdWidgetState extends State<_BdWidget> {

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(primaryColor: Colors.red),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          VEmptyView(200),
          Consumer<UserModel>(
            builder: (_, model, __) {
              var user = model.user;
              if(user != null){
                return Column(
                    children: <Widget>[
                      RoundImgWidget(user.profile.avatarUrl, 140.w),
                      VEmptyView(20),
                      CommonButtonBack(
                        callback: () {
                          model.logout(context);
                          NavigatorUtil.goSplashPage(context);
                        },
                        content: '解除网易云音乐绑定',
                        width: double.infinity,
                      ),
                    ]
                );
              }else
                return CommonButton(
                  callback: () {
                    NavigatorUtil.goLoginPage(context);
                  },
                  content: '登录网易云音乐',
                  width: double.infinity,
                );
            },
          ),
          VEmptyView(30),
          CommonButtonGreen(
            callback: () {

            },
            content: '登录QQ音乐',
            width: double.infinity,
          ),
          VEmptyView(30),
          CommonButtonBlue(
            callback: () {

            },
            content: '登录酷狗音乐',
            width: double.infinity,
          ),
          VEmptyView(30),
          CommonButtonYellow(
            callback: () {

            },
            content: '登录酷我音乐',
            width: double.infinity,
          ),
          VEmptyView(30),
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
        child: _BdWidget(),
      ),
    );
  }
}
