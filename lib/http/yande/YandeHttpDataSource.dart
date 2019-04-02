import 'package:yande/appliction.dart';
import 'package:dio/dio.dart';
import 'package:yande/http/yande/constant/api.dart';
import 'package:yande/http/yande/imageListApi.dart';
import 'dart:async';

import 'package:yande/model/image_model.dart';
import 'package:yande/model/tag_model.dart';


class YandeImageHttpDataSource implements AppDataSource {

  String sourceName = YandeApi.sourceName;

  Dio http;
  YandeImageListApi _imageListApi;

  YandeImageHttpDataSource(Dio http) {
    this.http = http;

    this._imageListApi = YandeImageListApi(this);
  }



  @override
  Future<ImageModel> fetchImageById(String id) {
    return null;
  }

  @override
  Future<List<ImageModel>> fetchNextPage(int page, int limit) async{
    return _imageListApi.fetchNextPage(page, limit);
  }

  @override
  Future<List<TagModel>> searchTag(String words) {
    return null;
  }



}