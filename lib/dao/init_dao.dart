import 'package:sqflite/sqflite.dart';
import 'dart:async';

class MyDateBase {

  static void initDateBase() async{
    Database database = await MyDateBase.getDataBase();
    await database.close();
  }

  static Future<Database> getDataBase() async{
    String databasesPath =await getDatabasesPath();
    String path = databasesPath + '/yande.db';
    return await openDatabase(path, version: 1,
      onCreate: (Database db, int version) async {
        await db.execute(
            'CREATE TABLE ${MyDateBaseValue.Tag} ('
                'id INTEGER,'
                'name TEXT,'
                'nick_name TEXT,'
                'count INTEGER,'
                'type INTERGER,'
                'ambiguous BOOL,'
                'collect_status INTERGER'
                ')'
        );
        await db.execute(
            'CREATE TABLE ${MyDateBaseValue.Image} ('
                'id INTEGER primary KEY,'
                'tags TEXT,'
                'author TEXT,'
                'file_url TEXT,'
                'source TEXT,'
                'file_size INTEGER,'
                'file_ext TEXT,'
                'preview_url TEXT,'
                'preview_width INTEGER,'
                'preview_height INTEGER,'
                'rating TEXT,'
                'width INTEGER,'
                'height INTEGER,'
                'sample_url TEXT,'
                'jpeg_url TEXT,'
                'jpeg_width INTEGER,'
                'jpeg_height INTEGER,'
                'jpeg_file_size INTEGER,'
                'collect_status INTEGER,'
                'download_status String,'
                'download_path INTEGER'
                ')');

      });
  }
}

class MyDateBaseValue {
  static const Tag = "tag";
  static const Image = "image";
}

class ImageTableColumn {
  static const id = "id";
  static const tags = "tags";
  static const author = "author";
  static const fileUrl = "file_url";
  static const source = "source";
  static const fileSize = "file_size";
  static const fileExt = "file_ext";
  static const previewUrl = "preview_url";
  static const previewWidth = "preview_width";
  static const previewHeight = "preview_height";
  static const rating = "rating";
  static const sampleUrl = "sample_url";
  static const jpegUrl = "jpeg_url";
  static const jpegWidth = "jpeg_width";
  static const jpegHeight = "jpeg_height";
  static const height = 'height';
  static const width = 'width';
  static const jpegFileSize = "jpeg_file_size";
  static const collectStatus = "collect_status";
  static const downloadStatus = "download_status";
  static const downloadPath = "download_path";

}

class TagTableColumn {
  static const id = 'id';
  static const name = 'name';
  static const nickName = 'nick_name';
  static const count = 'count';
  static const type = 'type';
  static const ambiguous = 'ambiguous';
  static const collectStatus = 'collect_status';
}