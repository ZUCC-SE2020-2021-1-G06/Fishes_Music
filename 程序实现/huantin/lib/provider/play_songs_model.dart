import 'dart:async';
import 'dart:convert';

import 'package:audioplayers/audioplayers.dart';
import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:huantin/application.dart';
import 'package:huantin/model/song.dart';
import 'package:huantin/model/user.dart';
import 'package:huantin/utils/fluro_convert_utils.dart';
import 'package:huantin/utils/navigator_util.dart';
import 'package:huantin/utils/net_utils.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:huantin/utils/utils.dart';

class PlaySongsModel with ChangeNotifier{
  AudioPlayer _audioPlayer = AudioPlayer();
  StreamController<String> _curPositionController = StreamController<String>.broadcast();

  List<Song> _songs = [];
  int curIndex = 0;
  Duration curSongDuration;
  AudioPlayerState _curState;

  List<Song> get allSongs => _songs;
  Song get curSong => _songs[curIndex];
  Stream<String> get curPositionStream => _curPositionController.stream;
  AudioPlayerState get curState => _curState;


  void init() {
    _audioPlayer.setReleaseMode(ReleaseMode.STOP);
    // 播放状态监听
    _audioPlayer.onPlayerStateChanged.listen((state) {
      _curState = state;
      /// 先做顺序播放
      if(state == AudioPlayerState.COMPLETED){
        nextPlay();
      }
      // 其实也只有在播放状态更新时才需要通知。
      notifyListeners();
    });
    _audioPlayer.onDurationChanged.listen((d) {
      curSongDuration = d;
    });
    // 当前播放进度监听
    _audioPlayer.onAudioPositionChanged.listen((Duration p) {
      /*
      这里有个坑，就是 当前播放时间 有可能会大于 总时长！
      所以我们在调用方法的时候要进行一次判断：如果当前播放时间大于了总时间，那么就传入总时间。
      */
      sinkProgress(p.inMilliseconds > curSongDuration.inMilliseconds ? curSongDuration.inMilliseconds : p.inMilliseconds);
    });
  }

  // 歌曲进度
  void sinkProgress(int m){
    //使用 duration.inMilliseconds 来获取时间戳
    //这个监听事件间隔非常短，所以我们肯定是不可能用 setState() 来更新页面，这样肯定会造成非常严重的后果。
    //这里使用 StreamBuilder 来进行操作，每有一次当前进度的更新，就用stream 的方式发送出去，然后更新页面。
    _curPositionController.sink.add('$m-${curSongDuration.inMilliseconds}');
  }

  // 播放一首歌
  void playSong(Song song) {
    _songs.insert(curIndex, song);
    play();
  }

  // 播放很多歌
  void playSongs(List<Song> songs, {int index}) {
    this._songs = songs;
    if (index != null) curIndex = index;
    play();
  }

  // 添加歌曲
  void addSongs(List<Song> songs) {
    this._songs.addAll(songs);
  }

  /// 播放
  void play() async {
    var songId = this._songs[curIndex].id;
    var url = await NetUtils.getMusicURL(null, songId);

    _audioPlayer.play(url);
    saveCurSong();
  }

  /// 暂停、恢复
  void togglePlay(){
    if (_audioPlayer.state == AudioPlayerState.PAUSED) {
      resumePlay();
    } else {
      pausePlay();
    }
  }

  // 暂停
  void pausePlay() {
    _audioPlayer.pause();
  }

  /// 跳转到固定时间
  void seekPlay(int milliseconds){
    _audioPlayer.seek(Duration(milliseconds: milliseconds));
    resumePlay();
  }

  /// 恢复播放
  void resumePlay() {
    _audioPlayer.resume();
  }

  /// 下一首
  void nextPlay(){
    if(curIndex >= _songs.length){
      curIndex = 0;
    }else{
      curIndex++;
    }
    play();
  }

  ///上一首
  void prePlay(){
    if(curIndex <= 0){
      curIndex = _songs.length - 1;
    }else{
      curIndex--;
    }
    play();
  }

  // 保存当前歌曲到本地
  void saveCurSong(){
    Application.sp.remove('playing_songs');
    Application.sp.setStringList('playing_songs', _songs.map((s) => FluroConvertUtils.object2string(s)).toList());
    Application.sp.setInt('playing_index', curIndex);
  }

  @override
  void dispose() {
    super.dispose();
    _curPositionController.close();
    _audioPlayer.dispose();
  }


}
