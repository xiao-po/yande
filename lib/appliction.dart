import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:yande/http/yande/YandeHttpDataSource.dart';
import 'dart:async';
import 'package:yande/model/image_model.dart';
import 'package:yande/model/tag_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:yande/service/settingService.dart';


class Application {
    static Application _instance = Application.init();

    static Application getInstance() {
      return Application._instance;
    }
    Dio _dio;
    String filterRank;
    _AppDataSourcePool dataPool;
    Application.init(){
      _dio = Dio();
      dataPool = _AppDataSourcePool();
      dataPool.registryHttpSource(
          YandeImageHttpDataSource(_dio)
      );

    }

    Future<void> getFilterRank() async {
      SettingItem filterRankItem = await SettingService.getSetting(SETTING_TYPE.FILTER_RANK);
      this.filterRank = filterRankItem.value;
    }
    Future<void> setFilterRank(SettingItem item) async {
      SettingService.saveSetting(item);
      this.filterRank = item.value;
    }

}

abstract class AppDataSource {

  @required
  String sourceName;

  Future<List<ImageModel>> fetchImageByPage(int page, int limit);
  Future<ImageModel> fetchImageById(String id);
  Future<List<TagModel>> searchTag(String words);
}
abstract class AppHttpDataSource extends AppDataSource {

  Dio http;
}

abstract class AppDaoDataSource extends AppDataSource {
  Database database;
}

class _AppDataSourcePool {
  Map<String, AppDataSource> _pool = Map();
  AppDataSource _activeSource;

  _AppDataSourcePool();

  AppDataSource getHttpSource([String name]) {
    if (name == null) {
      return this._activeSource;
    } else {
      return this._pool[name];
    }
  }

  void switchHttpSource(String name) {
    if ( this._pool[name] != null) {
      this._activeSource = this._pool[name];
    } else {
      throw 'no instance called "$name" in pool';
    }
  }

  void removeHttpSource(String name) {
    if (this._pool.containsKey(name)) {
      this._pool.remove(name);
    }
  }

  void registryHttpSource(AppDataSource source){
    if (source == null) {
      throw "source can't be null";
    }

    this._pool[source.sourceName] = source;

    if (this._activeSource == null) {
      _activeSource = source;
    }
  }
}