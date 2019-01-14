import 'package:sqflite/sqflite.dart';
import 'init_dao.dart';
import 'package:yande/model/all_model.dart';

class TagDao {


    static Future<bool> collectTag(TagModel tag) async {
      Database database = await MyDateBase.getDataBase();

      await database.execute(_TagDaoUtils.generateCollectTagInsertRawSql(tag));

      database.close();
      return true;
    }

}


class _TagDaoUtils {

  static String generateCollectTagInsertRawSql(TagModel tag) {
      return "insert into ${MyDateBaseValue.TagCollect}(name, type) values"
          " (${tag.name}, ${tag.type})";
  }

  static String generateCollectTagSearchByNameRawSql (String name) {
      return "select * from ${MyDateBaseValue.TagCollect} where name = $name";
  }

  static String generateCollectTagDeleteByNameRawSql (String name) {
      return "delete from ${MyDateBaseValue.TagCollect} where name = $name";
  }
}

