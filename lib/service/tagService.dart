import 'dart:async';
import 'package:yande/appliction.dart';
import 'package:yande/dao/init_dao.dart';
import 'package:yande/dao/tag_dao.dart';
import 'package:yande/http/all_api.dart';
import 'package:dio/dio.dart';
import 'package:yande/model/tag_model.dart';

class TagService {


  static Future<List<TagModel>> getTagByNameOrderAESC(String name, {String sourceName}) async{

    AppHttpDataSource _source = TagService._getAppDataSource(sourceName);
    return _source.searchTag(name);
  }


  static Future<void> saveTag(TagModel tag) async{
    DaoDataSource _source = TagService._getAppDataSource(DaoDataSource.name);
    await _source.saveTag(tag);
  }


  static Future<List<TagModel>> getAllCollectTag() async{
    DaoDataSource _source = TagService._getAppDataSource(DaoDataSource.name);
    return await _source.getAllCollectTag();
  }

  static Future<List<TagModel>> getAllBlockTag() async {
    DaoDataSource _source = TagService._getAppDataSource(DaoDataSource.name);
    return await _source.getAllBlockTag();
  }



  static setCollectStatus(TagModel tag) async {
    tag.collectStatus = TagCollectStatus.collected;
    await TagService.saveTag(tag);
  }


  static AppDataSource _getAppDataSource(String sourceName) {
    AppDataSource source = Application.getInstance().dataPool.getSource(sourceName);
    return source;
  }
}

const BLOCK_TAG = 'blockTag';