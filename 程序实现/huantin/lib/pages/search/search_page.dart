import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:huantin/application.dart';
import 'package:huantin/model/hot_search.dart';
import 'package:huantin/model/hot_search_kugou.dart';
import 'package:huantin/model/hot_search_qq.dart';
import 'package:huantin/pages/search/search_multiple_result_page.dart';
import 'package:huantin/pages/search/search_other_result_page.dart';
import 'package:huantin/provider/play_songs_model.dart';
import 'package:huantin/utils/net_utils.dart';
import 'package:huantin/utils/utils.dart';
import 'package:huantin/widgets/common_text_style.dart';
import 'package:huantin/widgets/h_empty_view.dart';
import 'package:huantin/widgets/v_empty_view.dart';
import 'package:huantin/widgets/widget_future_builder.dart';
import 'package:huantin/widgets/widget_play.dart';
import 'package:provider/provider.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> with TickerProviderStateMixin {
  List<String> historySearchList;
  TextEditingController _searchController = TextEditingController();
  FocusNode _blankNode = FocusNode();
  bool _isSearching = false; // 是否正在搜索，改变布局
  //type: 搜索类型；默认为 1 即单曲 , 取值意义 :
  // 1: 单曲,
  // 10: 专辑,
  // 100: 歌手,
  // 1000: 歌单,
  // 1002: 用户,
  // 1004: MV,
  // 1006: 歌词,
  // 1009: 电台,
  // 1014: 视频,
  // 1018: 综合
  Map<String, int> _searchingTabMap = {
    '单曲': 1,
    '专辑': 10,
    '歌手': 100,
    '歌单': 1000,
    '用户': 1002,
    //1014 视频可能会引起部分搜索内容失效，暂时取消
//    '视频': 1014,
  };
  List<String> _searchingTabKeys = ['综合'];  // 1018: 综合
  TabController _searchingTabController;
  String searchText;
  String defaultSearch;//默认搜索内容
  PlaySongsModel _playSongsModel;

  @override
  void initState() {
    super.initState();
    //初始化，加载历史记录
    historySearchList = Application.sp.getStringList("search_history") ?? [];
    _searchingTabKeys.addAll(_searchingTabMap.keys.toList());
    _searchingTabController = TabController(length: _searchingTabKeys.length, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((d) {
      if (mounted) {
        _playSongsModel = Provider.of<PlaySongsModel>(context);
      }
    });
    //从热门搜索列表（详细）中获取默认搜索文本内容，设置为第一个；
    NetUtils.getHotSearchData(context).then((value) => {
      defaultSearch = value.data[0].searchWord
    });

  }

  // 历史搜索
  Widget _buildHistorySearch() {
    return Offstage(
      offstage: historySearchList.isEmpty,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  '历史记录',
                  style: bold18TextStyle,
                ),
              ),
              //删除历史记录按钮
              IconButton(
                icon: Icon(
                  Icons.delete_outline,
                  color: Colors.grey,
                ),
                onPressed: () {
                  //显示提示
                  showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          content: Text(
                            "确定清空全部历史记录？",
                            style: common14GrayTextStyle,
                          ),
                          actions: <Widget>[
                            FlatButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text('取消'),
                              textColor: Colors.red,
                            ),
                            FlatButton(
                              onPressed: () {
                                setState(() {
                                  historySearchList.clear();
                                  Application.sp.remove("search_history");
                                });
                                Navigator.of(context).pop();
                              },
                              child: Text('清空'),
                              textColor: Colors.red,
                            ),
                          ],
                        );
                      });
                },
              )
            ],
          ),
          //历史记录标签
          Wrap(
            //1.用 Wrap 包裹住 chip
            //2.设置每个 chip 的间隔为 20
            spacing: ScreenUtil().setWidth(20),
            //3.根据 historySearchList 的数据来返回 chip
            children: historySearchList
                .map((v) => GestureDetector(
                      onTap: () {
                        searchText = v;
                        _search();
                      },
                      child: Chip(
                        label: Text(
                          v,
                          style: common14TextStyle,
                        ),
                        //4.最后改变一下 chip 的背景颜色
                        backgroundColor: Color(0xFFf2f2f2),
                      ),
                    ))
                .toList(),
          ),
          VEmptyView(50),
        ],
      ),
    );
  }

  // 网易云热搜
  Widget _buildHotSearch() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          '网易云热搜榜',
          style: bold18TextStyle,
        ),
        VEmptyView(15),
        CustomFutureBuilder<HotSearchData>(
          //热门搜索列表（详细）
          futureFunc: NetUtils.getHotSearchData,
          builder: (context, data) {
            return ListView.builder(
              itemBuilder: (context, index) {
                var curData = data.data[index];
                return GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () {
                    searchText = curData.searchWord;
                    _search();
                  },
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: ScreenUtil().setWidth(10)),
                    child: Row(
                      children: <Widget>[
                        //搜索序号显示：前三个热搜，数字显示红色，后续数字显示灰色
                        Text(
                          '${index + 1}',
                          style: index < 3
                              ? bold18RedTextStyle
                              : bold18GrayTextStyle,
                        ),
                        HEmptyView(20),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: ScreenUtil().setWidth(5)),
                                child: Row(
                                  children: <Widget>[
                                    //搜索文字显示：前三个显示与后续
                                    Text(
                                      curData.searchWord,
                                      style: index < 3
                                          ? w500_16TextStyle
                                          : common16TextStyle,
                                    ),
                                    Offstage(
                                        offstage: curData.iconUrl == null,
                                        child: HEmptyView(10)),
                                    //标记的NEW或HOT图片
                                    curData.iconUrl == null || curData.iconUrl.isEmpty
                                        ? Container()
                                        : UnconstrainedBox(
                                            child: Utils.showNetImage(
                                              curData.iconUrl,
                                              height:
                                                  ScreenUtil().setHeight(18),
                                            ),
                                          ),
                                    Spacer(),
                                    Text(
                                      //score中存储热度数据，
                                      curData.score.toString(),
                                      style: common14GrayTextStyle,
                                      textAlign: TextAlign.right,
                                    ),
                                  ],
                                ),
                              ),
                              Text(
                                //content中存储简介文本
                                curData.content,
                                style: common13GrayTextStyle,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
              itemCount: 6,    //全部显示使用data.data.length
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
            );
          },
        )
      ],
    );
  }

  // QQ音乐热搜
  Widget _buildQQHotSearch() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'QQ音乐热搜榜',
          style: bold18TextStyle,
        ),
        VEmptyView(15),
        CustomFutureBuilder<HotSearchDataQQ>(
          //热门搜索列表（简略）
          futureFunc: NetUtils.getHotSearchDataQQ,
          builder: (context, data) {
            return ListView.builder(
              itemBuilder: (context, index) {
                var curData = data.data[index];
                return GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () {
                    searchText = curData.k;
                    _search();
                  },
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: ScreenUtil().setWidth(10)),
                    child: Row(
                      children: <Widget>[
                        //搜索序号显示：前三个热搜，数字显示红色，后续数字显示灰色
                        Text(
                          '${index + 1}',
                          style: index < 3
                              ? bold18RedTextStyle
                              : bold18GrayTextStyle,
                        ),
                        HEmptyView(20),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: ScreenUtil().setWidth(5)),
                                child: Row(
                                  children: <Widget>[
                                    //搜索文字显示：前三个显示与后续
                                    Text(
                                      curData.k,
                                      style: index < 3
                                          ? w500_16TextStyle
                                          : common16TextStyle,
                                    ),
                                    Spacer(),
                                    Text(
                                      //score中存储热度数据，
                                      curData.n.toString(),
                                      style: common14GrayTextStyle,
                                      textAlign: TextAlign.right,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
              itemCount: 6,    //全部显示使用data.data.length
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
            );
          },
        )
      ],
    );
  }

  // 酷狗音乐热搜
  Widget _buildKuGouHotSearch() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          '酷狗音乐热搜榜',
          style: bold18TextStyle,
        ),
        VEmptyView(15),
        CustomFutureBuilder<HotSearchDataKuGou>(
          //热门搜索列表（简略）
          futureFunc: NetUtils.getHotSearchDataKugou,
          builder: (context, data) {
            return ListView.builder(
              itemBuilder: (context, index) {
                var curData = data.data.info[index];
                return GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () {
                    searchText = curData.keyword;
                    _search();
                  },
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: ScreenUtil().setWidth(10)),
                    child: Row(
                      children: <Widget>[
                        //搜索序号显示：前三个热搜，数字显示红色，后续数字显示灰色
                        Text(
                          '${index + 1}',
                          style: index < 3
                              ? bold18RedTextStyle
                              : bold18GrayTextStyle,
                        ),
                        HEmptyView(20),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: ScreenUtil().setWidth(5)),
                                child: Row(
                                  children: <Widget>[
                                    //搜索文字显示：前三个显示与后续
                                    Text(
                                      curData.keyword,
                                      style: index < 3
                                          ? w500_16TextStyle
                                          : common16TextStyle,
                                    ),
                                    Spacer(),
                                    Text(
                                      //score中存储热度数据，
                                      '',
                                      style: common14GrayTextStyle,
                                      textAlign: TextAlign.right,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
              itemCount: 6,    //全部显示使用data.data.length
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
            );
          },
        )
      ],
    );
  }


  // 搜索
  void _search() {
    FocusScope.of(context).requestFocus(_blankNode);
    setState(() {
      //如果历史记录中存在该搜索记录，则先移除，再加入（为了使最新的记录放置在首位）
      if (historySearchList.contains(searchText))
        historySearchList.remove(searchText);
      //加入历史记录列表
      historySearchList.insert(0, searchText);
      if (historySearchList.length > 5) {
        historySearchList.removeAt(historySearchList.length - 1);
      }
      _isSearching = true;
      _searchController.text = searchText;
    });
    //更新缓存中的历史记录
    Application.sp.setStringList("search_history", historySearchList);
  }

  // 构建未搜索时的布局
  Widget _buildUnSearchingPage() {
    return ListView(
      padding: EdgeInsets.symmetric(
          horizontal: ScreenUtil().setWidth(40),
          vertical: ScreenUtil().setWidth(30)),
      children: <Widget>[
        //搜索历史记录
        _buildHistorySearch(),
        //热搜列表（详细）
        _buildHotSearch(),
        VEmptyView(20),
        _buildQQHotSearch(),
//        VEmptyView(20),
//        _buildKuGouHotSearch(),
      ],
    );
  }

  // 构建搜索中的布局
  Widget _buildSearchingPage() {
    return Column(
      children: <Widget>[
        TabBar(
          indicatorColor: Colors.red,
          labelColor: Colors.red,
          unselectedLabelColor: Colors.black87,
          isScrollable: true,
          indicatorSize: TabBarIndicatorSize.label,
          //综合、单曲、专辑、歌手、歌单、用户、视频 tab页
          tabs: _searchingTabKeys
              .map((key) => Tab(
                    text: key,
                  ))
              .toList(),
          controller: _searchingTabController,
        ),
        Expanded(
          child: TabBarView(
            children: [
              SearchMultipleResultPage(searchText, onTapMore: (value) {
                _searchingTabController.animateTo(value);
              }, onTapSimText: (text){
                searchText = text;
                _search();
              },),
              ..._searchingTabMap.keys
                  .map((key) => SearchOtherResultPage(
                      _searchingTabMap[key].toString(), searchText))
                  .toList()
            ],
            controller: _searchingTabController,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          title: Theme(
            child: TextField(
              controller: _searchController,
              cursorColor: Colors.red,
              textInputAction: TextInputAction.search,
              //输入回车（搜索）
              onEditingComplete: () {
                //若没有输入搜索内容，则默认搜索
                searchText = _searchController.text.isEmpty
                    ? defaultSearch
                    : _searchController.text;
                _search();
              },
              textAlignVertical: TextAlignVertical.center,
              decoration: InputDecoration(
                hintText: defaultSearch,
                hintStyle: commonGrayTextStyle,
                suffixIcon: IconButton(
                    padding: EdgeInsets.zero,
                    icon: Icon(
                      Icons.clear,
                      color: Colors.black87,
                    ),
                    onPressed: () {
                      //若文本框不为空，则清除文本内容
                      if (_searchController.text.isNotEmpty)
                        setState(() {
                          _searchController.text = "";
                        });
                    }),
              ),
            ),
            data: Theme.of(context).copyWith(primaryColor: Colors.black54),
          ),
        ),
        body: Listener(
          onPointerDown: (d) {
            FocusScope.of(context).requestFocus(_blankNode);
          },
          child: Stack(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(bottom: ScreenUtil().setWidth(80)),
                child: _isSearching
                    ? _buildSearchingPage()     //搜索中（呈现搜索内容）
                    : _buildUnSearchingPage(),  //未搜索（呈现热搜内容）
              ),
              PlayWidget(),
            ],
          ),
        ),
      ),
      onWillPop: () async {
        if (_isSearching) {
          // 如果是搜索的状态，则不返回，并且清空输入框
          setState(() {
            _searchController.text = "";
            _isSearching = false;
          });
          return false;
        }
        return true;
      },
    );
  }
}
