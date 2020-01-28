import 'package:flutter/material.dart';
import 'package:the_earth/MapPage.dart';
import 'Entry.dart';
import 'bear.dart';
import 'setting.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: <String, WidgetBuilder> {
        '/entry': (BuildContext context) => new ExpansionTileSample(),
        '/setting': (BuildContext context) => new Setting(),
        '/bear': (BuildContext context) => new BearPage(),
      },
      title: 'The Earth',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MapPage(),
    );
  }
}