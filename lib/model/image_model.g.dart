// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'image_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ImageModel _$ImageModelFromJson(Map<String, dynamic> json) {
  return ImageModel(
      json['id'] as int,
      json['tags'] as String,
      json['created_at'] as int,
      json['updated_at'] as int,
      json['creator_id'] as int,
      json['author'] as String,
      json['change'] as int,
      json['source'] as String,
      json['score'] as int,
      json['md5'] as String,
      json['file_size'] as int,
      json['file_ext'] as String,
      json['file_url'] as String,
      json['is_shown_in_index'] as bool,
      json['preview_url'] as String,
      json['preview_width'] as int,
      json['preview_height'] as int,
      json['actual_preview_width'] as int,
      json['actual_preview_height'] as int,
      json['sample_url'] as String,
      json['sample_width'] as int,
      json['sample_height'] as int,
      json['sample_file_size'] as int,
      json['jpeg_url'] as String,
      json['jpeg_width'] as int,
      json['jpeg_height'] as int,
      json['jpeg_file_size'] as int,
      json['rating'] as String,
      json['is_rating_locked'] as bool,
      json['has_children'] as bool,
      json['status'] as String,
      json['is_pending'] as bool,
      json['width'] as int,
      json['height'] as int,
      json['is_held'] as bool,
      json['frames_pending_string'] as String,
      json['frames_pending'] as List,
      json['frames_string'] as String,
      json['frames'] as List,
      json['is_note_locked'] as bool,
      json['last_noted_at'] as int,
      json['last_commented_at'] as int)
    ..tagTagModelList = (json['tagTagModelList'] as List)
        ?.map((e) =>
            e == null ? null : TagModel.fromJson(e as Map<String, dynamic>))
        ?.toList()
    ..pages = json['pages'] as int
    ..collectStatus = _$enumDecodeNullable(
        _$ImageCollectStatusEnumMap, json['collect_status'])
    ..downloadStatus = _$enumDecodeNullable(
        _$ImageDownloadStatusEnumMap, json['download_status'])
    ..downloadPath = json['download_path'] as String;
}

Map<String, dynamic> _$ImageModelToJson(ImageModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'tags': instance.tags,
      'tagTagModelList': instance.tagTagModelList,
      'pages': instance.pages,
      'collect_status': _$ImageCollectStatusEnumMap[instance.collectStatus],
      'download_status': _$ImageDownloadStatusEnumMap[instance.downloadStatus],
      'download_path': instance.downloadPath,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
      'creator_id': instance.creatorId,
      'author': instance.author,
      'change': instance.change,
      'source': instance.source,
      'score': instance.score,
      'md5': instance.md5,
      'file_size': instance.fileSize,
      'file_ext': instance.fileExt,
      'file_url': instance.fileUrl,
      'is_shown_in_index': instance.isShownInIndex,
      'preview_url': instance.previewUrl,
      'preview_width': instance.previewWidth,
      'preview_height': instance.previewHeight,
      'actual_preview_width': instance.actualPreviewWidth,
      'actual_preview_height': instance.actualPreviewHeight,
      'sample_url': instance.sampleUrl,
      'sample_width': instance.sampleWidth,
      'sample_height': instance.sampleHeight,
      'sample_file_size': instance.sampleFileSize,
      'jpeg_url': instance.jpegUrl,
      'jpeg_width': instance.jpegWidth,
      'jpeg_height': instance.jpegHeight,
      'jpeg_file_size': instance.jpegFileSize,
      'rating': instance.rating,
      'is_rating_locked': instance.isRatingLocked,
      'has_children': instance.hasChildren,
      'status': instance.status,
      'is_pending': instance.isPending,
      'width': instance.width,
      'height': instance.height,
      'is_held': instance.isHeld,
      'frames_pending_string': instance.framesPendingString,
      'frames_pending': instance.framesPending,
      'frames_string': instance.framesString,
      'frames': instance.frames,
      'is_note_locked': instance.isNoteLocked,
      'last_noted_at': instance.lastNotedAt,
      'last_commented_at': instance.lastCommentedAt
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

const _$ImageCollectStatusEnumMap = <ImageCollectStatus, dynamic>{
  ImageCollectStatus.star: 'star',
  ImageCollectStatus.unStar: 'unStar'
};

const _$ImageDownloadStatusEnumMap = <ImageDownloadStatus, dynamic>{
  ImageDownloadStatus.none: 'none',
  ImageDownloadStatus.pending: 'pending',
  ImageDownloadStatus.success: 'success',
  ImageDownloadStatus.error: 'error'
};
