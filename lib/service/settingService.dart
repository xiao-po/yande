import 'package:shared_preferences/shared_preferences.dart';
import 'package:path_provider/path_provider.dart';

import 'dart:async';
import 'dart:io';

class SettingService {

  static final List<SettingItem> settingList = [
    new SettingItem(
      name: SETTING_TYPE.IMAGE_DOWNLOAD_PATH,
      value: '',
    ),
    new SettingItem(
      name: SETTING_TYPE.FILTER_RANK,
      value: FILTER_RANK.RESTRICTED,
    )
  ];

  static Future<void> initSetting([bool force]) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getBool("initSetting") != true || force == true) {

      for (SettingItem item in settingList) {
        if (item.name == SETTING_TYPE.IMAGE_DOWNLOAD_PATH) {

          Directory appDocDir = await getExternalStorageDirectory();
          Directory yandeImageDir = new Directory("${appDocDir.path}/DCIM/yandeImage");
          bool isExist = await yandeImageDir.exists();
          if (!isExist) {
            await yandeImageDir.create();
          }
          item.value = yandeImageDir.path;
          SettingService.saveSetting(item);
        } else if (item.name == SETTING_TYPE.FILTER_RANK) {
          SettingService.saveSetting(item);
        }
      }

      await prefs.setBool("initSetting", true);
    } else {
      SettingService.getAllSetting();
    }

  }

  static Future<void> saveSetting(SettingItem settingItem) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(settingItem.name, settingItem.value);
  }

  static Future<SettingItem> getSetting(String name) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String value = prefs.getString(name);
    return new SettingItem(
      name: name,
      value: value
    );
  }

  static Future<List<SettingItem>> getAllSetting() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    for(SettingItem item in settingList) {
      item.value = prefs.getString(item.name)??item.value;
    }
    return settingList;
  }
}

class SETTING_TYPE {
  static const String IMAGE_DOWNLOAD_PATH = '图片下载路径';
  static const String FILTER_RANK = "过滤等级";
}

class FILTER_RANK {
  static const String NORMAL = 's';
  static const String NOT_RESTRICTED = 'q';
  static const String RESTRICTED = 'e';

}

class SettingItem {
  String name;
  String value;

  SettingItem({
    this.name,
    this.value
  }):assert(name != null), assert(value != null);
}