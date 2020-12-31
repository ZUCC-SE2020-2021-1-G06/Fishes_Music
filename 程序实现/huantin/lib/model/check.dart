/// 音乐是否可用
/// 说明: 调用此接口,传入歌曲 id, 可获取音乐是否可用
/// 返回 { success: true, message: 'ok' } 或者 { success: false, message: '亲爱的,暂无版权' }

class Check {
  bool success;   // 是否成功
  String message; // 提示语

  Check(this.success,this.message);

  Check.fromJson(Map<String, dynamic> json)
      : success = json['success'],
        message = json['message'];

  Map<String, dynamic> toJson() => {
    'success': success,
    'message': message,
  };

  @override
  String toString() {
    return 'Check{success: $success, message: $message}';
  }
}
