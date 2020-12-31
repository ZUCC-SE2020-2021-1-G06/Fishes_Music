import 'package:flutter/material.dart';
import 'package:huantin/model/local_user.dart';
import 'package:huantin/model/play_list.dart';
import 'package:huantin/model/user.dart';
import 'package:huantin/utils/net_utils.dart';

class PlayListModel with ChangeNotifier {
  User user;
  LocalUser localUser;

  List<Playlist> _selfCreatePlayList = []; // 我创建的歌单
  List<Playlist> _collectPlayList = []; // 收藏的歌单
  List<Playlist> _allPlayList = []; // 所有的歌单

  List<Playlist> get selfCreatePlayList => _selfCreatePlayList;

  List<Playlist> get collectPlayList => _collectPlayList;

  List<Playlist> get allPlayList => _allPlayList;


  void setPlayList(List<Playlist> value) {
    _allPlayList = value;
    _splitPlayList();
  }

  void _splitPlayList() {
    _selfCreatePlayList =
        _allPlayList.where((p) => p.creator.userId == user.account.id).toList();
    _collectPlayList =
        _allPlayList.where((p) => p.creator.userId != user.account.id).toList();
    notifyListeners();
  }

  void addPlayList(Playlist playlist){
    _allPlayList.insert(1,playlist);
    _splitPlayList();
  }

  void delPlayList(Playlist playlist) {
    _allPlayList.remove(playlist);
    _splitPlayList();
  }

  void editPlayList(Playlist playlist,String name,String desc) {
    _allPlayList.remove(playlist);
    playlist.name = name;
    playlist.description = desc;
    _allPlayList.insert(1,playlist);
    _splitPlayList();
  }

  void getSelfPlaylistData(BuildContext context) async{
    var result = await NetUtils.getSelfPlaylistData(context, params: {'uid': user.account.id});
    setPlayList(result.playlist);
    _splitPlayList();
  }
}
