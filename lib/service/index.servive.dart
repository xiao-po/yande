import 'dart:async';
import 'package:yande/model/all_model.dart';
import 'API/all_api.dart';
import 'package:dio/dio.dart';

class IndexService {
  static Future<List<ImageModel>> getIndexListByPage
      (int pages, int limit) async {
    Dio dio = new Dio();
    String url = IndexAPI.postList + '?page=$pages&limit=$limit';

    Response<List<dynamic>> res = await dio.get(url);

    List<ImageModel> list = res.data.map((item) =>
        ImageModel.fromJson(Map<String, dynamic>.from(item))).toList();
    List<ImageModel> trueList = new List();
    for (ImageModel item in list) {
//      if (item.rating == 'e') { // 自主规制 哈哈哈哈
//        trueList.add(item);
//      }
      trueList.add(item);
    }
    print('debugger');
    return trueList;
  }

  static Future<List<TagModel>> getTagByNameOrderAESC(String name) async{
    Dio dio = new Dio();
    String url = IndexAPI.postList + '?limit=40&order=count&name=$name';

    Response<List<dynamic>> res = await dio.get(url);


  }
}
