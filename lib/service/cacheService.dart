
import 'dart:async';
import 'dart:io';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class CacheService {
  static Future<File> getFile(String url) async {
    CacheManager cacheManager =await CacheManager.getInstance();
    return await cacheManager.getFile(url);
  }
}