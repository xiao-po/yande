import 'dart:async';
import 'package:yande/appliction.dart';
import 'package:yande/dao/image_dao.dart';
import 'package:yande/dao/init_dao.dart';
import 'package:yande/model/image_model.dart';
import 'package:yande/model/tag_model.dart';
import 'package:yande/service/settingService.dart';
import 'package:yande/store/store.dart';

class ImageService {

  static Future<List<ImageModel>> getIndexListByPage
      (int pages, int limit, {String sourceName}) async {
    AppDataSource source = _getAppDataSource(sourceName);
    List<ImageModel> list =await  source.fetchImageByPage(pages, limit);
    list.removeWhere(_imageFilter);
    list.removeWhere((image) => TagStore.isBlockedByName(image.tags));
    return list;
  }


  static Future<List<ImageModel>> getImageByTag
      (String tags,int pages, int limit, {String sourceName}) async {
    AppDataSource source = _getAppDataSource(sourceName);
    List<ImageModel> list =await source.fetchImageByTag(tags ,pages, limit);
    list.removeWhere(_imageFilter);
    list.removeWhere((image) => TagStore.isBlockedByName(image.tags));
    return list;
  }


  static Future<ImageModel> collectImage(ImageModel image) async{
    AppDaoDataSource source = _getAppDataSource(DaoDataSource.name);
    image.collectStatus =
      (image.collectStatus == ImageCollectStatus.unStar || image.collectStatus == null)
          ? ImageCollectStatus.star : ImageCollectStatus.unStar;
    await source.collectImage(image);
    return image;
  }

  static Future<List<ImageModel>> getAllCollectedImage(int page, int limit) async {
    AppDaoDataSource source = _getAppDataSource(DaoDataSource.name);
    List imageList = await source.getAllCollectedImage();
    if (imageList != null && imageList.length > 0) {
      for (ImageModel imageModel in imageList) {
        imageModel.pages = page;
        imageModel.tagTagModelList = imageModel.tags.split(" ")
            .map((str) => TagModel(null, str, null, null, null)).toList();
      }
    }
    return imageList;
  }


  static bool _imageFilter(ImageModel image) {
    var filterRank = Application.getInstance().filterRank;
    if (filterRank == FILTER_RANK.RESTRICTED) {
      return false;
    } else if (filterRank == FILTER_RANK.NOT_RESTRICTED) {
      return image.rating == FILTER_RANK.RESTRICTED ? true : false;
    } else {
      return image.rating == FILTER_RANK.RESTRICTED
          || image.rating == FILTER_RANK.NOT_RESTRICTED ? true : false;
    }
  }


  static AppDataSource _getAppDataSource(String sourceName) {
    AppDataSource source = Application.getInstance().dataPool.getSource(sourceName);
    return source;
  }

}
