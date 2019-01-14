import 'package:sqflite/sqflite.dart';

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
            'CREATE TABLE ${MyDateBaseValue.TagCollect} (name TEXT, type TEXT)');
        await db.execute(
            'CREATE TABLE ${MyDateBaseValue.ImageCollect} ('
                'id INTEGER primary KEY,'
                'tags TEXT,'
                'author TEXT,'
                'fileUrl TEXT,'
                'source TEXT,'
                'fileSize TEXT,'
                'fileExt TEXT,'
                'previewUrl TEXT,'
                'previewWidth TEXT,'
                'previewHeight TEXT,'
                'rating TEXT,'
                'sampleUrl TEXT,'
                'jpegUrl TEXT,'
                'jpegWidth INTEGER,'
                'jpegHeight INTEGER,'
                'jpegFileSize INTEGER'
                ')');

      });
  }
}

class MyDateBaseValue {
  static final TagCollect = "tagCollect";
  static final ImageCollect = "imageCollect";

}