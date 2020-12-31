import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:huantin/model/music.dart';
import 'package:huantin/model/song.dart';
import 'package:huantin/provider/play_songs_model.dart';
import 'package:huantin/utils/net_utils.dart';
import 'package:huantin/utils/utils.dart';
import 'package:huantin/widgets/widget_img_menu.dart';
import 'package:huantin/widgets/widget_music_list_item.dart';
import 'package:huantin/widgets/widget_songs_list.dart';
import 'package:provider/provider.dart';

class PlayBottomMenuWidget extends StatelessWidget {

  final PlaySongsModel model;

  PlayBottomMenuWidget(this.model);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: ScreenUtil().setWidth(150),
      alignment: Alignment.topCenter,
      child: Row(
        children: <Widget>[
          ImageMenuWidget('images/icon_song_play_type_1.png', 80),
          ImageMenuWidget(
            'images/icon_song_left.png',
            80,
            onTap: () {
              model.prePlay();
            },
          ),
          ImageMenuWidget(
            model.curState != AudioPlayerState.PAUSED
                ? 'images/icon_song_pause.png'
                : 'images/icon_song_play.png',
            150,
            onTap: () {
              model.togglePlay();
            },
          ),
          ImageMenuWidget(
            'images/icon_song_right.png',
            80,
            onTap: () {
              model.nextPlay();
            },
          ),
          ImageMenuWidget(
            'images/icon_play_songs.png',
            80,
            onTap: () {
              //展示播放列表
              List<Song> d = model.getSongs();
              showModalBottomSheet<PlaySongsModel>(
                  context: context,
                  builder: (context) {
                  return SongsListWidget(model);
                  },
                  backgroundColor: Colors.white);
            },
          ),
        ],
      ),
    );
  }
}


