// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tag_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TagModel _$TagModelFromJson(Map<String, dynamic> json) {
  return TagModel(json['id'] as int, json['name'] as String,
      json['count'] as int, json['type'] as int, json['ambiguous'] as bool);
}

Map<String, dynamic> _$TagModelToJson(TagModel instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'count': instance.count,
      'type': instance.type,
      'ambiguous': instance.ambiguous
    };
