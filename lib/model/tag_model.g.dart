// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tag_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TagModel _$TagModelFromJson(Map<String, dynamic> json) {
  return TagModel(json['id'] as int, json['name'] as String,
      json['count'] as int, json['type'] as int, json['ambiguous'] as bool)
    ..collectStatus =
        _$enumDecodeNullable(_$TagCollectStatusEnumMap, json['collect_status']);
}

Map<String, dynamic> _$TagModelToJson(TagModel instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'count': instance.count,
      'type': instance.type,
      'ambiguous': instance.ambiguous,
      'collect_status': _$TagCollectStatusEnumMap[instance.collectStatus]
    };

T _$enumDecode<T>(Map<T, dynamic> enumValues, dynamic source) {
  if (source == null) {
    throw ArgumentError('A value must be provided. Supported values: '
        '${enumValues.values.join(', ')}');
  }
  return enumValues.entries
      .singleWhere((e) => e.value == source,
          orElse: () => throw ArgumentError(
              '`$source` is not one of the supported values: '
              '${enumValues.values.join(', ')}'))
      .key;
}

T _$enumDecodeNullable<T>(Map<T, dynamic> enumValues, dynamic source) {
  if (source == null) {
    return null;
  }
  return _$enumDecode<T>(enumValues, source);
}

const _$TagCollectStatusEnumMap = <TagCollectStatus, dynamic>{
  TagCollectStatus.none: 0,
  TagCollectStatus.collected: 1
};
