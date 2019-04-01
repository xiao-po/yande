import 'package:dio/dio.dart';
import 'dart:async';
import 'package:yande/model/image_model.dart';


class Application {
    Dio dio;
    static Application instance = Application.init();
    Application.init(){
      dio = Dio();
    }
}

abstract class AppDataSource {
  Future<List<ImageModel>> fetchNextPage(int page, int limit);
  Future<ImageModel> fetchImageById(String id);
}