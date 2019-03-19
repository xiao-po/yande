import 'package:flutter/material.dart';
import 'package:yande/service/allServices.dart';
import 'dart:async';
import 'package:yande/widget/allWidget.dart';

import 'subview/dirPickerView.dart';

class SettingView extends StatefulWidget {
  static const title = '设置';
  static const route = '/setting';
  @override
  State<StatefulWidget> createState() => _SettingViewState();

}

class _SettingViewState extends State<SettingView> {

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool initSuccess = false;
  List<SettingItem> settingList;

  List<_DropButtonData> dropButtonDataList = [
      new _DropButtonData(name: '正常向', value: 's'),
      new _DropButtonData(name: '擦边', value: 'q'),
      new _DropButtonData(name: '限制', value: 'e')
  ];

  @override
  void initState() {
    super.initState();
    this.getAllSetting();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: _scaffoldKey,
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
    if (this.mounted) {
      setState(() {});
    }
  }

  Widget _buildSettingItem(SettingItem v) {
    if (v.name == SETTING_TYPE.IMAGE_DOWNLOAD_PATH) {
      return new ListTile(
        title: new Text(v.name),
        subtitle: new Text(v.value),
        trailing: new Icon(Icons.arrow_forward_ios),
        onTap: () async{
          String path =await Navigator.push(context, new MaterialPageRoute(builder: (c) {
            return new DirectoryPickerView(v.value);
          }));
          if (path != null) {
            _handlePickedName(v, path);
          }
        },
      );
    } else if (v.name == SETTING_TYPE.FILTER_RANK) {
      return new ListTile(
        title: new Text(v.name),
        subtitle: new Text(this.getRankNameByValue(v.value)),
        trailing: new DropdownButton<String>(
          value: v.value,
          onChanged: (String newValue) {
            v.value = newValue;
            SettingService.saveSetting(v);
            this._showMessageBySnackbar("过滤等级更新成功，刷新之后生效");
            if (this.mounted) {
              setState(() {});
            }
          },
          items: this.dropButtonDataList.map((_DropButtonData data) {
            return new DropdownMenuItem<String>(
              value: data.value,
              child: new Text(data.name),
            );
          }).toList(),
        ),
      );
    }
  }

  String getRankNameByValue(String val) {
    for(_DropButtonData data in this.dropButtonDataList) {
      if (data.value == val) {
        return data.name;
      }
    }
    throw Error();
  }

  FutureOr _handlePickedName(SettingItem item, String path) async{
    item.value = path;
    await SettingService.saveSetting(item);
    if (this.mounted) {
      setState(() {});
    }
  }

  _showMessageBySnackbar(String text) {
    _scaffoldKey.currentState.showSnackBar(
      new SnackBar(
          content: Text(text),
          duration: new Duration(seconds: 1),
      ),
    );
  }
}

class _DropButtonData{
  String name;
  String value;

  _DropButtonData({this.name, this.value});
}

