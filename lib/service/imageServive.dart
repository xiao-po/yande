import 'dart:async';
import 'package:yande/model/all_model.dart';
import 'package:yande/dao/all_dao.dart';
import 'API/all_api.dart';
import 'package:dio/dio.dart';
import 'dart:async';

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
      ImageModel dto =await ImageDao.isImageExistById(item.id);
      if(dto != null) {
        item.collectStatus = dto.collectStatus;
        item.downloadStatus = dto.downloadStatus;
        if (dto.downloadStatus == ImageDownloadStatus.success) {
          item.downloadPath = dto.downloadPath;
        } else if (dto.downloadStatus != null){
          item.downloadStatus = ImageDownloadStatus.error;
        }
      }
      item.pages = pages;
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
      ImageModel dto =await ImageDao.isImageExistById(item.id);
      if(dto != null) {
        item.collectStatus = dto.collectStatus;
        item.downloadStatus = dto.downloadStatus;
        if (dto.downloadStatus == ImageDownloadStatus.success) {
          item.downloadPath = dto.downloadPath;
        } else if (dto.downloadStatus != null){
          item.downloadStatus = ImageDownloadStatus.error;
        }
      }
      item.pages = pages;
      trueList.add(item);
    }
    return trueList;
  }


  static Future<ImageModel> collectImage(ImageModel image) async{
    image.collectStatus =
      (image.collectStatus == ImageCollectStatus.unStar || image.collectStatus == null)
          ? ImageCollectStatus.star : ImageCollectStatus.unStar;
    await ImageDao.collectImage(image);
    return image;
  }

  static Future<List<ImageModel>> getAllCollectedImage(int page, int limit) async {
    List imageList = await ImageDao.getAllCollectedImage();
    if (imageList != null && imageList.length > 0) {
      for (ImageModel imageModel in imageList) {
        imageModel.pages = page;
        imageModel.tagTagModelList = imageModel.tags.split(" ")
            .map((str) => new TagModel(null, str, null, null, null)).toList();
      }
    }
    return imageList;
  }

}
