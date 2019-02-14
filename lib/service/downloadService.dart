import 'dart:async';
import 'package:yande/model/all_model.dart';
import 'package:yande/dao/all_dao.dart';
import 'settingService.dart';
import 'dart:io';
import 'package:yande/utils/utils.dart';
import 'package:dio/dio.dart';


class DownloadService {
  static Future<void> downloadImage (ImageModel image, {OnDownloadProgress onProcess}) async {
    Dio dio = new Dio();

    image.downloadStatus = ImageDownloadStatus.pending;
    await ImageDao.updateDownloadImageStatus(image);

    try {
      String yandeImageDirPath =
          (await SettingService.getSetting(SETTING_TYPE.IMAGE_DOWNLOAD_PATH)).value ;
      String filePath = '$yandeImageDirPath/${image.id}.${image.fileExt}';
      await dio.download(
          image.fileUrl,
          filePath,
          onProgress: onProcess,
      );

      image.downloadStatus = ImageDownloadStatus.success;
      image.downloadPath = filePath;
      ScanImagePlugins.broadcast(filePath);
      await ImageDao.updateDownloadImageStatus(image);
    }catch(e) {

      image.downloadStatus = ImageDownloadStatus.error;
      await ImageDao.updateDownloadImageStatus(image);
    }
  }

  static Future<Directory> getImageDir() async {
  }

}