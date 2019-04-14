import 'package:sqflite/sqflite.dart';
import 'package:yande/model/image_model.dart';
import 'init_dao.dart';
import 'dart:async';

class ImageDao {
  DaoDataSource source;
  ImageDao(this.source);
  Future<ImageModel> isImageCollectExistById(int id, [Database database]) async {
    bool isHasDatabase = true;
    if (database == null) {
      isHasDatabase = false;
      database =await this.source.getDatabase();
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

  Future<ImageModel> getImageById(String id, [Database database]) async {
    bool isHasDatabase = true;
    if (database == null) {
      isHasDatabase = false;
      database =await this.source.getDatabase();
    }
    try {
      List list = await database.query(
          MyDateBaseValue.Image,
          where: 'id = ?',
          whereArgs: [id]
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
  Future<bool> isImageExistById(int id, [Database database]) async {
    bool isHasDatabase = true;
    if (database == null) {
      isHasDatabase = false;
      database =await this.source.getDatabase();
    }
    try {
      List list = await database.rawQuery(
          _ImageCollectDaoUtils.generateSearchImageByIdRawSql(id)
      );
      if (list != null && list.length > 0) {
        return true;
      } else {
        return false;
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


  Future<bool> isImageDetailExistById(int id, [Database database]) async {
    bool isHasDatabase = true;
    if (database == null) {
      isHasDatabase = false;
      database =await this.source.getDatabase();
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

  Future<bool> collectImage(ImageModel image) async {
    Database database =await this.source.getDatabase();
    try {
      String insertImageSql = _ImageDaoUtils.generateImageInsertRawSql(image);
      bool isImageDetailExist =
        await this.isImageDetailExistById(image.id, database);

      if (!isImageDetailExist) {
        await database.rawInsert(insertImageSql);
      } else {
        await this.updateCollectStatus(image, database);
      }
      return true;
    } catch(e) {
      print(e);
      return false;
    } finally {
      await database.close();
    }
  }

  Future<bool> updateDownloadImagePath(
      ImageModel image,
      [Database database]
      ) async {
    bool isHasDatabase = true;
    if (database == null) {
      isHasDatabase = false;
      database =await this.source.getDatabase();
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

  Future<bool> updateDownloadImageStatus(ImageModel image) async {
    Database database =await this.source.getDatabase();
    try {
      String insertImageSql = _ImageDaoUtils.generateImageInsertRawSql(image);
      String collectImageSql =
      _ImageDownloadDaoUtils.generateImageDownloadStatusUpdateRawSql(image);
      bool isImageDetailExist =
      await this.isImageDetailExistById(image.id, database);
      if (!isImageDetailExist) {
        await database.rawInsert(insertImageSql);
      } else {
        await database.rawUpdate(collectImageSql);
      }

      if (image.downloadStatus == ImageDownloadStatus.success) {
        await this.updateDownloadImagePath(image, database);
      }

      return true;
    } catch(e) {
      print(e);
      return false;
    } finally {
      await database.close();
    }
  }

  Future<List<ImageModel>> getAllCollectedImage(int page, int limit) async {

    Database database =await this.source.getDatabase();
    try {
      List list =await database.query(
        MyDateBaseValue.Image,
        where: 'collect_status = ${ImageCollectStatus.star?.index}',
        offset: page * limit,
        limit: limit,

      );

      List<ImageModel> imageList = List();
      for (Map item in list) {
        Map map = Map<String, dynamic>.from(item);
        imageList.add(ImageModel.fromJson(map));
      }
      return imageList;
    } catch(e) {
      print(e);
      return null;
    } finally {
      await database.close();
    }
  }

  Future<void> updateCollectStatus(ImageModel image,  [Database database]) async {
    bool isHasDatabase = true;
    if (database == null) {
      isHasDatabase = false;
      database =await this.source.getDatabase();
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
    return "UPDATE ${MyDateBaseValue.Image} SET "
        "${ImageTableColumn.downloadPath} = '${image.downloadPath}' "
        "where "
        "id = ${image.id}";
  }

  static String generateImageDownloadStatusUpdateRawSql(ImageModel image) {
    return "UPDATE ${MyDateBaseValue.Image} SET "
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
        "download_status, download_path, collect_status, width, height ) "
        "values"
        " (${image.id},'${image.tags}','${image.author}',"
        "'${image.fileUrl}','${image.source}',${image.fileSize},"
        "'${image.fileExt}','${image.previewUrl}',"
        "'${image.previewWidth}',${image.previewHeight},'${image.rating}',"
        "'${image.sampleUrl}','${image.jpegUrl}',"
        "${image.jpegHeight},${image.jpegWidth},${image.jpegFileSize},"
        "${image.downloadStatus?.index},${image.downloadPath},${image.collectStatus?.index},"
        "${image.width}, ${image.height})";
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
        "collect_status = ${ImageCollectStatus.star?.index} and id = $id";
  }

  static String generateSearchImageByIdRawSql(int id) {
    return "select * from ${MyDateBaseValue.Image} where "
        "id = $id";
  }

}

