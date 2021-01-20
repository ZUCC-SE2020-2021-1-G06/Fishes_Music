import 'dart:convert' show json;

class SearchMultipleDataKuwo {

  int code;
  int curTime;
  String msg;
  String profileId;
  String reqId;
  SearchDataKuwo data;

  SearchMultipleDataKuwo.fromParams({this.code, this.curTime, this.msg, this.profileId, this.reqId, this.data});

  factory SearchMultipleDataKuwo(jsonStr) => jsonStr == null ? null : jsonStr is String ? SearchMultipleDataKuwo.fromJson(json.decode(jsonStr)) : SearchMultipleDataKuwo.fromJson(jsonStr);

  SearchMultipleDataKuwo.fromJson(jsonRes) {
    code = jsonRes['code'];
    curTime = jsonRes['curTime'];
    msg = jsonRes['msg'];
    profileId = jsonRes['profileId'];
    reqId = jsonRes['reqId'];
    data = jsonRes['data'] == null ? null : SearchDataKuwo.fromJson(jsonRes['data']);
  }

  @override
  String toString() {
    return '{"code": $code, "curTime": $curTime, "msg": ${msg != null?'${json.encode(msg)}':'null'}, "profileId": ${profileId != null?'${json.encode(profileId)}':'null'}, "reqId": ${reqId != null?'${json.encode(reqId)}':'null'}, "data": $data}';
  }
}

class SearchDataKuwo {

  String total;
  List<SongKuwo> list;

  SearchDataKuwo.fromParams({this.total, this.list});

  SearchDataKuwo.fromJson(jsonRes) {
    total = jsonRes['total'];
    list = jsonRes['list'] == null ? null : [];

    for (var listItem in list == null ? [] : jsonRes['list']){
      list.add(listItem == null ? null : SongKuwo.fromJson(listItem));
    }
  }

  @override
  String toString() {
    return '{"total": ${total != null?'${json.encode(total)}':'null'}, "list": $list}';
  }
}

class SongKuwo {

  int albumid;
  int artistid;
  int duration;
  int hasmv;
  int isstar;
  int online;
  int originalsongtype;
  int rid;
  int track;
  bool hasLossless;
  bool isListenFee;
  String album;
  String albumpic;
  String artist;
  String barrage;
  String content_type;
  String musicrid;
  String name;
  String nationid;
  String pay;
  String pic;
  String pic120;
  String releaseDate;
  String score100;
  String songTimeMinutes;
  Mvpayinfo mvpayinfo;
  Payinfo payInfo;

  SongKuwo.fromParams({this.albumid, this.artistid, this.duration, this.hasmv, this.isstar, this.online, this.originalsongtype, this.rid, this.track, this.hasLossless, this.isListenFee, this.album, this.albumpic, this.artist, this.barrage, this.content_type, this.musicrid, this.name, this.nationid, this.pay, this.pic, this.pic120, this.releaseDate, this.score100, this.songTimeMinutes, this.mvpayinfo, this.payInfo});

  SongKuwo.fromJson(jsonRes) {
    albumid = jsonRes['albumid'];
    artistid = jsonRes['artistid'];
    duration = jsonRes['duration'];
    hasmv = jsonRes['hasmv'];
    isstar = jsonRes['isstar'];
    online = jsonRes['online'];
    originalsongtype = jsonRes['originalsongtype'];
    rid = jsonRes['rid'];
    track = jsonRes['track'];
    hasLossless = jsonRes['hasLossless'];
    isListenFee = jsonRes['isListenFee'];
    album = jsonRes['album'];
    albumpic = jsonRes['albumpic'];
    artist = jsonRes['artist'];
    barrage = jsonRes['barrage'];
    content_type = jsonRes['content_type'];
    musicrid = jsonRes['musicrid'];
    name = jsonRes['name'];
    nationid = jsonRes['nationid'];
    pay = jsonRes['pay'];
    pic = jsonRes['pic'];
    pic120 = jsonRes['pic120'];
    releaseDate = jsonRes['releaseDate'];
    score100 = jsonRes['score100'];
    songTimeMinutes = jsonRes['songTimeMinutes'];
    mvpayinfo = jsonRes['mvpayinfo'] == null ? null : Mvpayinfo.fromJson(jsonRes['mvpayinfo']);
    payInfo = jsonRes['payInfo'] == null ? null : Payinfo.fromJson(jsonRes['payInfo']);
  }

  @override
  String toString() {
    return '{"albumid": ${album != null?'${json.encode(album)}':'null'}id, "artistid": ${artist != null?'${json.encode(artist)}':'null'}id, "duration": $duration, "hasmv": $hasmv, "isstar": $isstar, "online": $online, "originalsongtype": $originalsongtype, "rid": $rid, "track": $track, "hasLossless": $hasLossless, "isListenFee": $isListenFee, "album": ${album != null?'${json.encode(album)}':'null'}, "albumpic": ${albumpic != null?'${json.encode(albumpic)}':'null'}, "artist": ${artist != null?'${json.encode(artist)}':'null'}, "barrage": ${barrage != null?'${json.encode(barrage)}':'null'}, "content_type": ${content_type != null?'${json.encode(content_type)}':'null'}, "musicrid": ${musicrid != null?'${json.encode(musicrid)}':'null'}, "name": ${name != null?'${json.encode(name)}':'null'}, "nationid": ${nationid != null?'${json.encode(nationid)}':'null'}, "pay": ${pay != null?'${json.encode(pay)}':'null'}, "pic": ${pic != null?'${json.encode(pic)}':'null'}, "pic120": ${pic120 != null?'${json.encode(pic120)}':'null'}, "releaseDate": ${releaseDate != null?'${json.encode(releaseDate)}':'null'}, "score100": ${score100 != null?'${json.encode(score100)}':'null'}, "songTimeMinutes": ${songTimeMinutes != null?'${json.encode(songTimeMinutes)}':'null'}, "mvpayinfo": $mvpayinfo, "payInfo": $payInfo}';
  }
}

class Payinfo {

  int cannotDownload;
  int cannotOnlinePlay;
  String down;
  String download;
  String listen_fragment;
  String local_encrypt;
  String play;
  Feetype feeType;

  Payinfo.fromParams({this.cannotDownload, this.cannotOnlinePlay, this.down, this.download, this.listen_fragment, this.local_encrypt, this.play, this.feeType});

  Payinfo.fromJson(jsonRes) {
    cannotDownload = jsonRes['cannotDownload'];
    cannotOnlinePlay = jsonRes['cannotOnlinePlay'];
    down = jsonRes['down'];
    download = jsonRes['download'];
    listen_fragment = jsonRes['listen_fragment'];
    local_encrypt = jsonRes['local_encrypt'];
    play = jsonRes['play'];
    feeType = jsonRes['feeType'] == null ? null : Feetype.fromJson(jsonRes['feeType']);
  }

  @override
  String toString() {
    return '{"cannotDownload": $cannotDownload, "cannotOnlinePlay": $cannotOnlinePlay, "down": ${down != null?'${json.encode(down)}':'null'}, "download": ${download != null?'${json.encode(download)}':'null'}, "listen_fragment": ${listen_fragment != null?'${json.encode(listen_fragment)}':'null'}, "local_encrypt": ${local_encrypt != null?'${json.encode(local_encrypt)}':'null'}, "play": ${play != null?'${json.encode(play)}':'null'}, "feeType": $feeType}';
  }
}

class Feetype {

  String song;
  String vip;

  Feetype.fromParams({this.song, this.vip});

  Feetype.fromJson(jsonRes) {
    song = jsonRes['song'];
    vip = jsonRes['vip'];
  }

  @override
  String toString() {
    return '{"song": ${song != null?'${json.encode(song)}':'null'}, "vip": ${vip != null?'${json.encode(vip)}':'null'}}';
  }
}

class Mvpayinfo {

  int down;
  int play;
  int vid;

  Mvpayinfo.fromParams({this.down, this.play, this.vid});

  Mvpayinfo.fromJson(jsonRes) {
    down = jsonRes['down'];
    play = jsonRes['play'];
    vid = jsonRes['vid'];
  }

  @override
  String toString() {
    return '{"down": $down, "play": $play, "vid": $vid}';
  }
}