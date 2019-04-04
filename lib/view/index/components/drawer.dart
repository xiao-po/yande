import 'package:flutter/material.dart';
import 'package:yande/model/tag_model.dart';
import 'package:yande/store/store.dart';
import 'package:yande/view/collectView/collectImageView.dart';
import 'package:yande/view/search/resultView.dart';
import 'package:yande/view/setting/settingView.dart';


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
            child: Expanded(
              child: ListView(
                children: <Widget>[
                  ListTile(
                    title: const Text('收藏'),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, CollectImageView.route);
                    },
                  ),
                  ListTile(
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
  State<RightDrawer> createState() => _RightDrawerState();
}

class _RightDrawerState extends State<RightDrawer> {
  List<TagModel> shortcutList = List();

  @override
  void initState() {
    super.initState();
    this.getShortcutList();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        margin: EdgeInsets.only(top: 15),
        child: Column(
          children: <Widget>[
            _buildShortcutDrawerHeader(),
            Expanded(
                child: _buildShortcutList()
            )
          ],
        ),
      )
    );
  }

  Widget _buildShortcutList() {
    Widget shortcutListView = ListView(
      children: this.shortcutList.map(
          (tag) => ListTile(
              title: Text(tag.name),
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
    return Container(
      color: Color(0xffeff0f1),
      child: ListTile(
        title: const Text('快速搜索'),
        trailing: MaterialButton(
          child: Icon(Icons.settings),
          onPressed: onPressed
        ),
      ),
    );
  }

  _goResultView(String word) {
    Navigator.pop(context);
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) {
              return ResultView(
                tags: word,
              );
            }
        )
    );
  }

}