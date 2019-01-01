import 'dart:async';
import 'dart:convert';
import 'package:yande/model/all_model.dart';
import 'API/all_api.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TagService {



  static Future<List<TagModel>> getTagByNameOrderAESC(String name) async{
    Dio dio = new Dio();
    String url = IndexAPI.tagList + '?limit=40&order=count&name=$name';

    Response<List<dynamic>> res = await dio.get(url);

    List<TagModel> tagList = res.data.map((item) =>
        TagModel.fromJson(Map<String, dynamic>.from(item))).toList();

    return tagList;

  }

  static Future<bool> updateAllTag() async{
    Dio dio = new Dio();
    String url = IndexAPI.allTagList;

    Response<String> res = await dio.get(url);
    Map<String, dynamic> data = json.decode(res.data);

    TagService._setTagListVersion(data[TagDataKey.version] as int);

    List<TagModel> tagList =
      TagService._tagStringConvertToTagModelList(
          data[TagDataKey.tagList] as String
      );
    return false;
  }

  static void _setTagListVersion(int version) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt(TagDataKey.version, version);
  }

  static List<TagModel> _tagStringConvertToTagModelList (String result){
    List<String> tagSpiltResult = (result).split(" ");
    List<TagModel> tagList = new List();
    for(String tagstr in tagSpiltResult) {
      List<String> result = tagstr.split("`");
      List<TagModel> tempTagList = new List();
      for (int i = 0; i < result.length; i++ ) {
        int tagType = 0;
        if (i == 0) {
          tagType = int.parse(result[0]);
        } else {
          TagModel temp = new TagModel(-1, result[i], -1, tagType, false);
          tempTagList.add(temp);
        }
      }
      tagList.addAll(tempTagList);
    }
    return tagList;
  }
}


class TagDataKey {
  static final String version = "version";
  static final String tagList = "data";

}
