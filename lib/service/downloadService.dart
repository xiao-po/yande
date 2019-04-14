import 'dart:async';
import 'package:yande/appliction.dart';
import 'package:yande/dao/image_dao.dart';
import 'package:yande/dao/init_dao.dart';
import 'package:yande/model/image_model.dart';
import 'settingService.dart';
import 'package:yande/utils/utils.dart';
import 'package:dio/dio.dart';


class DownloadService {
  static Future<void> downloadImage (ImageModel image, {ProgressCallback onProcess}) async {
    Dio dio = Dio();
    AppDaoDataSource source = Application.getInstance().dataPool.getSource(DaoDataSource.name);

    image.downloadStatus = ImageDownloadStatus.pending;
    await source.updateDownloadImageStatus(image);

    try {
      String filePath = await _getDownloadPath(image);
      await _doDownload(dio, image, filePath, onProcess);

      image.downloadStatus = ImageDownloadStatus.success;
      image.downloadPath = filePath;
      await source.updateDownloadImageStatus(image);


      ScanImagePlugins.broadcast(filePath);
    }catch(e) {

      image.downloadStatus = ImageDownloadStatus.error;
      await source.updateDownloadImageStatus(image);
    }
  }

  static Future _doDownload(Dio dio, ImageModel image, String filePath, ProgressCallback onProcess) async {
         await dio.download(
        image.fileUrl,
        filePath,
        onReceiveProgress: onProcess,
    );
  }

  static Future<String> _getDownloadPath(ImageModel image) async {
     String yandeImageDirPath =
        (await SettingService.getSetting(SETTING_TYPE.IMAGE_DOWNLOAD_PATH)).value ;
    String filePath = '$yandeImageDirPath/${image.id}.${image.fileExt}';
    return filePath;
  }


}