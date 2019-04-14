import 'package:yande/appliction.dart';
import 'package:dio/dio.dart';
import 'package:yande/dao/init_dao.dart';
import 'package:yande/http/yande/constant/api.dart';
import 'package:yande/http/yande/imageListApi.dart';
import 'package:yande/http/yande/tagApi.dart';
import 'dart:async';

import 'package:yande/model/image_model.dart';
import 'package:yande/model/tag_model.dart';


class YandeImageHttpDataSource implements AppDataSource {

  String sourceName = YandeApi.sourceName;

  Dio http;
  YandeImageListApi _imageListApi;

  TagApi _tagApi;

  YandeImageHttpDataSource(Dio http) {
    this.http = http;
    this._tagApi = TagApi(this);
    this._imageListApi = YandeImageListApi(this);
  }



  @override
  Future<ImageModel> fetchImageById(int id) {
    return null;
  }

  @override
  Future<List<ImageModel>> fetchImageByPage(int page, int limit) async{
    return _imageListApi.fetchImageByPage(page, limit);
  }

  @override
  Future<List<TagModel>> searchTag(String words) {
    return _tagApi.getTagByNameOrderAESC(words);
  }

  @override
  Future<List<ImageModel>> fetchImageByTag(String tag, int page, int limit) {
    return _imageListApi.getIndexListByTags(tag, page, limit);
  }



}