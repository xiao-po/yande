import 'dart:async';
import 'package:yande/model/all_model.dart';
import 'package:yande/dao/all_dao.dart';
import 'API/all_api.dart';
import 'package:dio/dio.dart';

class ImageService {

  static Future<List<ImageModel>> getIndexListByPage
      (int pages, int limit) async {
    Dio dio = new Dio();
    String url = IndexAPI.postList + '?page=$pages&limit=$limit';

    Response<List<dynamic>> res = await dio.get(url);

    List<ImageModel> list = res.data.map((item) =>
        ImageModel.fromJson(Map<String, dynamic>.from(item))).toList();
    List<ImageModel> trueList = new List();
    for (ImageModel item in list) {
      if (item.tags != null) {
        item.tagTagModelList = item.tags.split(" ")
            .map((str) => new TagModel(null, str, null, null, null)).toList();

      }
      item.isCollect =await ImageDao.isImageCollectExistById(item.id);
      trueList.add(item);
    }
    return trueList;
  }

  static Future<List<ImageModel>> getIndexListByTags
      (String tags,int pages, int limit) async {
    Dio dio = new Dio();
    String url = IndexAPI.postList + '?tags=$tags&page=$pages&limit=$limit';

    Response<List<dynamic>> res = await dio.get(url);

    List<ImageModel> list = res.data.map((item) =>
        ImageModel.fromJson(Map<String, dynamic>.from(item))).toList();
    List<ImageModel> trueList = new List();
    for (ImageModel item in list) {
      if (item.tags != null) {
        item.tagTagModelList = item.tags.split(" ")
            .map((str) => new TagModel(null, str, null, null, null)).toList();

      }
      trueList.add(item);
    }
    return trueList;
  }


  static Future<bool> collectImage(ImageModel image) async{
    bool isExist =await ImageDao.isImageCollectExistById(image.id);
    print(isExist);
    if (!isExist) {
      await ImageDao.collectImage(image);
      return true;
    } else {
      await ImageDao.deleteCollectById(image.id);
      return false;
    }


  }

  static Future<List<ImageModel>> getAllCollectedImage() async {

    List result = await ImageDao.getAllCollectedImage();
    List<ImageModel> imageList = new List();
    for (Map item in result) {
      Map map = Map<String, dynamic>.from(item);
      imageList.add(ImageModel.fromJson(map));
    }
    return imageList;
  }

}
