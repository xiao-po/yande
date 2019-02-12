import 'package:flutter/material.dart';
import 'dart:async';
import 'package:yande/view/allView.dart';
import 'package:yande/service/services.dart';


class LeftDrawer extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: const Text('yande'),
          ),
          MediaQuery.removePadding(
            context: context,
            child: ListTile(
              title: const Text('收藏'),
              onTap: () {
                Navigator.pop(context);

                Navigator.push(context,
                    MaterialPageRoute(
                        builder: (context) {
                          return CollectImageView();
                        }
                    ));
              },
            ),
          )
        ],
      ),
    );
  }

}

class RightDrawer extends StatefulWidget {


  @override
  State<RightDrawer> createState() => new _RightDrawerState();

}

class _RightDrawerState extends State<RightDrawer> {
  List<String> shortcutList = new List();

  @override
  void initState() {
    super.initState();
//    this.shortcutList.add('test');
    this.getShortcutList();
  }

  @override
  Widget build(BuildContext context) {
    Widget shortcutListView = new ListView(
      children: this.shortcutList.map(
              (word) => new ListTile(
              title: new Text(word),
              onTap: () {
                this._goResultView(word);
              }
          )
      ).toList(),
    );
    return Drawer(
      child: new Column(
        children: <Widget>[
          new Expanded(
              child: shortcutListView
          )
        ],
      )
    );
  }

  Future<void> getShortcutList() async{
    this.shortcutList =await ShortCutService.getShortCutList();
    setState(() {

    });
  }

  _goResultView(String word) {
    Navigator.pop(context);
    Navigator.push(
        context,
        new MaterialPageRoute(
            builder: (context) {
              return ResultView(
                tags: word,
              );
            }
        )
    );
  }

}