import 'package:flutter/material.dart';
import 'package:yande/service/services.dart';
import 'dart:async';
import 'package:yande/widget/allWidget.dart';

import 'subview/dirPickerView.dart';

class SettingView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SettingViewState();

}

class _SettingViewState extends State<SettingView> {

  bool initSuccess = false;
  List<SettingItem> settingList;

  @override
  void initState() {
    super.initState();
    this.getAllSetting();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        leading: new BackButton(),
        title: const Text('设置'),
      ),
      body: _buildSettingList(),
    );
  }

  _buildSettingList() {
    if (this.initSuccess) {
      return new ListView(
        children: this.settingList.map((v) => _buildSettingItem(v)).toList(),
      );
    } else {
      return new Container(
        child: new Center(
          child:  new CenterProgress(),
        ),
      );
    }
  }

  Future<void> getAllSetting() async{
    settingList =await SettingService.getAllSetting();
    this.initSuccess = true;
    setState(() {

    });
  }

  Widget _buildSettingItem(SettingItem v) {
    if (v.name == SETTING_TYPE.IMAGE_DOWNLOAD_PATH) {
      return new ListTile(
        title: new Text(v.name),
        subtitle: new Text(v.value),
        onTap: () async{
          String path =await Navigator.push(context, new MaterialPageRoute(builder: (c) {
            return new DirectoryPickerView(v.value);
          }));
          if (path != null) {
            _handlePickedName(v, path);
          }
        },
      );
    }
  }

  FutureOr _handlePickedName(SettingItem item, String path) async{
    item.value = path;
    await SettingService.saveSetting(item);
    setState(() {

    });
  }
}


