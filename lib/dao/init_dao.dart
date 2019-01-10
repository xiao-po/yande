import 'package:sqflite/sqflite.dart';

class MyDateBase {
  static void initDateBase() async{
    Database database = await MyDateBase.getDataBase();
    await database.close();
  }

  static Future<Database> getDataBase() async{
    String databasesPath =await getDatabasesPath();
    String path = databasesPath + '/yande.db';
    print(path);
    return await openDatabase(path, version: 1,
      onCreate: (Database db, int version) async {
        print('oncreate');
        await db.execute(
            'CREATE TABLE tag (name TEXT, type TEXT)');
      });
  }
}