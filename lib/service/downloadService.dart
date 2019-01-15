import 'dart:async';
import 'package:yande/model/all_model.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:dio/dio.dart';


class DownloadService {
  static Future<void> downloadImage (ImageModel image) async {
    Dio dio = new Dio();
    Directory yandeImageDir = await DownloadService.getImageDir();
    String yandeImageDirPath = yandeImageDir.path;
    await dio.download(image.fileUrl, '$yandeImageDirPath/${image.id}.${image.fileExt}');
    print(yandeImageDirPath);
  }

  static Future<Directory> getImageDir() async {
    Directory appDocDir = await getExternalStorageDirectory();
    Directory yandeImageDir = new Directory("${appDocDir.path}/DCIM/yandeImage");
    bool isExist = await yandeImageDir.exists();
    if (isExist) {
      return yandeImageDir;
    } else {
      return await yandeImageDir.create();
    }
  }
}