import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:huantin/model/recommend.dart';
import 'package:huantin/model/top_list.dart';
import 'package:huantin/provider/play_songs_model.dart';
import 'package:huantin/utils/navigator_util.dart';
import 'package:huantin/utils/net_utils.dart';
import 'package:huantin/utils/utils.dart';
import 'package:huantin/widgets/common_text_style.dart';
import 'package:huantin/widgets/h_empty_view.dart';
import 'package:huantin/widgets/rounded_net_image.dart';
import 'package:huantin/widgets/v_empty_view.dart';
import 'package:huantin/widgets/widget_future_builder.dart';
import 'package:huantin/widgets/widget_play.dart';
import 'package:provider/provider.dart';


class TopListPage extends StatefulWidget {
  @override
  _TopListPageState createState() => _TopListPageState();
}

class _TopListPageState extends State<TopListPage> {
  PlaySongsModel _playSongsModel;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((d) {
      if (mounted) {
        _playSongsModel = Provider.of<PlaySongsModel>(context);
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('排行榜'),
        centerTitle: true,
        elevation: 0,
      ),
      body: Stack(
        children: <Widget>[
          CustomFutureBuilder<TopListData>(
            futureFunc: NetUtils.getTopListData,
            builder: (context, data) {
              /*
              根据接口返回值，该接口 list 参数中不一样的地方：
              1.网易云官方排行榜单中，tracks 中有前三首歌曲
              2.网易云更多榜单中，tracks 中内容为空
              官方榜单和更多榜单的区别！
              既然如此，构建排行榜页面的代码如下：
              1.只需要判断 tracks 的数据是否为空，以此区分官方榜单与更多榜单。
              2.然后就只需要根据各自的数据来创建歌单列表。
              * */
              var officialTopListData = data.list.where((l) => l.tracks.isNotEmpty).toList(); // 官方榜的数据
              var moreTopListData = data.list.where((l) => l.tracks.isEmpty).toList(); // 更多榜单的数据

              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    ListView.separated(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      padding: EdgeInsets.only(
                          top: ScreenUtil().setWidth(40),
                          left: ScreenUtil().setWidth(40)),
                      itemBuilder: (context, index) {
                        //这里「官方榜」文本也是列表的一部分，为officialTopListData[0]。所以在点击 index 的时候，需要index - 1。
                        if (index == 0) {
                          return Text(
                            '网易云音乐官方榜',
                            style: bold20TextStyle,
                          );
                        } else {
                          var d = officialTopListData[index - 1];
                          var i = 1; //排行榜名次
                          return GestureDetector(
                            behavior: HitTestBehavior.translucent,
                            onTap: (){
                              toPlayListPage(d);
                            },
                            child: Container(
                              height: ScreenUtil().setWidth(200),
                              child: Row(
                                children: <Widget>[
                                  Stack(
                                    children: <Widget>[
                                      RoundedNetImage(
                                        '${d.coverImgUrl}?param=150y150',
                                        width: 200,
                                        height: 200,
                                        radius: 5,
                                      ),
                                      //图片下方的阴影，使用图片名为ck.9.png
                                      Positioned(
                                        bottom: 0,
                                        child: Image.asset(
                                          "images/ck.9.png",
                                          width: ScreenUtil().setWidth(200),
                                          height: ScreenUtil().setWidth(80),
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                      //更新频率文本，显示在榜单图片下方
                                      Positioned(
                                        child: Text(
                                          d.updateFrequency,
                                          style: smallWhiteTextStyle,
                                        ),
                                        left: ScreenUtil().setWidth(10),
                                        bottom: ScreenUtil().setWidth(10),
                                      )
                                    ],
                                  ),
                                  HEmptyView(20),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: d.tracks.map((t) {
                                        return Container(
                                          alignment: Alignment.centerLeft,
                                          height: ScreenUtil().setWidth(65),
                                          child: Text(
                                            '${i++}.${t.first} - ${t.second}',
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: common13TextStyle,
                                          ),
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }
                      },
                      itemCount: officialTopListData.length + 1,
                      separatorBuilder: (context, index) {
                        return VEmptyView(20);
                      },
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          top: ScreenUtil().setWidth(60),
                          bottom: ScreenUtil().setWidth(30),
                          left: ScreenUtil().setWidth(40)),
                      child: Text(
                        '更多榜单',
                        style: bold20TextStyle,
                      ),
                    ),
                    GridView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3, childAspectRatio: 1 / 1.2),
                      itemBuilder: (context, index) {
                        var d = moreTopListData[index];
                        return GestureDetector(
                          behavior: HitTestBehavior.translucent,
                          onTap: (){
                            toPlayListPage(d);
                          },
                          child: Align(
                            alignment: Alignment.topCenter,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Stack(
                                  children: <Widget>[
                                    RoundedNetImage(
                                      '${d.coverImgUrl}?param=150y150',
                                      width: 200,
                                      height: 200,
                                      radius: 5,
                                    ),
                                    Positioned(
                                      bottom: 0,
                                      child: Image.asset(
                                        "images/ck.9.png",
                                        width: ScreenUtil().setWidth(200),
                                        height: ScreenUtil().setWidth(80),
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                                    Positioned(
                                      child: Text(
                                        d.updateFrequency,
                                        style: smallWhiteTextStyle,
                                      ),
                                      left: ScreenUtil().setWidth(10),
                                      bottom: ScreenUtil().setWidth(10),
                                    )
                                  ],
                                ),
                                VEmptyView(10),
                                Container(
                                  child: Text(d.name, style: common13TextStyle,),
                                  width: ScreenUtil().setWidth(200),),
                              ],
                            ),
                          ),
                        );
                      },
                      itemCount: moreTopListData.length,
                    ),
                    Container(
                      height: ScreenUtil().setWidth(80)
                    ),
                  ],
                ),
              );
            },
          ),
          PlayWidget(),
        ],
      ),
    );
  }

  void toPlayListPage(TopList data){
    NavigatorUtil.goPlayListPage(context, data: Recommend(picUrl: data.coverImgUrl, name: data.name, playcount: data.playCount, id: data.id));
  }
}
