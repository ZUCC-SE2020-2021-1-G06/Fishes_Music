import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:huantin/provider/user_model.dart';
import 'package:huantin/utils/navigator_util.dart';
import 'package:huantin/widgets/common_text_style.dart';
import 'package:huantin/widgets/v_empty_view.dart';
import 'package:huantin/widgets/widget_play.dart';
import 'package:huantin/widgets/widget_round_img.dart';
import 'package:provider/provider.dart';
import '../../application.dart';
import 'discover/discover_page.dart';
import 'my/my_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  TabController _tabController;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 2);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      // 设置没有高度的 appbar，目的是为了设置状态栏的颜色
      appBar: PreferredSize(
        child: AppBar(
          elevation: 0,
        ),
        preferredSize: Size.zero,
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        bottom: false,
        child: Stack(
          children: <Widget>[
            Padding(
              child: Column(
                children: <Widget>[
                  Stack(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: ScreenUtil().setWidth(150)),
                        child: TabBar(
                          labelStyle: TextStyle(
                              fontSize: 30, fontWeight: FontWeight.bold),
                          unselectedLabelStyle: TextStyle(fontSize: 20),
                          indicator: UnderlineTabIndicator(),
                          controller: _tabController,
                          tabs: [
                            Tab(
                              text: '我的',
                            ),
                            Tab(
                              text: '发现',
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                        right: 20.w,
                        child: IconButton(
                          icon: Icon(
                            Icons.search,
                            size: 50.w,
                            color: Colors.black87,
                          ),
                          onPressed: () {
                            NavigatorUtil.goSearchPage(context);
                          },
                        ),
                      ),
                      Positioned(
                        left: 20.w,
                        child: IconButton(
                          icon: Icon(
                            Icons.menu,
                            size: 50.w,
                            color: Colors.black87,
                          ),
                          onPressed: () {
                            _scaffoldKey.currentState.openDrawer();
                          },
                        ),
                      ),
                    ],
                  ),
                  VEmptyView(20),
                  Expanded(
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        MyPage(),
                        DiscoverPage(),
                      ],
                    ),
                  ),
                  PlayWidget(),
                ],
              ),
              padding: EdgeInsets.only(
                  bottom:
                      ScreenUtil().setWidth(0) + Application.bottomBarHeight),
            ),
          ],
        ),
      ),
      drawer:Drawer(
        child: ListView(  //抽屉里面一个list部件
          padding: EdgeInsets.all(0), //顶部padding为0
          children: <Widget>[ //所有子部件
            UserAccountsDrawerHeader( //用户信息栏
              accountName: Container(
                padding: const EdgeInsets.only(top: 8.0),
                alignment: Alignment.bottomLeft,
                child: Text("集多音乐平台为一体的音乐播放APP",style:common14TextStyle),
              ),
              accountEmail: Container(
                margin: const EdgeInsets.all(0.0),
                padding: const EdgeInsets.all(0.0),
                alignment: Alignment.centerRight,
                child: Text("—— 《幻听》",style:common14TextStyle),
              ),
              currentAccountPicture: Container(
                margin: const EdgeInsets.only(bottom: 16.0),
                child:CircleAvatar(  //LOGO
                  backgroundImage: AssetImage('images/logo.png'),
                ),
              )
//              otherAccountsPictures: <Widget>[  //其他账号头像
//                CircleAvatar(backgroundImage: NetworkImage('https://t8.baidu.com/it/u=3571592872,3353494284&fm=79&app=86&size=h300&n=0&g=4n&f=jpeg'),),
//                CircleAvatar(backgroundImage: NetworkImage("http://b-ssl.duitang.com/uploads/item/201707/01/20170701155239_2E8zH.jpeg"),)
//              ],
//              onDetailsPressed: (){}, //下拉箭头
//              decoration: BoxDecoration(  //背景图片
//                image: DecorationImage(
//                    image: NetworkImage(''),
//                    fit: BoxFit.cover
//                ),
//              ),
            ),
            ListTile(   //下部标题
                leading: Icon(Icons.account_circle,size:36.0,color: Colors.black,),
                title: Text("登录",style:mCommonTextStyle),
                onTap:(){
                  NavigatorUtil.goLoginLocalPage(context);
                }
            ),
            ListTile(
              leading: Icon(Icons.add_to_home_screen,size:36.0,color: Colors.black,),
              title: Text("绑定账号",style:mCommonTextStyle),
              onTap: (){
                NavigatorUtil.goBDPage(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.delete,size:36.0,color: Colors.black,),
              title: Text("清理缓存",style:mCommonTextStyle),
            ),
            ListTile(
              leading: Icon(Icons.cached,size:36.0,color: Colors.black,),
              title: Text("更改主题",style:mCommonTextStyle),
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.help,size:36,color: Colors.black,),
              title: Text("反馈与建议",style:commonTextStyle),
              onTap:() {
                NavigatorUtil.goFeedbackListPage(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.info,size:36.0,color: Colors.black,),
              title: Text("关于幻听",style:commonTextStyle),
            ),
          ],
        ),
      ),
    );
  }
}
