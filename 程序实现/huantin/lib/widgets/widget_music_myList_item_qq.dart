import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:huantin/model/music.dart';
import 'package:huantin/model/myMusic.dart';
import 'package:huantin/model/myMusicQQ.dart';
import 'package:huantin/provider/play_songs_model.dart';
import 'package:huantin/widgets/rounded_net_image.dart';
import 'package:huantin/widgets/v_empty_view.dart';
import 'package:huantin/widgets/widget_mySong_menu.dart';

import '../application.dart';
import 'common_text_style.dart';
import 'h_empty_view.dart';

class WidgetMusicMyListItemQQ extends StatelessWidget {
  final MyMusicDataQQ _data;
  final VoidCallback onTap;
  PlaySongsModel _playSongsModel;

  WidgetMusicMyListItemQQ(this._data, {this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: onTap,
      child: Container(
        width: Application.screenWidth,
        height: ScreenUtil().setWidth(120),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            _data.index == null && _data.picUrl == null
                ? Container()
                : HEmptyView(15),
            _data.picUrl == null
                ? Container()
                : Container(

            ),
            _data.index == null
                ? Container()
                : Container(
              alignment: Alignment.center,
              width: ScreenUtil().setWidth(60),
              height: ScreenUtil().setWidth(50),
              child: Text(
                _data.index.toString(),
                style: mGrayTextStyle,
              ),
            ),
            _data.index == null && _data.picUrl == null
                ? Container()
                : HEmptyView(10),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    _data.songName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: commonTextStyle,
                  ),
                  VEmptyView(10),
                  Text(
                    _data.artists,
                    style: smallGrayTextStyle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: _data.mvid == 0
                  ? Container()
                  : IconButton(
                icon: Icon(Icons.play_circle_outline),
                onPressed: () {},
                color: Colors.grey,
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: IconButton(
                icon: Icon(Icons.more_vert),
                onPressed: () {
//                  showModalBottomSheet<PlaySongsModel>(
//                      context: context,
//                      builder: (context) {
//                        return MySongMenuWidget(
//                            this._data, this._playSongsModel);
//                      },
//                      backgroundColor: Colors.transparent);
  },
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
