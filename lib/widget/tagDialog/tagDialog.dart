import 'package:flutter/material.dart';

class TagDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      children: <Widget>[
        new ListTile(
          title: new Text('加入快捷搜索'),
          onTap: () {
            print('加入');
          },
        ),
        new ListTile(
          title: new Text('过滤'),
          onTap: () {
            print('过滤');
          },
        )
      ],
    );
  }

}