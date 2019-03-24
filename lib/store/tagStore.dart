import 'package:yande/model/all_model.dart';
import 'package:yande/service/allServices.dart';
import 'dart:async';

class TagStore {
  static List<TagModel> shortCutList;
  static List<TagModel> blockedTag;

  static Future<void> init() async {
    TagStore.shortCutList = [];
    TagStore.blockedTag = [];
    await TagStore._getShortcutList();
    await TagStore._getBlockTagList();

  }

  static Future<void> _getShortcutList() async{
    TagStore.shortCutList = await TagService.getAllCollectTag()??[];
  }

  static Future<void> _getBlockTagList() async {
    TagStore.blockedTag = await TagService.getAllBlockTag()??[];
  }

  static void collectTag(TagModel tag) async {
    tag.collectStatus = TagCollectStatus.collected;
    await TagService.setCollectStatus(tag);

    TagStore.removeTagFromBlockList(tag);

    TagStore.shortCutList.add(tag);
  }

  static void unCollectTag(TagModel tag) async {
    tag.collectStatus = TagCollectStatus.none;
    await TagService.setCollectStatus(tag);
    TagStore.removeTagFromShortCutList(tag);
  }


  static void block(TagModel tag) async {
    tag.collectStatus = TagCollectStatus.block;
    await TagService.setCollectStatus(tag);
    TagStore.blockedTag.add(tag);
  }

  static void unblock(TagModel tag) async {
    tag.collectStatus = TagCollectStatus.none;
    await TagService.setCollectStatus(tag);

    TagStore.removeTagFromShortCutList(tag);

    TagStore.blockedTag.removeWhere((item) => item.name == tag.name);
  }

  static void removeTagFromBlockList(TagModel tag) {
    TagStore.blockedTag.removeWhere((item) => item.name == tag.name);
  }

  static void removeTagFromShortCutList(TagModel tag) {
    TagStore.shortCutList.removeWhere((item) => item.name == tag.name);
  }

  static bool isBlockedByName(String name){
    for(TagModel tag in TagStore.blockedTag) {
      if (tag.name == name) {
        return true;
      }
    }
    return false;
  }

  static bool isBlocked(TagModel tagModel){
    for(TagModel tag in TagStore.blockedTag) {
      if (tag.name == tagModel.name) {
        return true;
      }
    }
    return false;
  }

  static bool isCollectByName(String name){
    for(TagModel tag in TagStore.shortCutList) {
      if (tag.name == name) {
        return true;
      }
    }
    return false;
  }

  static bool isCollect(TagModel tagModel){
    for(TagModel tag in TagStore.shortCutList) {
      if (tag.name == tagModel.name) {
        return true;
      }
    }
    return false;
  }


}