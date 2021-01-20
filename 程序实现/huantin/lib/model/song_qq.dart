class SongQQ {
  String id; // 歌曲id
  String name; // 歌曲名称
  String artists; // 演唱者
  String picUrl; // 歌曲图片
  int platform; //所属平台

  SongQQ(this.id, this.platform, {this.name, this.artists, this.picUrl});

  SongQQ.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        artists = json['artists'],
        picUrl = json['picUrl'],
        platform = json['platform'];

  SongQQ.fromJson2(Map<String, dynamic> json)
      : id = json['songId'],
        name = json['songName'],
        artists = json['songArtist'],
        picUrl = json['songAvatar'],
        platform = json['platform'];

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'artists': artists,
        'picUrl': picUrl,
        'platform': platform,
      };

  @override
  String toString() {
    return 'Song{id: $id, name: $name, artists: $artists,platform:$platform}';
  }
}
