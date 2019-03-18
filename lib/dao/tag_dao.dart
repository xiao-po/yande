import 'package:sqflite/sqflite.dart';
import 'init_dao.dart';
import 'dart:async';
import 'package:yande/model/all_model.dart';

class TagDao {
  static Future<bool> isTagExistByName(String name,  [Database database]) async {
    bool isHasDatabase = true;
    if (database == null) {
      isHasDatabase = false;
      database =await MyDateBase.getDataBase();
    }
    try {
      List list = await database.query(
          MyDateBaseValue.Tag,
          where: 'name = ?',
          whereArgs: [
            name
          ]
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

  static Future<bool> saveTag(TagModel tag) async {
    Database database =await MyDateBase.getDataBase();
    try {
      bool isTagExist =
        await TagDao.isTagExistByName(tag.name, database);

      if (!isTagExist) {
        await database.insert(
          MyDateBaseValue.Tag,
          tag.toJson(),
        );
      } else {
        await TagDao.updateCollectStatus(tag, database);
      }
      return true;
    } catch(e) {
      print(e);
      return false;
    } finally {
      await database.close();
    }
  }
  static Future<bool> updateCollectStatus(TagModel tag,  [Database database]) async {
    bool isHasDatabase = true;
    if (database == null) {
      isHasDatabase = false;
      database =await MyDateBase.getDataBase();
    }
    try {
      await database.update(
          MyDateBaseValue.Tag,
          tag.toJson(),
          where: 'name = ?',
          whereArgs: [
            tag.name
          ]
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

  static Future<List<TagModel>> getAllCollectTag() async{
    Database database =await MyDateBase.getDataBase();
    try {
      List list = await database.query(
          MyDateBaseValue.Tag
      );
      if (list != null && list.length > 0) {
        return list.map((val) => TagModel.fromJson(Map.from(val)));
      } else {
        return null;
      }
    } catch(e) {
      print(e);
      return null;
    } finally {
      await database.close();
    }
  }

  static Future<List<TagModel>> getAllBlockTag() async {
    Database database =await MyDateBase.getDataBase();
    try {
      List list = await database.query(
          MyDateBaseValue.Tag,
          where: '${TagTableColumn.collectStatus} = ?',
          whereArgs: [TagCollectStatus.block]
      );
      if (list != null && list.length > 0) {
        return list.map((val) => TagModel.fromJson(Map.from(val)));
      } else {
        return null;
      }
    } catch(e) {
      print(e);
      return null;
    } finally {
      await database.close();
    }
  }
}