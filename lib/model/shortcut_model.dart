import 'package:json_annotation/json_annotation.dart';

part 'shortcut_model.g.dart';

@JsonSerializable()
class ShortcutModel extends Object {
  String keyword;
  String nickname;

  ShortcutModel(this.keyword, this.nickname);
}