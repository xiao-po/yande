import 'package:dio/dio.dart';
import 'package:yande/dao/image_dao.dart';
import 'package:yande/http/yande/YandeHttpDataSource.dart';
import 'package:yande/http/yande/constant/api.dart';
import 'package:yande/model/image_model.dart';
import 'package:yande/model/tag_model.dart';
import 'dart:async';

class TagApi {
  YandeImageHttpDataSource source;

  TagApi(this.source);

  Future<List<TagModel>> getTagByNameOrderAESC(String name) async{
    Dio dio = Dio();
    String url = YandeApi.tag + '?limit=40&order=count&name=$name';

    Response<List<dynamic>> res = await dio.get(url);

    List<TagModel> tagList = res.data.map((item) =>
        TagModel.fromJson(Map<String, dynamic>.from(item))).toList();

    return tagList;
  }

  Future<ImageModel> searchImageByTag() {

  }


}