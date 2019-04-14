import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:yande/dao/init_dao.dart';
import 'package:yande/http/yande/YandeHttpDataSource.dart';
import 'dart:async';
import 'package:yande/model/image_model.dart';
import 'package:yande/model/tag_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:yande/service/settingService.dart';
import 'package:yande/service/updateService.dart';


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
      SettingService.initSetting();
      UpdateService.ignoreUpdateVersion('');
      this.getFilterRank();
      dataPool = _AppDataSourcePool();
      dataPool.registryDataSource(
          YandeImageHttpDataSource(_dio)
      );
      dataPool.registryDataSource(
        DaoDataSource()
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
  get sourceName;

  Future<List<ImageModel>> fetchImageByPage(int page, int limit);
  Future<ImageModel> fetchImageById(int id);
  Future<List<ImageModel>> fetchImageByTag(String tag, int page, int limit);


}
abstract class AppHttpDataSource extends AppDataSource {
  Dio http;
  Future<List<TagModel>> searchTag(String words);
}

abstract class AppDaoDataSource extends AppDataSource {
  Future<Database> getDatabase();
  Future<bool> isImageExistById(int id);
  Future<void> updateDownloadImageStatus(ImageModel image);
  Future<void> collectImage(ImageModel image);
  Future<List<ImageModel>> getAllCollectedImage();
  Future<void> saveTag(TagModel tag);
  Future<List<TagModel>> getAllCollectTag();

  Future<List<TagModel>> getAllBlockTag();
}

class _AppDataSourcePool {
  Map<String, AppDataSource> _pool = Map();
  AppDataSource _activeSource;

  _AppDataSourcePool();

  AppDataSource getSource([String name]) {
    if (name == null) {
      return this._activeSource;
    } else {
      return this._pool[name];
    }
  }

  List<String> getAllHttpSourceNameList(){
    List keys = _pool.keys.toList();
    keys.removeWhere((value) =>  value == DaoDataSource.name);
    return keys;
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

  String getActiveSourceName() {
    return this._activeSource.sourceName;
  }
  void registryDataSource(AppDataSource source){
    if (source == null) {
      throw "source can't be null";
    }

    this._pool[source.sourceName] = source;

    if (this._activeSource == null) {
      _activeSource = source;
    }
  }
}