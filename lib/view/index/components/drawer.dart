import 'package:flutter/material.dart';
import 'dart:async';
import 'package:yande/model/all_model.dart';
import 'package:yande/view/allView.dart';
import 'package:yande/store/store.dart';


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
                      Navigator.pushNamed(context, CollectImageView.route);
                    },
                  ),
                  new ListTile(
                    title: const Text('设置'),
                    onTap: (){
                      Navigator.pop(context);
                      Navigator.pushNamed(context, SettingView.route);
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
  List<TagModel> shortcutList = new List();

  @override
  void initState() {
    super.initState();
    this.getShortcutList();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: new Container(
        margin: new EdgeInsets.only(top: 15),
        child: new Column(
          children: <Widget>[
            _buildShortcutDrawerHeader(),
            new Expanded(
                child: _buildShortcutList()
            )
          ],
        ),
      )
    );
  }

  Widget _buildShortcutList() {
    Widget shortcutListView = new ListView(
      children: this.shortcutList.map(
          (tag) => new ListTile(
              title: new Text(tag.name),
              onTap: () {
                this._goResultView(tag.name);
              }
          )
      ).toList(),
    );
    return shortcutListView;
  }

  void getShortcutList() {
    this.shortcutList = TagStore.shortCutList;
  }

  _buildShortcutDrawerHeader({GestureTapCallback onPressed}) {
    return new Container(
      color: new Color(0xffeff0f1),
      child: new ListTile(
        title: const Text('快速搜索'),
        trailing: new MaterialButton(
          child: new Icon(Icons.settings),
          onPressed: onPressed
        ),
      ),
    );
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