import 'dart:async';
import 'package:yande/model/all_model.dart';
import 'API/all_api.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';
import 'package:yande/dao/all_dao.dart';

class TagService {


  static Future<List<TagModel>> getTagByNameOrderAESC(String name) async{
    Dio dio = new Dio();
    String url = IndexAPI.tagList + '?limit=40&order=count&name=$name';

    Response<List<dynamic>> res = await dio.get(url);

    List<TagModel> tagList = res.data.map((item) =>
        TagModel.fromJson(Map<String, dynamic>.from(item))).toList();

    return tagList;
  }


  static Future<void> saveTag(TagModel tag) async{
    await TagDao.saveTag(tag);
  }


  static Future<List<TagModel>> getAllCollectTag() async{
    return await TagDao.getAllCollectTag();
  }

  static Future<List<TagModel>> getAllBlockTag() async {
    return await TagDao.getAllBlockTag();
  }



  static setCollectStatus(TagModel tag) async {
    tag.collectStatus = TagCollectStatus.collected;
    await TagService.saveTag(tag);
  }

}

final BLOCK_TAG = 'blockTag';