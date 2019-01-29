import 'dart:async';
import 'dart:convert';
import 'package:yande/model/all_model.dart';
import 'API/all_api.dart';
import 'package:yande/dao/all_dao.dart';
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

  static void _setTagListVersion(int version) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt(TagDataKey.version, version);
  }

  static List<TagModel> _tagStringConvertToTagModelList (String result){
    List<String> tagSpiltResult = (result).split(" ");
    List<TagModel> tagList = new List();
    for(String tagstr in tagSpiltResult) {
      if (tagstr == "") {
        continue;
      }
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

  static Future<void> errorTestHttpRequest() async{
    Dio dio = new Dio();
    String url = 'https://yande.re/post32131.json?limit=1';

    try {
      Response<List<dynamic>> res = await dio.get(url);
    }catch(e) {
      print(e);
    }



  }


}


class TagDataKey {
  static final String version = "version";
  static final String tagList = "data";

}
