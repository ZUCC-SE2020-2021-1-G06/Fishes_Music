// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:huantin/main.dart';
import 'package:huantin/model/search_result.dart';
import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';

void main() {
  test("测试网络请求", () async {

    final response = await http.get(
      "http://118.24.63.15:1020/login/cellphone?phone=18867964303&password=XHS947xcwy001022",
    );
      expect(response.statusCode,200);
      print(response.request);

  });
}
