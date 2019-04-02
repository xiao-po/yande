import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:yande/http/yande/YandeHttpDataSource.dart';
import 'dart:async';
import 'package:yande/model/image_model.dart';
import 'package:yande/model/tag_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:yande/service/allServices.dart';
import 'package:yande/service/settingService.dart';


class Application {
    static Application instance = Application.init();

    Dio dio;
    FILTER_RANK filterRank;
    _AppDataSourcePool dataPool;
    Application.init(){
      dio = Dio();
      dataPool = _AppDataSourcePool(dio);
      dataPool.registryHttpSource(
          YandeImageHttpDataSource(dio)
      );

    }

    Future<void> updateFilterRank() async {
      SettingItem filterRankItem = await SettingService.getSetting(SETTING_TYPE.FILTER_RANK);
      this.filterRank = filterRankItem.value;
    }
}

abstract class AppDataSource {

  @required
  String sourceName;

  Future<List<ImageModel>> fetchNextPage(int page, int limit);
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

  final Dio http;
  _AppDataSourcePool(this.http);

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

    source.http = this.http;


    this._pool[source.sourceName] = source;

    if (this._activeSource == null) {
      _activeSource = source;
    }
  }
}