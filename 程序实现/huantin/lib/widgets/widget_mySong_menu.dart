import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:huantin/model/local_user.dart';
import 'package:huantin/model/music.dart';
import 'package:huantin/model/myMusic.dart';
import 'package:huantin/model/play_list.dart';
import 'package:huantin/provider/local_user_model.dart';
import 'package:huantin/provider/play_list_model.dart';
import 'package:huantin/provider/play_songs_model.dart';
import 'package:huantin/provider/user_model.dart';
import 'package:huantin/utils/net_utils.dart';
import 'package:huantin/utils/utils.dart';
import 'package:huantin/widgets/common_text_style.dart';
import 'package:huantin/widgets/rounded_net_image.dart';
import 'package:huantin/widgets/v_empty_view.dart';
import 'package:huantin/widgets/widget_delete_mySong.dart';
import 'package:huantin/widgets/widget_delete_play_list.dart';
import 'package:huantin/widgets/widget_edit_play_list.dart';
import 'package:huantin/widgets/widget_round_img.dart';
import 'package:provider/provider.dart';

class MySongMenuWidget extends StatefulWidget {
  final MyMusicData _data;
  final PlaySongsModel _model;

  MySongMenuWidget(this._data, this._model);

  @override
  _MySongMenuWidgetState createState() => _MySongMenuWidgetState();
}

class _MySongMenuWidgetState extends State<MySongMenuWidget> {
  //判断描述是否为空
  String _description(String description){
    if(description == null || description == ""){
      return '暂无描述';
    }else
      return description;
  }

  //构造图片+文字+点击事件
  Widget _buildMenuItem(String img, String text, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: ScreenUtil().setWidth(110),
        alignment: Alignment.center,
        child: Row(
          children: <Widget>[
            Container(
              width: ScreenUtil().setWidth(140),
              child: Align(
                child: Image.asset(
                  img,
                  width: ScreenUtil().setWidth(80),
                  fit: BoxFit.fitWidth,
                ),
              ),
            ),
            Expanded(
              child: Text(
                text,
                style: common14TextStyle,
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(ScreenUtil().setWidth(40)),
              topRight: Radius.circular(ScreenUtil().setWidth(40))),
          color: Colors.white),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          VEmptyView(20),
          RoundImgWidget(
              '${widget._data.picUrl}?param=170y170',
              160.w
          ),
          Container(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Container(
                        height: ScreenUtil().setWidth(50),
                        padding: EdgeInsets.only(left: ScreenUtil().setWidth(40)),
                        alignment: Alignment.centerLeft,
                        child: Text(
                          '歌曲：${widget._data.songName}',
                          style: common16TextStyle,
                        ),
                      ),
                      Container(
                        height: ScreenUtil().setWidth(0.5),
                        color: Colors.black26,
                      ),
                      Container(
                          height: ScreenUtil().setWidth(200),
//                        margin: ,
                          padding: EdgeInsets.all(ScreenUtil().setWidth(40)),
                          alignment: Alignment.centerLeft,
                          child: SingleChildScrollView(
                            child:Text(
                              '歌手：'+_description(widget._data.artists),
                              style: common14GrayTextStyle,
                            ),
                          )
                      ),
                    ]
                ),
              ],
            ),
          ),
          Container(
            height: ScreenUtil().setWidth(0.5),
            color: Colors.black26,
          ),
          //分割线
          Consumer<LocalUserModel>(builder: (context, model,  child){
            return _buildMenuItem('images/icon_del.png', '删除', () async {
              bool d = false;  //设置删除标记为false
              showDialog(context: context, builder: (context){

                return DeleteMySongWidget(
                    submitCallback: (bool delete) {
                      //若确定删除，则将删除标记设置为回调的true
                      d = delete;
                      Navigator.of(context).pop();
                    });
              }).then((v){
                if(d == true){
                  PlaySongsModel.removeSong(model.localUser.userId, widget._data.songId);
                  //widget._model.removeSong();
                  //删除歌单函数方法
                }
              });
            });
          }),

          //分割线
          Container(
            color: Colors.grey,
            margin: EdgeInsets.only(left: ScreenUtil().setWidth(140)),
            height: ScreenUtil().setWidth(0.3),
          ),
        ],
      ),
    );
  }

}
