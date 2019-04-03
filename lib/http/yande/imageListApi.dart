import 'package:dio/dio.dart';
import 'package:yande/dao/image_dao.dart';
import 'package:yande/http/yande/YandeHttpDataSource.dart';
import 'package:yande/http/yande/constant/api.dart';
import 'package:yande/model/image_model.dart';
import 'package:yande/model/tag_model.dart';
import 'dart:async';

class YandeImageListApi {
  YandeImageHttpDataSource source;

  YandeImageListApi(this.source);

  Future<ImageModel> fetchImageById(String id) {
    return null;
  }

  Future<List<ImageModel>> fetchImageByPage(int page, int limit) async{
    String url = YandeApi.post + '?page=$page&limit=$limit';
    Response<List<dynamic>> res = await this.source.http.get(url);

    List<ImageModel> list = convertMapToImageModel(res);
    List<ImageModel> trueList = List();
    for (ImageModel item in list) {
      if (item.tags != null) {
        item.tagTagModelList = convertTagStringToList(item.tags);
      }
      ImageModel dto =await ImageDao.isImageExistById(item.id);
      if(dto != null) {
        item.setStatusByImage(dto);
      }
      item.pages = page;
      trueList.add(item);
    }
    return trueList;
  }


  Future<List<ImageModel>> getIndexListByTags
      (String tags,int pages, int limit) async {
    String url = YandeApi.post + '?tags=$tags&page=$pages&limit=$limit';

    Response<List<dynamic>> res = await this.source.http.get(url);

    List<ImageModel> list = convertMapToImageModel(res);
    List<ImageModel> trueList = List();
    for (ImageModel item in list) {
      if (item.tags != null) {
        item.tagTagModelList = convertTagStringToList(item.tags);

      }
      ImageModel dto =await ImageDao.isImageExistById(item.id);
      if(dto != null) {
        item.setStatusByImage(dto);
      }
      item.pages = pages;
      trueList.add(item);
    }
    return trueList;
  }
  List<ImageModel> convertMapToImageModel(Response<List> res) {
    List<ImageModel> list = res.data.map((item) =>
        ImageModel.fromJson(Map<String, dynamic>.from(item))).toList();
    return list;
  }



  List<TagModel> convertTagStringToList(String tags){
    return  tags.split(" ")
        .map((str) => TagModel(null, str, null, null, null)).toList();
  }


}