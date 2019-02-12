import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

final String SEARCH_SHORTCUT = 'search_shortcut';

class ShortCutService {



  static Future<bool> isShortcutExist(String word) async {
    List<String> shortcutList =await ShortCutService.getShortCutList();
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
    List<String> shortcutList =await ShortCutService.getShortCutList();
    if (shortcutList == null) {
      shortcutList = new List();
    }
    shortcutList.add(word);
    ShortCutService._setShortCutList(shortcutList);
  }

  static void deleteShortCutWord(String word) async {
    List<String> shortcutList =await ShortCutService.getShortCutList();
    int index = shortcutList.indexOf(word);
    shortcutList.removeAt(index);
    ShortCutService._setShortCutList(shortcutList);
  }

  static void _setShortCutList(List<String> shortcutList) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(SEARCH_SHORTCUT, shortcutList);
  }

  static Future<List<String>> getShortCutList() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(SEARCH_SHORTCUT);
  }

}