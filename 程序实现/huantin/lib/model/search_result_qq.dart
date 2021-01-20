import 'dart:convert' show json;

class SearchMultipleDataQQ {
  int result;
  SearchDataQQ data;

  SearchMultipleDataQQ.fromParams({this.result, this.data});

  factory SearchMultipleDataQQ(jsonStr) => jsonStr == null
      ? null
      : jsonStr is String
          ? SearchMultipleDataQQ.fromJson(json.decode(jsonStr))
          : SearchMultipleDataQQ.fromJson(jsonStr);

  SearchMultipleDataQQ.fromJson(jsonRes) {
    result = jsonRes['result'];
    data =
        jsonRes['data'] == null ? null : SearchDataQQ.fromJson(jsonRes['data']);
  }

  @override
  String toString() {
    return '{"result": $result, "data": $data}';
  }
}

class SearchDataQQ {
  int pageNo;
  int pageSize;
  int t;
  int total;
  String key;
  String type;
  List<SongQQ> list;

  SearchDataQQ.fromParams(
      {this.pageNo,
      this.pageSize,
      this.t,
      this.total,
      this.key,
      this.type,
      this.list});

  SearchDataQQ.fromJson(jsonRes) {
    pageNo = jsonRes['pageNo'];
    pageSize = jsonRes['pageSize'];
    t = jsonRes['t'];
    total = jsonRes['total'];
    key = jsonRes['key'];
    type = jsonRes['type'];
    list = jsonRes['list'] == null ? null : [];

    for (var listItem in list == null ? [] : jsonRes['list']) {
      list.add(listItem == null ? null : SongQQ.fromJson(listItem));
    }
  }

  @override
  String toString() {
    return '{"pageNo": $pageNo, "pageSize": $pageSize, "t": $t, "total": $total, "key": ${key != null ? '${json.encode(key)}' : 'null'}, "type": ${type != null ? '${json.encode(type)}' : 'null'}, "list": $list}';
  }
}

class SongQQ {
  int albumid;
  int alertid;
  int chinesesinger;
  int interval;
  int isonly;
  int msgid;
  int nt;
  int pubtime;
  int pure;
  int size128;
  int size320;
  int sizeape;
  int sizeflac;
  int sizeogg;
  int songid;
  int stream;
  int switch1;
  int t;
  int tag;
  int type;
  int ver;
  String albummid;
  String albumname;
  String albumname_hilight;
  String docid;
  String format;
  String lyric;
  String lyric_hilight;
  String songmid;
  String songname;
  String songname_hilight;
  String songurl;
  String vid;
  List<dynamic> grp;
  List<Singer> singer;
  Pay pay;
  Preview preview;

  SongQQ.fromParams(
      {this.albumid,
      this.alertid,
      this.chinesesinger,
      this.interval,
      this.isonly,
      this.msgid,
      this.nt,
      this.pubtime,
      this.pure,
      this.size128,
      this.size320,
      this.sizeape,
      this.sizeflac,
      this.sizeogg,
      this.songid,
      this.stream,
      this.switch1,
      this.t,
      this.tag,
      this.type,
      this.ver,
      this.albummid,
      this.albumname,
      this.albumname_hilight,
      this.docid,
      this.format,
      this.lyric,
      this.lyric_hilight,
      this.songmid,
      this.songname,
      this.songname_hilight,
      this.songurl,
      this.vid,
      this.grp,
      this.singer,
      this.pay,
      this.preview});

  SongQQ.fromJson(jsonRes) {
    albumid = jsonRes['albumid'];
    alertid = jsonRes['alertid'];
    chinesesinger = jsonRes['chinesesinger'];
    interval = jsonRes['interval'];
    isonly = jsonRes['isonly'];
    msgid = jsonRes['msgid'];
    nt = jsonRes['nt'];
    pubtime = jsonRes['pubtime'];
    pure = jsonRes['pure'];
    size128 = jsonRes['size128'];
    size320 = jsonRes['size320'];
    sizeape = jsonRes['sizeape'];
    sizeflac = jsonRes['sizeflac'];
    sizeogg = jsonRes['sizeogg'];
    songid = jsonRes['songid'];
    stream = jsonRes['stream'];
    switch1 = jsonRes['switch'];
    t = jsonRes['t'];
    tag = jsonRes['tag'];
    type = jsonRes['type'];
    ver = jsonRes['ver'];
    albummid = jsonRes['albummid'];
    albumname = jsonRes['albumname'];
    albumname_hilight = jsonRes['albumname_hilight'];
    docid = jsonRes['docid'];
    format = jsonRes['format'];
    lyric = jsonRes['lyric'];
    lyric_hilight = jsonRes['lyric_hilight'];
    songmid = jsonRes['songmid'];
    songname = jsonRes['songname'];
    songname_hilight = jsonRes['songname_hilight'];
    songurl = jsonRes['songurl'];
    vid = jsonRes['vid'];
    grp = jsonRes['grp'] == null ? null : [];

    for (var grpItem in grp == null ? [] : jsonRes['grp']) {
      grp.add(grpItem);
    }

    singer = jsonRes['singer'] == null ? null : [];

    for (var singerItem in singer == null ? [] : jsonRes['singer']) {
      singer.add(singerItem == null ? null : Singer.fromJson(singerItem));
    }

    pay = jsonRes['pay'] == null ? null : Pay.fromJson(jsonRes['pay']);
    preview = jsonRes['preview'] == null
        ? null
        : Preview.fromJson(jsonRes['preview']);
  }

  @override
  String toString() {
    return '{"albumid": $albumid, "alertid": $alertid, "chinesesinger": $chinesesinger, "interval": $interval, "isonly": $isonly, "msgid": $msgid, "nt": $nt, "pubtime": $pubtime, "pure": $pure, "size128": $size128, "size320": $size320, "sizeape": $sizeape, "sizeflac": $sizeflac, "sizeogg": $sizeogg, "songid": $songid, "stream": $stream, "switch": $switch1, "t": $t, "tag": $tag, "type": $type, "ver": $ver, "albummid": ${albummid != null ? '${json.encode(albummid)}' : 'null'}, "albumname": ${albumname != null ? '${json.encode(albumname)}' : 'null'}, "albumname_hilight": ${albumname_hilight != null ? '${json.encode(albumname_hilight)}' : 'null'}, "docid": ${docid != null ? '${json.encode(docid)}' : 'null'}, "format": ${format != null ? '${json.encode(format)}' : 'null'}, "lyric": ${lyric != null ? '${json.encode(lyric)}' : 'null'}, "lyric_hilight": ${lyric_hilight != null ? '${json.encode(lyric_hilight)}' : 'null'}, "songmid": ${songmid != null ? '${json.encode(songmid)}' : 'null'}, "songname": ${songname != null ? '${json.encode(songname)}' : 'null'}, "songname_hilight": ${songname_hilight != null ? '${json.encode(songname_hilight)}' : 'null'}, "songurl": ${songurl != null ? '${json.encode(songurl)}' : 'null'}, "vid": ${vid != null ? '${json.encode(vid)}' : 'null'}, "grp": $grp, "singer": $singer, "pay": $pay, "preview": $preview}';
  }
}

class Preview {
  int trybegin;
  int tryend;
  int trysize;

  Preview.fromParams({this.trybegin, this.tryend, this.trysize});

  Preview.fromJson(jsonRes) {
    trybegin = jsonRes['trybegin'];
    tryend = jsonRes['tryend'];
    trysize = jsonRes['trysize'];
  }

  @override
  String toString() {
    return '{"trybegin": $trybegin, "tryend": $tryend, "trysize": $trysize}';
  }
}

class Pay {
  int payalbum;
  int payalbumprice;
  int paydownload;
  int payinfo;
  int payplay;
  int paytrackmouth;
  int paytrackprice;

  Pay.fromParams(
      {this.payalbum,
      this.payalbumprice,
      this.paydownload,
      this.payinfo,
      this.payplay,
      this.paytrackmouth,
      this.paytrackprice});

  Pay.fromJson(jsonRes) {
    payalbum = jsonRes['payalbum'];
    payalbumprice = jsonRes['payalbumprice'];
    paydownload = jsonRes['paydownload'];
    payinfo = jsonRes['payinfo'];
    payplay = jsonRes['payplay'];
    paytrackmouth = jsonRes['paytrackmouth'];
    paytrackprice = jsonRes['paytrackprice'];
  }

  @override
  String toString() {
    return '{"payalbum": $payalbum, "payalbumprice": $payalbumprice, "paydownload": $paydownload, "payinfo": $payinfo, "payplay": $payplay, "paytrackmouth": $paytrackmouth, "paytrackprice": $paytrackprice}';
  }
}

class Singer {
  int id;
  String mid;
  String name;
  String name_hilight;

  Singer.fromParams({this.id, this.mid, this.name, this.name_hilight});

  Singer.fromJson(jsonRes) {
    id = jsonRes['id'];
    mid = jsonRes['mid'];
    name = jsonRes['name'];
    name_hilight = jsonRes['name_hilight'];
  }

  @override
  String toString() {
    return '{"id": $id, "mid": ${mid != null ? '${json.encode(mid)}' : 'null'}, "name": ${name != null ? '${json.encode(name)}' : 'null'}, "name_hilight": ${name_hilight != null ? '${json.encode(name_hilight)}' : 'null'}}';
  }
}
