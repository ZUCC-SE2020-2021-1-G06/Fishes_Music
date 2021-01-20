import 'dart:async';
import 'dart:convert';
import 'dart:ffi';
import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:common_utils/common_utils.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:huantin/application.dart';
import 'package:huantin/model/song.dart';
import 'package:huantin/model/song_kuwo.dart';
import 'package:huantin/model/song_qq.dart';
import 'package:huantin/model/user.dart';
import 'package:huantin/provider/play_list_model.dart';
import 'package:huantin/utils/fluro_convert_utils.dart';
import 'package:huantin/utils/navigator_util.dart';
import 'package:huantin/utils/net_utils.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:huantin/utils/utils.dart';

class PlaySongsModel with ChangeNotifier {
  AudioPlayer _audioPlayer = AudioPlayer();
  StreamController<String> _curPositionController =
      StreamController<String>.broadcast();

  List<SongKuwo> _songKuwo = []; //为酷我播放时临时建立
  List<SongQQ> _songQQ = []; //为QQ播放时临时建立
  List<Song> _songs = [];
  List<Song> _historySongs = [];
  List<SongQQ> _historySongQQ = [];
  List<SongKuwo> _historySongKuwo = [];
  List<Song> _mySongs = [];
  List<SongQQ> _mySongQQ = [];
  List<SongKuwo> _mySongKuwo = [];
  int curIndex = 0;
  int curIndexQQ = 0;
  int curIndexKuwo = 0;
  int cur = 0; //判断在播放哪个平台的歌曲，网易0，QQ1，酷我2
  Duration curSongDuration;
  AudioPlayerState _curState;
  int check = -1;
  int curType = 0; //当前播放模式，0为顺序播放，1为随机播放,2为单曲循环

  List<Song> get allSongs => _songs;

  List<SongQQ> get allSongQQ => _songQQ;

  List<SongKuwo> get allSongKuwo => _songKuwo;

  Song get curSong => _songs[curIndex];

  Stream<String> get curPositionStream => _curPositionController.stream;

  AudioPlayerState get curState => _curState;

  SongKuwo get curSongKuwo => _songKuwo[curIndexKuwo];

  SongQQ get curSongQQ => _songQQ[curIndexQQ];

  void init() {
    _audioPlayer.setReleaseMode(ReleaseMode.STOP);
    // 播放状态监听
    _audioPlayer.onPlayerStateChanged.listen((state) {
      _curState = state;

      /// 播放完成，且播放模式为顺序播放
      if (state == AudioPlayerState.COMPLETED) {
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
      sinkProgress(p.inMilliseconds > curSongDuration.inMilliseconds
          ? curSongDuration.inMilliseconds
          : p.inMilliseconds);
    });
  }

  // 切换播放模式
  void changeType() {
    //每点击一次，播放模式+1,在三种模式内切换
    if (curType == 2) {
      curType = 0;
    } else
      curType = curType + 1;
    _audioPlayer.resume();
  }

  // 自动切换至单曲循环播放模式
  void autoChangeType2() {
    //每点击一次，播放模式+1,在三种模式内切换
    curType = 2;
    _audioPlayer.resume();
  }

  //返回播放歌曲列表
  List<Song> getSongs() {
    return this._songs;
  }

  //返回最近播放歌曲列表
  List<Song> getHistorySongs() {
    return this._historySongs;
  }

  //返回最近QQ播放歌曲列表
  List<SongQQ> getHistorySongQQ() {
    return this._historySongQQ;
  }

  //返回最近酷我播放歌曲列表
  List<SongKuwo> getHistorySongKuwo() {
    return this._historySongKuwo;
  }

  // 歌曲进度
  void sinkProgress(int m) {
    //使用 duration.inMilliseconds 来获取时间戳
    //这个监听事件间隔非常短，所以我们肯定是不可能用 setState() 来更新页面，这样肯定会造成非常严重的后果。
    //这里使用 StreamBuilder 来进行操作，每有一次当前进度的更新，就用stream 的方式发送出去，然后更新页面。
    _curPositionController.sink.add('$m-${curSongDuration.inMilliseconds}');
  }

  // 播放网易云
  void playSong(Song song) {
    _songs.insert(curIndex, song);
    play();
  }

  // 播放QQ
  void playSongQQ(SongQQ song) {
    _songQQ.insert(curIndexQQ, song);
    playQQ();
  }

  // 播放酷我
  void playSongKuwo(SongKuwo song) {
    _songKuwo.insert(curIndexKuwo, song);
    playKuwo();
  }

  // 填入播放列表，播放指定歌曲
  void playSongs(List<Song> songs, {int index}) {
    this._songs = songs;
    if (index != null) curIndex = index;
    play();
  }

  // QQ播放，不填入播放列表，临时建立
  void playSongsQQ(List<SongQQ> SongQQ, {int index}) {
    this._songQQ = SongQQ;
    if (index != null) curIndexQQ = index;
    playQQ();
  }

  // 酷我播放，不填入播放列表，临时建立
  void playSongsKuwo(List<SongKuwo> SongKuwo, {int index}) {
    this._songKuwo = SongKuwo;
    if (index != null) curIndexKuwo = index;
    playKuwo();
  }

  // 添加歌曲
  void addSongs(List<Song> songs) {
    this._songs.addAll(songs);
  }

  // 添加QQ歌曲
  void addSongQQ(List<SongQQ> songs) {
    this._songQQ.addAll(songs);
  }

  // 添加酷我歌曲
  void addSongKuwo(List<SongKuwo> songs) {
    this._songKuwo.addAll(songs);
  }

  // 添加历史记录歌曲
  void addHistorySongs(List<Song> songs) {
    this._historySongs.addAll(songs);
  }

  // 添加QQ历史记录歌曲
  void addHistorySongQQ(List<SongQQ> songs) {
    this._historySongQQ.addAll(songs);
  }

  // 添加酷我历史记录歌曲
  void addHistorySongKuwo(List<SongKuwo> songs) {
    this._historySongKuwo.addAll(songs);
  }

  /// 播放
  void play() async {
    var songId = 0;
    songId = this._songs[curIndex].id;
    var url = await NetUtils.getMusicURL(null, songId);
    _audioPlayer.play(url);
    saveCurSong();
    //如果历史记录中存在该播放记录，则先移除，再加入（为了使最新的记录放置在首位）
    if (_historySongs.contains(_songs[curIndex]))
      _historySongs.remove(_songs[curIndex]);
    _historySongs.insert(0, _songs[curIndex]);
    saveHistorySong();
    cur = 0;
  }

  /// QQ音乐播放，暂时不支持存储历史记录
  void playQQ() async {
    String songmid = this._songQQ[curIndexQQ].id;
    var url = await NetUtils.getMusicURL2(null, songmid);
    cur = 1;
    _audioPlayer.play(url);
    saveCurSong();
    //如果历史记录中存在该播放记录，则先移除，再加入（为了使最新的记录放置在首位）
    if (_historySongQQ.contains(_songQQ[curIndexQQ]))
      _historySongQQ.remove(_songQQ[curIndexQQ]);
    _historySongQQ.insert(0, _songQQ[curIndexQQ]);
    saveHistorySong();
  }

  /// 酷我音乐播放，暂时不支持存储历史记录
  void playKuwo() async {
    String musicrid = this._songKuwo[curIndexKuwo].id;
    var url = await NetUtils.getMusicURL3(null, musicrid);
    cur = 2;
    saveCurSong();
    _audioPlayer.play(url);
    //如果历史记录中存在该播放记录，则先移除，再加入（为了使最新的记录放置在首位）
    if (_historySongKuwo.contains(_songKuwo[curIndexKuwo]))
      _historySongKuwo.remove(_songKuwo[curIndexKuwo]);
    _historySongKuwo.insert(0, _songKuwo[curIndexKuwo]);
    saveHistorySong();
  }

  /// 播放指定歌曲
  void playIndex(int index) async {
    //计算指定歌曲和当前歌曲相差的值
    int x = index - curIndex;
    //若为正，说明需要往下跳转
    if (x > 0) {
      nextNPlay(x);
    }
    //若为负，说明需要往上跳转
    else if (x < 0) {
      preNPlay(x);
    }
  }

  /// 暂停、恢复
  void togglePlay() {
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
  void seekPlay(int milliseconds) {
    _audioPlayer.seek(Duration(milliseconds: milliseconds));
    resumePlay();
  }

  /// 恢复播放
  void resumePlay() {
    _audioPlayer.resume();
  }

  /// 从播放列表中删除
  void deletePlay(int index) {
    _songs.remove(index);
  }

  /// 清空播放列表
  void clearPlay() {
    _songs.clear();
  }

  /// 下一首
  void nextPlay() async {
    //若为顺序播放
    if (curType == 0) {
      if (curIndex == _songs.length - 1) {
        curIndex = 0;
      } else {
        curIndex++;
      }
    }
    //若为随机播放
    else if (curType == 1) {
      var rng = new Random(); //随机数生成类
      curIndex = rng.nextInt(_songs.length);
    }
    //若为单曲循环播放
    else if (curType == 2) {
      curIndex = curIndex;
    }
    var songId = this._songs[curIndex].id;
    var url = await NetUtils.getMusicURL(null, songId);
    if (url == null) {
      Utils.showToast("该歌曲暂时无法播放，跳转至下一首中可以播放的歌曲。");
      while (url == null) {
        curIndex++;
        songId = this._songs[curIndex].id;
        url = await NetUtils.getMusicURL(null, songId);
      }
    }
    if (cur == 1)
      playQQ();
    else if (cur == 2)
      playKuwo();
    else
      play();
  }

  /// 下N首
  void nextNPlay(int index) async {
    curIndex += index;
    var songId = this._songs[curIndex].id;
    var url = await NetUtils.getMusicURL(null, songId);
    if (url == null) {
      Utils.showToast("该歌曲暂时无法播放，跳转至下一首中可以播放的歌曲。");
      while (url == null) {
        curIndex++;
        songId = this._songs[curIndex].id;
        url = await NetUtils.getMusicURL(null, songId);
      }
    }
    play();
  }

  ///上一首
  void prePlay() async {
    if (curIndex <= 0) {
      curIndex = _songs.length - 1;
    } else {
      curIndex--;
    }
    var songId = this._songs[curIndex].id;
    var url = await NetUtils.getMusicURL(null, songId);
    if (url == null) {
      Utils.showToast("该歌曲暂时无法播放，跳转至上一首中可以播放的歌曲。");
      while (url == null) {
        curIndex--;
        songId = this._songs[curIndex].id;
        url = await NetUtils.getMusicURL(null, songId);
      }
    }
    play();
  }

  /// 上N首
  void preNPlay(int index) async {
    curIndex += index;
    var songId = this._songs[curIndex].id;
    var url = await NetUtils.getMusicURL(null, songId);
    if (url == null) {
      Utils.showToast("该歌曲暂时无法播放，跳转至下一首中可以播放的歌曲。");
      while (url == null) {
        curIndex--;
        songId = this._songs[curIndex].id;
        url = await NetUtils.getMusicURL(null, songId);
      }
    }
    play();
  }

  // 保存当前歌曲到本地
  void saveCurSong() {
    Application.sp.remove('playing_songs');
    Application.sp.setStringList('playing_songs', _songs.map((s) => FluroConvertUtils.object2string(s)).toList());
    Application.sp.setInt('playing_index', curIndex);

    Application.sp.remove('playing_songsQQ');
    Application.sp.setStringList('playing_songsQQ', _songQQ.map((s) => FluroConvertUtils.object2string(s)).toList());
    Application.sp.setInt('playing_indexQQ', curIndexQQ);

    Application.sp.remove('playing_songsKuwo');
    Application.sp.setStringList('playing_songsKuwo', _songKuwo.map((s) => FluroConvertUtils.object2string(s)).toList());
    Application.sp.setInt('playing_indexKuwo', curIndexKuwo);

    Application.sp.remove('playing_cur');
    Application.sp.setInt('playing_cur', cur);
  }

  // 保存听歌记录歌曲到本地
  void saveHistorySong() {
    Application.sp.setStringList('history_songs', _historySongs.map((s) => FluroConvertUtils.object2string(s)).toList());
    Application.sp.setStringList('history_songQQ', _historySongQQ.map((s) => FluroConvertUtils.object2string(s)).toList());
    Application.sp.setStringList('history_songKuwo', _historySongKuwo.map((s) => FluroConvertUtils.object2string(s)).toList());
  }

  // 清除听歌记录歌曲
  void clearHistorySong() {
    _historySongs.clear();
    _historySongQQ.clear();
    _historySongKuwo.clear();
    Application.sp.remove('history_songs');
    Application.sp.remove('history_songQQ');
    Application.sp.remove('history_songKuwo');
  }

  @override
  void dispose() {
    super.dispose();
    _curPositionController.close();
    _audioPlayer.dispose();
  }

  //添加自建歌单
  void addList(int userId) async {
    this.checkList(userId);
    if (this.check == 0) {
      Response response = await Dio().get(
          "http://121.196.105.48:8080/songList/add?userId=" +
              userId.toString());
      if (response.statusCode != 200) {
        Utils.showToast('添加歌单失败');
      } else {
        Utils.showToast("新建歌单成功");
      }
    }
  }

  //检查自建歌单是否存在
  void checkList(int userId) async {
    Response response = await Dio().get(
        "http://121.196.105.48:8080/songList/check?userId=" +
            userId.toString());
    if (response.statusCode == 200) {
      this.check = response.data;
    } else {
      Utils.showToast('检查歌单失败');
    }
  }

  //返回自建歌单
  List<Song> getMyListSongs() {
    return this._mySongs;
  }

  //返回自建QQ歌单
  List<SongQQ> getMyListSongQQ() {
    return this._mySongQQ;
  }

  //返回自建酷我歌单
  List<SongKuwo> getMyListSongKuwo() {
    return this._mySongKuwo;
  }

  //往自建歌单添加歌曲
  Future<Song> addMySong(BuildContext context, int userId, Song song) async {
    print(song.id);
    print(song.name);
    print(song.artists);
    print(song.picUrl);
    Response response = await Dio().get("http://121.196.105.48:8080/song/add?"
            "userId=" +
        userId.toString() +
        "&songId=" +
        song.id.toString() +
        "&songName=" +
        song.name +
        "&songArtist=" +
        song.artists +
        "&songAvatar=" +
        song.picUrl +
        "&platform=" +
        song.platform.toString());
    if (response.statusCode == 200) {
      Utils.showToast('收藏成功');
      return song;
    } else {
      Utils.showToast('收藏失败');
      return null;
    }
  }

  //往自建歌单添加QQ歌曲
  Future<SongQQ> addMySongQQ(
      BuildContext context, int userId, SongQQ song) async {
    print(song.id);
    print(song.name);
    print(song.artists);
    print(song.picUrl);
    Response response = await Dio().get("http://121.196.105.48:8080/song/add?"
            "userId=" +
        userId.toString() +
        "&songId=" +
        song.id.toString() +
        "&songName=" +
        song.name +
        "&songArtist=" +
        song.artists +
        "&songAvatar=" +
        song.picUrl +
        "&platform=" +
        song.platform.toString());
    if (response.statusCode == 200) {
      Utils.showToast('收藏成功');
      return song;
    } else {
      Utils.showToast('收藏失败');
      return null;
    }
  }

  //往自建歌单添加酷我歌曲
  Future<SongKuwo> addMySongKuwo(
      BuildContext context, int userId, SongKuwo song) async {
    print(song.id);
    print(song.name);
    print(song.artists);
    print(song.picUrl);
    Response response = await Dio().get("http://121.196.105.48:8080/song/add?"
            "userId=" +
        userId.toString() +
        "&songId=" +
        song.id.toString() +
        "&songName=" +
        song.name +
        "&songArtist=" +
        song.artists +
        "&songAvatar=" +
        song.picUrl +
        "&platform=" +
        song.platform.toString());
    if (response.statusCode == 200) {
      Utils.showToast('收藏成功');
      return song;
    } else {
      Utils.showToast('收藏失败');
      return null;
    }
  }

  //加载自建歌单歌曲
  void loadMyList(int userId) async {
    List<Song> mySongs = [];
    List<SongQQ> mySongQQ = [];
    List<SongKuwo> mySongKuwo = [];
    Response response = await Dio().get(
        "http://121.196.105.48:8080/song/load?userId=" + userId.toString());
    if (response.statusCode == 200) {
      for (var item in response.data) {
        if (item != null) {
          int platform = item['platform'];
          if (platform == 0)
            mySongs.add(Song.fromJson2(item));
          else if (platform == 1)
            mySongQQ.add(SongQQ.fromJson2(item));
          else if (platform == 2) mySongKuwo.add(SongKuwo.fromJson2(item));
        }
      }
      this._mySongs = mySongs;
      this._mySongQQ = mySongQQ;
      this._mySongKuwo = mySongKuwo;
    } else {
      return null;
    }
  }

  //删除自建歌单歌曲
  static void removeSong(int userId, int songId) async {
    Response response = await Dio().get(
        "http://121.196.105.48:8080/song/remove?userId=" +
            userId.toString() +
            "&songId=" +
            songId.toString());
    if (response.statusCode == 200) {
      Utils.showToast('删除成功');
    }
  }
}
