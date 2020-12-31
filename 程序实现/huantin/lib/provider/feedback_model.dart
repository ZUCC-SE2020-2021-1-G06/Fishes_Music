import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:huantin/model/feedback.dart';
import 'package:huantin/utils/utils.dart';

class FeedbackModel with ChangeNotifier{
  Feedback _feedback;
  List<Feedback> _feedbacks;

  Feedback get feedback => _feedback;

  set feedback(Feedback value) {
    _feedback = value;
  }


  ///添加用户反馈
  /*Future<Feedback> addSug(BuildContext context, String username, String suggestion) async{
    Response response = await Dio().get(
        "http://10.64.70.108:8080/feedback/add?username=" +
            username + "&suggestion=" + suggestion);
    if (response.statusCode == 200) {
      Utils.showToast( '登录成功');
      var feedback = new Feedback();
      feedback.username = username;
      feedback.suggestion = suggestion;
      return feedback;
    }
    else{
      Utils.showToast('登录失败，请检查用户名密码');
      return null;
    }
  }*/

  void loadFeedback(String username) async{
    List<Feedback> feedbackList;
    Response response = await Dio().get(
        "http://121.196.105.48:8080/feedback/search?username=" +
          username);
    if(response.statusCode == 200){
      this._feedbacks = response.data;
    }
    else{
      return null;
    }

  }
  List<Feedback> load(){
    return this._feedbacks;
  }
}