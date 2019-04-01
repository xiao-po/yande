import 'package:flutter/material.dart';

class TagDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      children: <Widget>[
        ListTile(
          title: Text('加入快捷搜索'),
          onTap: () {
            print('加入');
          },
        ),
        ListTile(
          title: Text('过滤'),
          onTap: () {
            print('过滤');
          },
        )
      ],
    );
  }

}