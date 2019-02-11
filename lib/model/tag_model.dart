import 'package:json_annotation/json_annotation.dart';

part 'tag_model.g.dart';


@JsonSerializable()
class TagModel extends Object {

  @JsonKey(name: 'id')
  int id;

  @JsonKey(name: 'name')
  String name;

  @JsonKey(name: 'count')
  int count;

  @JsonKey(name: 'type')
  int type;

  @JsonKey(name: 'ambiguous')
  bool ambiguous;

  @JsonKey(name: 'collect_status')
  TagCollectStatus collectStatus;

  TagModel(this.id,this.name,this.count,this.type,this.ambiguous,);

  factory TagModel.fromJson(Map<String, dynamic> srcJson) => _$TagModelFromJson(srcJson);

  Map<String, dynamic> toJson() => _$TagModelToJson(this);

  bool isCollect() {
    if (this.collectStatus == TagCollectStatus.collected) {
      return true;
    } else {
      return false;
    }
  }

}

enum TagCollectStatus {
  none,
  collected,
}

final List<String> TagType = ["普通","画师","会社","角色",null,];

