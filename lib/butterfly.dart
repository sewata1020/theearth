import 'package:flutter/material.dart';

void main() {
  runApp(new MyApp());
}
class MyApp extends StatelessWidget {

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
        title: new Text('The Earth'),
      ),
      body:
      Column(children: <Widget>[
        new Image.asset(
          'images/ageha.jpg',
          fit:BoxFit.fill,
          width: 500.0,
          height: 350.0,
        ),
        new Center(
          child:
          new Text(
            "アゲハチョウ",
            style: new TextStyle(fontSize:35.0,
                color: const Color(0xFF000000),
                fontWeight: FontWeight.w200,
                fontFamily: "Roboto"),
          ),
        ),
        Text("昆虫 > チョウ目 > アゲハチョウ科\n\n"),
        Text("分　布：全国的に分布"),
        Text("生息地：農地や伐採地などのミカン類が生える場所"),
        Text("時　期：4～10月"),
      ],)
    );
  }
}