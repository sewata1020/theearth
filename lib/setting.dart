import 'package:flutter/material.dart';


class Setting extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new Scaffold(
        appBar: new AppBar(

          title: new Text('設定'),

          backgroundColor: Colors.grey[600],
        ),
        body: new Center(
          child: RaisedButton(
            child: Text('Back'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),

      ),
    );
  }
}