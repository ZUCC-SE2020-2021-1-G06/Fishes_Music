import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:dio/dio.dart';
import 'package:huantin/pages/loginLocal/loginLocal_page.dart';
import 'package:huantin/provider/local_user_model.dart';
import 'package:huantin/provider/user_model.dart';
import 'package:huantin/utils/navigator_util.dart';
import 'package:huantin/utils/utils.dart';
import 'package:huantin/widgets/login_button.dart';
import 'package:huantin/widgets/v_empty_view.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:huantin/widgets/widget_round_img.dart';
import 'package:provider/provider.dart';

import '../../application.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage>
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
            NavigatorUtil.goLoginLocalPage(context);
          },
        ),
        title: Text(
          "注册",
          style: TextStyle(fontSize: 25),
        ),
        elevation: 0, //去除阴影
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(
            left: ScreenUtil().setWidth(10),
          ),
          child: Column(
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

class _RegisterWidget extends StatefulWidget {
  @override
  __RegisterWidgetState createState() => __RegisterWidgetState();
}

class __RegisterWidgetState extends State<_RegisterWidget> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _repwdController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(primaryColor: Color(0xFF18E3B7)),
      child: Column(
        children: [
          VEmptyView(30),
          Container(
            padding: EdgeInsets.only(left: ScreenUtil().setWidth(90)),
            alignment: Alignment.centerLeft,
            child:Text("设置您的用户名和密码",
              style: TextStyle(fontSize: 15, color: Colors.black45),
            ),
          ),

          VEmptyView(30),
          //Container()
          Form(
            key: _formKey,
            child: Column(children: <Widget>[
              Container(
                width: ScreenUtil().setWidth(500),
                alignment: Alignment.center,
                child: TextFormField(
                  controller: _usernameController,
                  keyboardType: TextInputType.phone,
                  style: TextStyle(fontSize: 20, color: Colors.black),
                  maxLength: 20,
                  maxLengthEnforced: true,
                  cursorColor: Color(0xFF18E3B7),
                  decoration: InputDecoration(
                      hintText: '用户名',
                      errorStyle: TextStyle(fontSize: 15)),
                  validator: (value) {
                    if (value.trim().length > 20 ||
                        value.trim().length <= 0) {
                      return "请设置您用户名";
                    } else
                      return null;
                  },
                ),
              ),
              Container(
                width: ScreenUtil().setWidth(500),
                alignment: Alignment.center,
                child: TextFormField(
                  controller: _passwordController,
                  keyboardType: TextInputType.phone,
                  style: TextStyle(fontSize: 20, color: Colors.black),
                  obscureText: true,
                  maxLength: 20,
                  maxLengthEnforced: true,
                  cursorColor: Color(0xFF18E3B7),
                  decoration: InputDecoration(
                      hintText: '密码',
                      errorStyle: TextStyle(fontSize: 15)),
                  validator: (value) {
                    if (value.trim().length > 20 ||
                        value.trim().length <= 0) {
                      return "请设置您的密码";
                    } else
                      return null;
                  },

                ),
              ),
              Container(
                width: ScreenUtil().setWidth(500),
                alignment: Alignment.center,
                child: TextFormField(
                  controller: _repwdController,
                  keyboardType: TextInputType.phone,
                  style: TextStyle(fontSize: 20, color: Colors.black),
                  obscureText: true,
                  maxLength: 20,
                  maxLengthEnforced: true,
                  cursorColor: Color(0xFF18E3B7),
                  decoration: InputDecoration(
                      hintText: '确认密码',
                      errorStyle: TextStyle(fontSize: 15)),
                  validator: (value) {
                    if (_passwordController.text != _repwdController.text) {
                      return "两次密码输入不一致";
                    } else if(value.trim().length <=0 || value.trim().length >=20){
                      return "请再次输入密码";
                    }
                    else
                      return null;
                  },

                ),
              ),
            ]),
          ),

          VEmptyView(30),
          Container(
              height: 100.0,
              alignment: Alignment.center,
              child: LoginButton(
                content: "下一步",
                width: ScreenUtil().setWidth(300),
                callback: () async {
                  if ((_formKey.currentState as FormState).validate()) {
                    String username = _usernameController.text;
                    String password = _passwordController.text;
                    LocalUserModel()
                        .register(context, username, password)
                        .then((value) {
                      if (value != null) {
                        Provider.of<LocalUserModel>(context).localUser= value;
                        NavigatorUtil.goHomePage(context);
                      }
                    });
                  }
                },
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
        child: _RegisterWidget(),
      ),
    );
  }
}
