

import 'package:flutter/material.dart';
import 'package:huantin/provider/local_user_model.dart';
import 'package:huantin/utils/navigator_util.dart';
import 'package:huantin/widgets/login_button.dart';
import 'package:huantin/widgets/v_empty_view.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';


class LoginLocalPage extends StatefulWidget {
  @override
  _LoginLocalPageState createState() => _LoginLocalPageState();
}

class _LoginLocalPageState extends State<LoginLocalPage>
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
            NavigatorUtil.goHomePage(context);
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

class _LoginLocalWidget extends StatefulWidget {
  @override
  __LoginLocalWidgetState createState() => __LoginLocalWidgetState();
}

class __LoginLocalWidgetState extends State<_LoginLocalWidget> {
  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(primaryColor: Color(0xFF18E3B7)),
      child: Column(
        children: [
          Container(
            height: 200,
            width: 100,
            child: new Image(
              image: AssetImage("images/logo.png"),
              width: 100.0,
              fit: BoxFit.contain,
            ),
          ),
          VEmptyView(500),
          Container(
              child: Column(
            children: <Widget>[
              Consumer<LocalUserModel>(builder: (_, model, __) {
                var localUser = model.localUser;
                if (localUser != null) {
                  return LoginButton(
                    callback: () {
                      model.logout(context);
                      NavigatorUtil.goUsernameLoginPage(context);
                    },
                    content: "退出",
                    fontSize: 22,
                    width: 250,
                  );
                } else {
                  return Container(
                    child: Column(
                      children: <Widget>[
                        LoginButton(
                          callback: () {
                            NavigatorUtil.goUsernameLoginPage(context);
                          },
                          content: "登录",
                          fontSize: 22,
                          width: 250,
                        ),
                        VEmptyView(30),
                        LoginButton(
                          callback: () {
                            NavigatorUtil.goRegisterPage(context);
                          },
                          content: "注册",
                          fontSize: 22,
                          width: 250,
                        )
                      ],
                    ),
                  );
                }
              }),
            ],
          )),
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
        child: _LoginLocalWidget(),
      ),
    );
  }
}
