import 'package:flutter/material.dart';


class Setting extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new Scaffold(
        appBar: new AppBar(
          title: new Text('設定'),
        ),
        body: new Center(
          child: new Text('設定画面だよ'),
        ),
      ),
    );
  }
}