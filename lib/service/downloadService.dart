import 'dart:async';
import 'package:yande/dao/image_dao.dart';
import 'package:yande/model/image_model.dart';
import 'settingService.dart';
import 'package:yande/utils/utils.dart';
import 'package:dio/dio.dart';


class DownloadService {
  static Future<void> downloadImage (ImageModel image, {ProgressCallback onProcess}) async {
    Dio dio = Dio();

    image.downloadStatus = ImageDownloadStatus.pending;
    await ImageDao.updateDownloadImageStatus(image);

    try {
      String yandeImageDirPath =
          (await SettingService.getSetting(SETTING_TYPE.IMAGE_DOWNLOAD_PATH)).value ;
      String filePath = '$yandeImageDirPath/${image.id}.${image.fileExt}';
      dio.interceptors.add(Interceptor(

      ));
      await dio.download(
          image.fileUrl,
          filePath,
          onReceiveProgress: onProcess,
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


}