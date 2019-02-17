import 'package:share_extend/share_extend.dart';
import 'dart:async';
import 'dart:io';

import 'allServices.dart';

class ShareService {
  static Future<void> shareImage(url) async{
    File imageFile =await CacheService.getFile(url);
    await ShareExtend.share(imageFile.path, "image");
  }



}