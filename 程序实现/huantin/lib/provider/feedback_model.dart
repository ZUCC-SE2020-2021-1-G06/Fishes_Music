import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:huantin/model/feedback.dart';
import 'package:huantin/utils/utils.dart';

class FeedbackModel with ChangeNotifier {
  FeedbackLocal _feedback;
  List<FeedbackLocal> _feedbacks = [];

  FeedbackLocal get feedback => _feedback;

  set feedback(FeedbackLocal value) {
    _feedback = value;
  }

  ///添加用户反馈
  Future<FeedbackLocal> addSug(
      BuildContext context, String username, String suggestion) async {
    Response response = await Dio().get(
        "http://121.196.105.48:8080/feedback/add?username=" +
            username +
            "&suggestion=" +
            suggestion);
    if (response.statusCode == 200) {
      Utils.showToast('反馈成功');
      var feedback = new FeedbackLocal();
      feedback.username = username;
      feedback.suggestion = suggestion;
      return feedback;
    } else {
      Utils.showToast('反馈失败');
      return null;
    }
  }

  void loadFeedback(String username) async {
    List<FeedbackLocal> feedbacks = [];
    Response response = await Dio()
        .get("http://121.196.105.48:8080/feedback/search?username=" + username);
    if (response.statusCode == 200) {
      for (var item in response.data) {
        if (item != null) {
          feedbacks.add(FeedbackLocal.fromJson(item));
        }
      }
      this._feedbacks = feedbacks;
    } else {
      return null;
    }
  }

  void loadAllFeedback() async {
    List<FeedbackLocal> feedbacks = [];
    Response response =
        await Dio().get("http://121.196.105.48:8080/feedback/searchAll");
    if (response.statusCode == 200) {
      for (var item in response.data) {
        if (item != null) {
          feedbacks.add(FeedbackLocal.fromJson(item));
        }
      }
      this._feedbacks = feedbacks;
    } else {
      return null;
    }
  }

  List<FeedbackLocal> load() {
    return this._feedbacks;
  }

  void checkFeedback(String id) async {
    Response response =
        await Dio().get("http://121.196.105.48:8080/feedback/modify?id=" + id);
    if (response.statusCode == 200) {
      Utils.showToast('处理成功');
    }
    else {
      Utils.showToast('处理失败');
      return null;
    }
  }
}
