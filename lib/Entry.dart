// Copyright 2017 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:the_earth/bear.dart';

class ExpansionTileSample extends StatelessWidget {

@override
    Widget build(BuildContext context) {

    return MaterialApp(
      routes: <String, WidgetBuilder> {
        '/bear': (BuildContext context) => new BearPage(),
        '/Entry': (BuildContext context) => new ExpansionTileSample(),
      },
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Picture Book'),
          backgroundColor: Colors.green[500],
        ),

        body: ListView.builder(
          itemBuilder: (BuildContext context, int index) =>
              EntryItem(data[index]),

          itemCount: data.length,
        ),
      ),
    );
  }

}

// One entry in the multilevel list displayed by this app.
class Entry {

  Entry(this.title, [this.children = const <Entry>[]]);

  final String title;
  final List<Entry> children;
}

// The entire multilevel list displayed by this app.
final List<Entry> data = <Entry>[
  Entry(
    '陸上の生き物',
    <Entry>[
      Entry(
        '哺乳類',
        <Entry>[
          Entry('ヒグマ'),
          Entry('ホッキョクグマ'),
          Entry('ツキノワグマ'),
        ],
      ),
      Entry(
        '昆虫類',
        <Entry>[
          Entry('アゲハチョウ'),
          Entry('モンシロチョウ'),
          Entry('ゴマダラチョウ'),
        ],
      ),

    ],
  ),
  Entry(
    '水辺の生き物',
    <Entry>[
      Entry(
          '海の生き物',
        <Entry>[
          Entry('アジ'),
          Entry('タコ'),
          Entry('サメ'),
        ],
      ),
      Entry(
          '川の生き物',
          <Entry>[
            Entry('コイ'),
            Entry('ブラックバス'),
            Entry('ドジョウ'),
        ],
      ),
      Entry('池・湖の生き物'),
    ],
  ),
  Entry(
    '空の生き物',
    <Entry>[
      Entry(
        '鳥類',
        <Entry>[
          Entry('ハト'),
          Entry('スズメ'),
          Entry('ワシ'),
          Entry('カラス'),
        ],
      ),
    ],
  ),
];

// Displays one Entry. If the entry has children then it's displayed
// with an ExpansionTile.
class EntryItem extends StatelessWidget {

  const EntryItem(this.entry);

  final Entry entry;

    Widget _buildTiles(Entry root) {
      if (root.children.isEmpty) {
          return ListTile(
            title: Text(root.title),
            onTap: (){
            }
          );
      }
      return ExpansionTile(
        key: PageStorageKey<Entry>(root),
        title: Text(root.title),
        children: root.children.map(_buildTiles).toList(),
      );
  }
  @override
  Widget build(BuildContext context) {
    return _buildTiles(entry);
  }
}

void main() {
  runApp(ExpansionTileSample());
}


