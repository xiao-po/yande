import 'package:sqflite/sqflite.dart';
import 'init_dao.dart';
import 'package:yande/model/all_model.dart';

class ImageDao {
  static Future<bool> isImageCollectExistById(int id, [Database database]) async {
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
      String collectImageSql =
        _ImageCollectDaoUtils.generateImageCollectInsertRawSql(image);
      bool isImageDetailExist =
        await ImageDao.isImageDetailExistById(image.id, database);
      await database.transaction((txn) async {

        if (!isImageDetailExist) {
          await txn.rawInsert(insertImageSql);
        }
        await txn.rawInsert(collectImageSql);
      });
      return true;
    } catch(e) {
      print(e);
      return false;
    } finally {
      await database.close();
    }
  }

  static Future<bool> deleteCollectById(int id) async{
    Database database =await MyDateBase.getDataBase();
    try {
      await database.rawDelete(
          _ImageCollectDaoUtils.generateDeleteImageCollectByIdRawSql(id)
      );
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
        "jpeg_height, jpeg_width, jpeg_file_size) "
        "values"
        " (${image.id},'${image.tags}','${image.author}',"
        "'${image.fileUrl}','${image.source}',${image.fileSize},"
        "'${image.fileExt}','${image.previewUrl}',"
        "'${image.previewWidth}',${image.previewHeight},'${image.rating}',"
        "'${image.sampleUrl}','${image.jpegUrl}',"
        "${image.jpegHeight},${image.jpegWidth},${image.jpegFileSize})";
  }
  static String generateDeleteImageByIdRawSql(int id){
    return "delete from ${MyDateBaseValue.Image} where id = $id";
  }

}

class _ImageCollectDaoUtils {
  static String generateSearchCollectByIdRawSql (int id) {
    return "select * from ${MyDateBaseValue.ImageCollect} "
        "where id = $id";
  }

  static String generateGetAllCollectedImageRawSql(){
    return "select * from ${MyDateBaseValue.ImageCollect} a "
        "inner join ${MyDateBaseValue.Image} b on a.id = b.id ";
  }

  static String generateImageCollectInsertRawSql(ImageModel image) {
    return "insert into ${MyDateBaseValue.ImageCollect}"
        "(id) "
        "values"
        " (${image.id})";
  }
  static String generateDeleteImageCollectByIdRawSql(int id){
    return "delete from ${MyDateBaseValue.ImageCollect} where id = $id";
  }

}

enum ImageDownloadStatus {
  pending,
  success,
  error,
}
