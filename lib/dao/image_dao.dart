import 'package:sqflite/sqflite.dart';
import 'init_dao.dart';
import 'package:yande/model/all_model.dart';

class ImageDao {
  static Future<bool> isImageExistById(int id) async {
    Database database =await MyDateBase.getDataBase();
    try {
      List list = await database.rawQuery(
          _ImageDaoUtils.generateSearchImageCollectByNameRawSql(id)
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
      await database.close();
    }
  }

  static Future<bool> collectImage(ImageModel image) async {
    Database database =await MyDateBase.getDataBase();
    try {
      String rawSql = _ImageDaoUtils.generateCollectImageInsertRawSql(image);
      print(rawSql);
      await database.rawInsert(
          rawSql
      );
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
          _ImageDaoUtils.generateDeleteImageCollectByNameRawSql(id)
      );
      return true;
    } catch(e) {
      print(e);
      return false;
    } finally {
      await database.close();
    }
  }
}


class _ImageDaoUtils {
  static String generateSearchImageCollectByNameRawSql(int id){
    return "select * from ${MyDateBaseValue.ImageCollect} where id = $id";
  }

  static String generateCollectImageInsertRawSql(ImageModel image) {
    return "insert into ${MyDateBaseValue.ImageCollect}"
        "(id, tags, author, "
        "fileUrl, source, fileSize,"
        "fileExt, previewUrl,"
        "previewWidth, previewHeight, rating"
        "sampleUrl,jpegUrl, "
        "jpegHeight, jpegWidth, jpegFileSize) "
        "values"
        " (${image.id},'${image.tags}','${image.author}',"
        "'${image.fileUrl}','${image.source}',${image.fileSize},"
        "'${image.fileExt}','${image.previewUrl}',"
        "'${image.previewWidth}',${image.previewHeight},${image.rating},"
        "'${image.sampleUrl}','${image.jpegUrl}',"
        "${image.jpegHeight},${image.jpegWidth},${image.jpegFileSize})";
  }
  static String generateDeleteImageCollectByNameRawSql(int id){
    return "delete from ${MyDateBaseValue.ImageCollect} where id = $id";
  }

}