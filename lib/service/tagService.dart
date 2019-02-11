import 'dart:async';
import 'package:yande/model/all_model.dart';
import 'API/all_api.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';


class TagService {


  static Future<List<TagModel>> getTagByNameOrderAESC(String name) async{
    Dio dio = new Dio();
    String url = IndexAPI.tagList + '?limit=40&order=count&name=$name';

    Response<List<dynamic>> res = await dio.get(url);

    List<TagModel> tagList = res.data.map((item) =>
        TagModel.fromJson(Map<String, dynamic>.from(item))).toList();

    return tagList;

  }

  static Future<bool> isTagBlockByName(String word) async {
    List<String> shortcutList =await TagService._getBlockList();
    if (shortcutList != null) {
      int index = shortcutList.indexOf(word);
      if (index > -1 ) {
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }

  static void addShortCutWord(String word) async {
    List<String> shortcutList =await TagService._getBlockList();
    if (shortcutList == null) {
      shortcutList = new List();
    }
    shortcutList.add(word);
    TagService._setBlockList(shortcutList);
  }

  static void deleteShortCutWord(String word) async {
    List<String> shortcutList =await TagService._getBlockList();
    int index = shortcutList.indexOf(word);
    shortcutList.removeAt(index);
    TagService._setBlockList(shortcutList);
  }

  static void _setBlockList(List<String> blockList) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(BLOCK_TAG, blockList);
  }

  static Future<List<String>> _getBlockList() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(BLOCK_TAG);
  }


}

final BLOCK_TAG = 'blockTag';