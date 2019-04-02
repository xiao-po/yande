import 'package:flutter/material.dart';
import 'package:yande/service/allServices.dart';
import 'package:yande/widget/progress.dart';
import 'dart:async';

import 'subview/dirPickerView.dart';

class SettingView extends StatefulWidget {
  static const title = '设置';
  static const route = '/setting';
  @override
  State<StatefulWidget> createState() => _SettingViewState();

}

class _SettingViewState extends State<SettingView> {

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool initSuccess = false;
  List<SettingItem<String>> settingList;

  List<_DropButtonData> dropButtonDataList = [
      _DropButtonData(name: '正常向', value: 's'),
      _DropButtonData(name: '擦边', value: 'q'),
      _DropButtonData(name: '限制', value: 'e')
  ];

  @override
  void initState() {
    super.initState();
    this.getAllSetting();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        leading: BackButton(),
        title: const Text('设置'),
      ),
      body: _buildSettingList(),
    );
  }

  _buildSettingList() {
    if (this.initSuccess) {
      return ListView(
        children: this.settingList.map((v) => _buildSettingItem(v)).toList(),
      );
    } else {
      return Container(
        child: Center(
          child:  CenterProgress(),
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
      return ListTile(
        title: Text(v.name),
        subtitle: Text(v.value),
        trailing: Icon(Icons.arrow_forward_ios),
        onTap: () async{
          String path =await Navigator.push(context, MaterialPageRoute(builder: (c) {
            return DirectoryPickerView(v.value);
          }));
          if (path != null) {
            _handlePickedName(v, path);
          }
        },
      );
    } else if (v.name == SETTING_TYPE.FILTER_RANK) {
      return ListTile(
        title: Text(v.name),
        subtitle: Text(this.getRankNameByValue(v.value)),
        trailing: DropdownButton<String>(
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
            return DropdownMenuItem<String>(
              value: data.value,
              child: Text(data.name),
            );
          }).toList(),
        ),
      );
    } else {
      return Container();
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
      SnackBar(
          content: Text(text),
          duration: Duration(seconds: 1),
      ),
    );
  }
}

class _DropButtonData{
  String name;
  String value;

  _DropButtonData({this.name, this.value});
}

