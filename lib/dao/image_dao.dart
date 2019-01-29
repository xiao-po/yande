import 'package:sqflite/sqflite.dart';
import 'init_dao.dart';
import 'package:yande/model/all_model.dart';

class ImageDao {
  static Future<ImageModel> isImageCollectExistById(int id, [Database database]) async {
    bool isHasDatabase = true;
    if (database == null) {
      isHasDatabase = false;
      database =await MyDateBase.getDataBase();
    }
    try {
      List list = await database.rawQuery(
          _ImageCollectDaoUtils.generateSearchCollectByIdRawSql(id)
      );
      if (list != null && list.length > 0) {
        return ImageModel.fromJson(Map.from(list[0]));
      } else {
        return null;
      }
    } catch(e) {
      print(e);
      return null;
    } finally {
      if (!isHasDatabase) {
        await database.close();
      }
    }
  }


  static Future<bool> isImageDetailExistById(int id, [Database database]) async {
    bool isHasDatabase = true;
    if (database == null) {
      isHasDatabase = false;
      database =await MyDateBase.getDataBase();
    }
    try {
      String rawSql = _ImageDaoUtils.generateSearchImageByIdRawSql(id);
      List list = await database.rawQuery(
          rawSql
      );
      if (list != null && list.length > 0) {
        return true;
      } else {
        return false;
      }
    } catch(e) {
      print(e);
      return false;
    } finally {
      if (!isHasDatabase) {
        await database.close();
      }
    }
  }

  static Future<bool> collectImage(ImageModel image) async {
    Database database =await MyDateBase.getDataBase();
    try {
      String insertImageSql = _ImageDaoUtils.generateImageInsertRawSql(image);
      bool isImageDetailExist =
        await ImageDao.isImageDetailExistById(image.id, database);

      if (!isImageDetailExist) {
        await database.rawInsert(insertImageSql);
      } else {
        await ImageDao.updateCollectStatus(image, database);
      }
      return true;
    } catch(e) {
      print(e);
      return false;
    } finally {
      await database.close();
    }
  }

  static Future<bool> updateDownloadImagePath(
      ImageModel image,
      [Database database]
      ) async {
    bool isHasDatabase = true;
    if (database == null) {
      isHasDatabase = false;
      database =await MyDateBase.getDataBase();
    }
    try {
      String rawSql = _ImageDownloadDaoUtils
          .generateImageDownloadPathUpdateRawSql(image);
      await database.rawUpdate(
          rawSql
      );
      return true;
    } catch(e) {
      print(e);
      return false;
    } finally {
      if (!isHasDatabase) {
        await database.close();
      }
    }
  }

  static Future<bool> updateDownloadImageStatus(ImageModel image) async {
    Database database =await MyDateBase.getDataBase();
    try {
      String insertImageSql = _ImageDaoUtils.generateImageInsertRawSql(image);
      String collectImageSql =
      _ImageDownloadDaoUtils.generateImageDownloadStatusUpdateRawSql(image);
      bool isImageDetailExist =
      await ImageDao.isImageDetailExistById(image.id, database);
      if (!isImageDetailExist) {
        await database.rawInsert(insertImageSql);
      } else {
        await database.rawUpdate(collectImageSql);
      }

      if (image.downloadStatus == ImageDownloadStatus.success) {
        await ImageDao.updateDownloadImagePath(image, database);
      }

      return true;
    } catch(e) {
      print(e);
      return false;
    } finally {
      await database.close();
    }
  }



  static Future<List> getAllCollectedImage() async {

    Database database =await MyDateBase.getDataBase();
    try {
      List list =await database.rawQuery(
        _ImageCollectDaoUtils.generateGetAllCollectedImageRawSql()
      );

      return list;
    } catch(e) {
      print(e);
      return null;
    } finally {
      await database.close();
    }
  }

  static Future<void> updateCollectStatus(ImageModel image,  [Database database]) async {
    bool isHasDatabase = true;
    if (database == null) {
      isHasDatabase = false;
      database =await MyDateBase.getDataBase();
    }
    try {
      await database.rawUpdate(
          _ImageCollectDaoUtils.generateImageCollectUpdateRawSql(image)
      );
    } catch(e) {
      print(e);
    } finally {
      if (!isHasDatabase) {
        await database.close();
      }
    }
  }
}

class _ImageDownloadDaoUtils {
  static String generateImageDownloadPathUpdateRawSql(ImageModel image) {
    return "UPDATE ${MyDateBaseValue.Image} SET"
        "${ImageTableColumn.downloadPath} = '${image.downloadPath}' "
        "where "
        "id = ${image.id}";
  }

  static String generateImageDownloadStatusUpdateRawSql(ImageModel image) {
    return "UPDATE ${MyDateBaseValue.Image} SET"
        "${ImageTableColumn.downloadStatus} = ${image.downloadStatus?.index} "
        "where "
        "id = ${image.id}";
  }
}


class _ImageDaoUtils {
  static String generateSearchImageByIdRawSql(int id){
    return "select * from ${MyDateBaseValue.Image} where id = $id";
  }

  static String generateImageInsertRawSql(ImageModel image) {
    return "insert into ${MyDateBaseValue.Image}"
        "(id, tags, author, "
        "file_url, source, file_size,"
        "file_ext, preview_url,"
        "preview_width, preview_height, rating,"
        "sample_url,jpeg_url, "
        "jpeg_height, jpeg_width, jpeg_file_size, "
        "download_status, download_path, collect_status ) "
        "values"
        " (${image.id},'${image.tags}','${image.author}',"
        "'${image.fileUrl}','${image.source}',${image.fileSize},"
        "'${image.fileExt}','${image.previewUrl}',"
        "'${image.previewWidth}',${image.previewHeight},'${image.rating}',"
        "'${image.sampleUrl}','${image.jpegUrl}',"
        "${image.jpegHeight},${image.jpegWidth},${image.jpegFileSize},"
        "${image.downloadStatus?.index},${image.downloadPath},${image.collectStatus?.index})";
  }
  static String generateDeleteImageByIdRawSql(int id){
    return "delete from ${MyDateBaseValue.Image} where id = $id";
  }

}

class _ImageCollectDaoUtils {
  static String generateGetAllCollectedImageRawSql(){
    return "select * from ${MyDateBaseValue.Image} where "
        "collect_status = ${ImageCollectStatus.star?.index} ";
  }

  static String generateImageCollectUpdateRawSql(ImageModel image) {
    return "UPDATE ${MyDateBaseValue.Image} SET "
        "${ImageTableColumn.collectStatus} = ${image.collectStatus?.index} "
        "where "
        "id = ${image.id}";

  }

  static String generateSearchCollectByIdRawSql(int id) {
    return "select * from ${MyDateBaseValue.Image} where "
        "collect_status = ${ImageCollectStatus.star?.index} & id = $id";
  }

}

