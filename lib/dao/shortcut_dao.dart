import 'package:sqflite/sqflite.dart';
import 'init_dao.dart';
import 'package:yande/model/all_model.dart';
import 'dart:async';

class ShortcutDao {
  static Future<ShortcutModel> getAllShortcut([Database database]) async{
    bool isHasDatabase = true;
    if (database == null) {
      isHasDatabase = false;
      database =await MyDateBase.getDataBase();
    }
    try {
      List list = await database.query(
        MyDateBaseValue.Shortcut,
      );
      if (list != null && list.length > 0) {
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
}