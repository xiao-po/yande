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
            'CREATE TABLE ${MyDateBaseValue.Image} ('
                'id INTEGER primary KEY,'
                'tags TEXT,'
                'author TEXT,'
                'file_url TEXT,'
                'source TEXT,'
                'file_size TEXT,'
                'file_ext TEXT,'
                'preview_url TEXT,'
                'preview_width TEXT,'
                'preview_height TEXT,'
                'rating TEXT,'
                'sample_url TEXT,'
                'jpeg_url TEXT,'
                'jpeg_width INTEGER,'
                'jpeg_height INTEGER,'
                'jpeg_file_size INTEGER'
                ')');
        await db.execute(
            'CREATE TABLE ${MyDateBaseValue.ImageCollect} ('
                'id INTEGER primary KEY'
                ')'
        );
        await db.execute(
            'CREATE TABLE ${MyDateBaseValue.ImageDownload} ('
                'id INTEGER primary KEY,'
                'status INTEGER,'
                'path TEXT'
                ')'
        );

      });
  }
}

class MyDateBaseValue {
  static final TagCollect = "tagCollect";
  static final ImageCollect = "imageCollect";
  static final Image = "image";
  static final ImageDownload = "imageDownload";
}