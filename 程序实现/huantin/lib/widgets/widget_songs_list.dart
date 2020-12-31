import 'package:flutter/material.dart';
import 'package:huantin/model/music.dart';
import 'package:huantin/model/song.dart';
import 'package:huantin/provider/play_songs_model.dart';
import 'package:huantin/utils/net_utils.dart';
import 'package:huantin/utils/utils.dart';
import 'package:huantin/widgets/widget_music_list_item.dart';

//播放列表
class SongsListWidget extends StatelessWidget {

  final PlaySongsModel model;

  SongsListWidget(this.model);

  @override
  Widget build(BuildContext context) {
    List<Song> s = model.getSongs();
    return Container(
      child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
        Padding(
            padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
            child: Stack(alignment: Alignment.center, children: <Widget>[
              Container(
                child: Text("播放列表",
                    style: TextStyle(
                        fontSize: 20,
                        color: Color(0xff333333),
                        fontWeight: FontWeight.w500)),
              ),
              Align(
                alignment: Alignment.topRight,
                child: Container(
                    width: 60,
                    height: 50,
                    child: IconButton(
                        icon: Icon(
                          Icons.close,
                          color: Color(0xff666666),
                          size: 30,
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        })),
              ),
            ])),

        ///设计原型上底部弹窗是内容包裹（当内容过多时最大高度为300）
        ///如果用listView实现则自动充满高度
        ///SingleChildScrollView的外面如果不包裹一层ConstrainedBox，
        ///当内容超出showModalBottomSheet的最大限度时会报内容遮挡的错误
        ///所以：采用了稍麻烦的方法实现了这个弹窗功能
        ConstrainedBox(
          constraints: BoxConstraints(maxHeight: 320),
          child: SingleChildScrollView(
            child: ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                 return  WidgetMusicListItem(
                        MusicData(
                          //设置mvid为1，来保持播放图标的存在
                        mvid: 1,
                        index: index + 1,
                        songName: s[index].name,
                        artists:s[index].artists,
                        ),
                        onTap: () {
                          //通过返回的url判断是否可以播放，准确性更高，但是暂时无法输出原因
                          NetUtils.getMusicURL(null, s[index].id).then((value) => {
                            if(value == null){
                              Utils.showToast("暂时无法播放")
                            }
                            else model.playIndex(index)
                          });
                        },
                        );
                },itemCount: s.length
            ),
          ),
        ),
      ]),
    );
  }
}