import 'package:flutter/material.dart';
import 'dart:async';
import 'package:yande/view/allView.dart';
import 'package:yande/service/allServices.dart';


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
            child: new Expanded(
              child: new ListView(
                children: <Widget>[
                  new ListTile(
                    title: const Text('收藏'),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(context,
                          MaterialPageRoute(
                              builder: (context) {
                                return CollectImageView();
                              }
                          )
                      );
                    },
                  ),
                  new ListTile(
                    title: const Text('设置'),
                    onTap: (){
                      Navigator.pop(context);
                      Navigator.pushNamed(context, '/setting');
                    },
                  )
                ],
              ),
            )

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
      child: new Container(
        margin: new EdgeInsets.only(top: 15),
        child: new Column(
          children: <Widget>[
            new Container(
              color: new Color(0xffeff0f1),
              child: new ListTile(
                title: const Text('快速搜索'),
                trailing: new MaterialButton(
                  child: new Icon(Icons.settings),
                  onPressed: () {
                    print('config');
                  },
                ),
              ),
            ),
            new Expanded(
                child: shortcutListView
            )
          ],
        ),
      )
    );
  }

  Future<void> getShortcutList() async{
    this.shortcutList = (await ShortCutService.getShortCutList())??new List();
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