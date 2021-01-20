import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:huantin/provider/local_user_model.dart';
import 'package:huantin/utils/navigator_util.dart';
import 'package:huantin/utils/utils.dart';
import 'package:huantin/widgets/widget_feedback_header.dart';
import 'package:provider/provider.dart';

import 'flexible_detail_bar.dart';

class FeedbackAdminAppBarWidget extends StatelessWidget {
  final double expandedHeight;
  final Widget content;
  final String backgroundImg;
  final String title;
  final String text; //播放全部、清除全部等文本
  final double sigma;
  final FeedbackCallback playOnTap;
  final int count;

  FeedbackAdminAppBarWidget({
    @required this.expandedHeight,
    @required this.content,
    @required this.title,
    @required this.backgroundImg,
    this.sigma = 5,
    this.playOnTap,
    this.count,
    this.text,
  });

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      leading: IconButton(
        icon: Icon(Icons.chevron_left),
        iconSize: 40,
        onPressed: () {
          NavigatorUtil.goHomePage(context);
        },
      ),
      centerTitle: true,
      expandedHeight: expandedHeight,
      pinned: true,
      elevation: 0,
      brightness: Brightness.dark,
      iconTheme: IconThemeData(color: Colors.white),
      title: Text(
        title,
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
//    实现滑上去的时候有一行还停留在上方，使用了SliverAppBar的bottom参数。
      bottom: FeedbackHeader(
        onTap: playOnTap,
        count: count,
      ),
      flexibleSpace: FlexibleDetailBar(
        content: content,
        background: Stack(
          children: <Widget>[
//          1.外部传入背景图片时，有可能是本地文件，也有可能是网络图片，所以直接在这里判断startsWith('http')
            backgroundImg.startsWith('http')
                ? Utils.showNetImage(
              '$backgroundImg?param=200y200',
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.cover,
            )
                : Image.asset(
              backgroundImg,
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.cover,
            ),
//          模糊背景
            BackdropFilter(
              filter: ImageFilter.blur(
                sigmaY: sigma,
                sigmaX: sigma,
              ),
//            2.模糊背景图片时，加一个 Colors.black38，这样省的后续有白色图片所导致文字看不清。
              child: Container(
                color: Colors.black38,
                width: double.infinity,
                height: double.infinity,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
