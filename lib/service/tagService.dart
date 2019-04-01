import 'dart:async';
import 'package:yande/dao/tag_dao.dart';
import 'package:yande/http/all_api.dart';
import 'package:dio/dio.dart';
import 'package:yande/model/tag_model.dart';

class TagService {


  static Future<List<TagModel>> getTagByNameOrderAESC(String name) async{
    Dio dio = Dio();
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

const BLOCK_TAG = 'blockTag';