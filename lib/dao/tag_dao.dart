import 'package:sqflite/sqflite.dart';
import 'init_dao.dart';
import 'package:yande/model/all_model.dart';

class TagDao {
    static Future<bool> updateAllTagList(List<TagModel> tagList) async{
      Database database = await MyDateBase.getDataBase();
      database.close();
      return true;
    }







}


class _TagDaoUtils {
  static String generateTaginsertRawSql(TagModel tag) {
      return "insert into Tag (name, type ) VALUES( \"${tag.name}\", \"${TagType[tag.type]}\" )";
  }

  static String generateTagSelectRawSqlByName(TagModel tag) {
      return "select * from tag where name = \"" + tag.name.replaceAll('"', '\"') +  "\"";
  }
}
