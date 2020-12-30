import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:huantin/model/play_list.dart';
import 'package:huantin/provider/play_list_model.dart';
import 'package:huantin/provider/user_model.dart';
import 'package:huantin/utils/net_utils.dart';
import 'package:huantin/utils/utils.dart';
import 'package:huantin/widgets/common_text_style.dart';
import 'package:huantin/widgets/rounded_net_image.dart';
import 'package:huantin/widgets/v_empty_view.dart';
import 'package:huantin/widgets/widget_delete_play_list.dart';
import 'package:huantin/widgets/widget_edit_play_list.dart';
import 'package:huantin/widgets/widget_round_img.dart';

class PlayListMenuWidget extends StatefulWidget {
  final Playlist _playlist;
  final PlayListModel _model;

  PlayListMenuWidget(this._playlist, this._model);

  @override
  _PlayListMenuWidgetState createState() => _PlayListMenuWidgetState();
}

class _PlayListMenuWidgetState extends State<PlayListMenuWidget> {
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
              '${widget._playlist.coverImgUrl}?param=170y170',
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
                          '歌单：${widget._playlist.name}',
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
                            '描述：'+_description(widget._playlist.description),
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
          Offstage(
            offstage: widget._playlist.creator.userId != widget._model.user.account.id,
            child: _buildMenuItem('images/icon_edit.png', '编辑歌单信息', () {
              //打印id号，方便测试与维护
              print(widget._playlist.id);
              bool e = false;  //设置修改标记为false
              String editName;
              String editDesc;
              showDialog(context: context, builder: (context){
                return EditPlayListWidget(
                  submitCallback: (String name, String desc,bool edit) {
                    // 若确定修改，则将修改标记设置为回调的true
                    e = edit;
                    editName = name;
                    editDesc = desc;
                    Navigator.of(context).pop();
                }, playlist: widget._playlist,);
              }).then((v){
                if(e == true){
                  //修改歌单名函数方法
                  NetUtils.editPlaylist(context, params: {'id': widget._playlist.id,'name':editName,'desc':editDesc}).then((v){
                    if(v.code == 200) {
                      widget._playlist..type = 2;
                      widget._playlist..name = editName;
                      widget._playlist..description = editDesc;
                      Navigator.pop(context, widget._playlist);
                    }
                    else Utils.showToast('修改失败，请重试');
                  });
                };
              });;
            }),
          ),
          //分割线
          Offstage(
            offstage: widget._playlist.creator.userId != widget._model.user.account.id,
            child: Container(
              color: Colors.grey,
              margin: EdgeInsets.only(left: ScreenUtil().setWidth(140)),
              height: ScreenUtil().setWidth(0.3),
            ),
          ),
          _buildMenuItem('images/icon_del.png', '删除', () async {
            bool d = false;  //设置删除标记为false
            showDialog(context: context, builder: (context){
              return DeletePlayListWidget(
                submitCallback: (bool delete) {
                  //若确定删除，则将删除标记设置为回调的true
                  d = delete;
                  Navigator.of(context).pop();
                });
            }).then((v){
              if(d == true){
                //删除歌单函数方法
                NetUtils.deletePlaylist(context, params: {'id': widget._playlist.id}).then((v){
                  if(v.code == 200) Navigator.pop(context, widget._playlist..type = 1);
                  else Utils.showToast('删除失败，请重试');
                });
              };
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
