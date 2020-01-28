import 'package:flutter/material.dart';

void main() {
  runApp(new BearPage());
}
class BearPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Generated App',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
        primaryColor: const Color(0xFF2196f3),
        accentColor: const Color(0xFF2196f3),
        canvasColor: const Color(0xFFfafafa),
      ),
      home: new MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);
  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text('ホッキョクグマ'),
        ),
        body:
        Column(children: <Widget>[
          new Image.asset(
            'images/kuma.jpg',
            fit:BoxFit.fill,
            width: 500.0,
            height: 350.0,
          ),
          new Center(
            child:
            new Text(
              "ホッキョクグマ",
              style: new TextStyle(fontSize:35.0,
                  color: const Color(0xFF000000),
                  fontWeight: FontWeight.w200,
                  fontFamily: "Roboto"),
            ),
          ),
          Text("哺乳類 > ネコ目 > クマ科\n\n"),
          Text("全　長：(♂)200-250cm, (♀)180-200cm"),
          Text("体　重：(♂)400-600kg, (♀)200-350kg\n"),
          Text("生息地：北極, ユーラシア大陸北部, 北アメリカ大陸北部"),
          Text("動物園：上野動物園, 天王寺動物園, 王子動物園 など"),
          Text("生　態：流氷水域や海岸などに生息"),
        ],)
    );
  }
}