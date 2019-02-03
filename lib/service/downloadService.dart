import 'dart:async';
import 'package:yande/model/all_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:yande/dao/all_dao.dart';
import 'dart:io';
import 'package:dio/dio.dart';


class DownloadService {
  static Future<void> downloadImage (ImageModel image) async {
    Dio dio = new Dio();

    image.downloadStatus = ImageDownloadStatus.pending;
    await ImageDao.updateDownloadImageStatus(image);

    try {
      Directory yandeImageDir = await DownloadService.getImageDir();
      String yandeImageDirPath = yandeImageDir.path;
      String filePath = '$yandeImageDirPath/${image.id}.${image.fileExt}';
      await dio.download(image.fileUrl, filePath);

      image.downloadStatus = ImageDownloadStatus.success;
      image.downloadPath = filePath;
      await ImageDao.updateDownloadImageStatus(image);
    }catch(e) {

      image.downloadStatus = ImageDownloadStatus.error;
      await ImageDao.updateDownloadImageStatus(image);
    }
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