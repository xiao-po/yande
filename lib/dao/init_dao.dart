import 'package:sqflite/sqflite.dart';
import 'package:yande/utils/utils.dart';
import 'dart:async';

class MyDateBase {

  static void initDateBase() async{
    Database database = await MyDateBase.getDataBase();
    await database.close();
  }

  static Future<Database> getDataBase() async{
    String databasesPath =(await FileUtils.getExternalDatabaseDir()).path;
    String path = databasesPath + '/yande.db';
    return await openDatabase(path, version: 1,
      onCreate: (Database db, int version) async {
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
  static final TagCollect = "tagCollect";
  static final Image = "image";
}

class ImageTableColumn {
  static final id = "id";
  static final tags = "tags";
  static final author = "author";
  static final fileUrl = "file_url";
  static final source = "source";
  static final fileSize = "file_size";
  static final fileExt = "file_ext";
  static final previewUrl = "preview_url";
  static final previewWidth = "preview_width";
  static final previewHeight = "preview_height";
  static final rating = "rating";
  static final sampleUrl = "sample_url";
  static final jpegUrl = "jpeg_url";
  static final jpegWidth = "jpeg_width";
  static final jpegHeight = "jpeg_height";
  static final jpegFileSize = "jpeg_file_size";
  static final collectStatus = "collect_status";
  static final downloadStatus = "download_status";
  static final downloadPath = "download_path";

}