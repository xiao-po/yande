import 'package:share_extend/share_extend.dart';
import 'dart:async';
import 'dart:io';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class ShareService {
  static Future<void> shareImage(url) async{
    File imageFile =await ShareService._getImageFileFromCacheManager(url);
    await ShareExtend.share(imageFile.path, "image");
  }

  static Future<File> _getImageFileFromCacheManager(String url) async {
    var cacheManager = await CacheManager.getInstance();
    return await cacheManager.getFile(url);
  }


}