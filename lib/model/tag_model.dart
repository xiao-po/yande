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

  TagModel(this.id,this.name,this.count,this.type,this.ambiguous,);

  factory TagModel.fromJson(Map<String, dynamic> srcJson) => _$TagModelFromJson(srcJson);

  Map<String, dynamic> toJson() => _$TagModelToJson(this);

}


