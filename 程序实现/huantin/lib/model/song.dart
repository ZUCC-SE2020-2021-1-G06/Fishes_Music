dynamic convertValueByType(value, Type type, {String stack: ""}) {
  if (value == null) {
    if (type == String) {
      return "";
    } else if (type == int) {
      return 0;
    } else if (type == double) {
      return 0.0;
    } else if (type == bool) {
      return false;
    }
    return null;
  }

  if (value.runtimeType == type) {
    return value;
  }
  var valueS = value.toString();
  if (type == String) {
    return valueS;
  } else if (type == int) {
    return int.tryParse(valueS);
  } else if (type == double) {
    return double.tryParse(valueS);
  } else if (type == bool) {
    valueS = valueS.toLowerCase();
    var intValue = int.tryParse(valueS);
    if (intValue != null) {
      return intValue == 1;
    }
    return valueS == "true";
  }
}

class Song {
  int id; // 歌曲id
  String name; // 歌曲名称
  String artists; // 演唱者
  String picUrl; // 歌曲图片
  int platform;//所属平台

  Song(this.id, this.platform,{this.name, this.artists, this.picUrl});

  Song.fromJson(Map<String, dynamic> json)
      : id =  convertValueByType(json['id'], int, stack: "Song-id"),
        name = json['name'],
        artists = json['artists'],
        picUrl = json['picUrl'],
        platform = json['platform'];

  Song.fromJson2(Map<String, dynamic> json)
      : id = convertValueByType(json['songId'], int, stack: "Song-songId"),
        name = json['songName'],
        artists = json['songArtist'],
        picUrl = json['songAvatar'],
        platform = json['platform'];

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'artists': artists,
        'picUrl': picUrl,
        'platform':platform
      };

  @override
  String toString() {
    return 'Song{id: $id, name: $name, artists: $artists,platform:$platform}';
  }
}
