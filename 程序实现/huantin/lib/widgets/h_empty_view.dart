import 'package:flutter/material.dart';

//横向空组件（用于占位）

class HEmptyView extends StatelessWidget {
  final double width;

  HEmptyView(this.width);

  @override
  Widget build(BuildContext context) {
    return SizedBox(width: width,);
  }
}