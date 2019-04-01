import 'package:json_annotation/json_annotation.dart';
import 'tag_model.dart';

part 'image_model.g.dart';


@JsonSerializable()
class ImageModel extends Object {

  @JsonKey(name: 'id')
  int id;

  @JsonKey(name: 'tags')
  String tags;

  List<TagModel> tagTagModelList;

  int pages; // 用于确定来自第几个页面的，防止数据重复造成 hero key 冲突的问题。

  @JsonKey(name: 'collect_status')
  ImageCollectStatus collectStatus = ImageCollectStatus.star;

  @JsonKey(name: 'download_status')
  ImageDownloadStatus downloadStatus  = ImageDownloadStatus.none;

  @JsonKey(name: 'download_path')
  String downloadPath = "";

  @JsonKey(name: 'created_at')
  int createdAt;

  @JsonKey(name: 'updated_at')
  int updatedAt;

  @JsonKey(name: 'creator_id')
  int creatorId;

  @JsonKey(name: 'author')
  String author;

  @JsonKey(name: 'change')
  int change;

  @JsonKey(name: 'source')
  String source;

  @JsonKey(name: 'score')
  int score;

  @JsonKey(name: 'md5')
  String md5;

  @JsonKey(name: 'file_size')
  int fileSize;

  @JsonKey(name: 'file_ext')
  String fileExt;

  @JsonKey(name: 'file_url')
  String fileUrl;

  @JsonKey(name: 'is_shown_in_index')
  bool isShownInIndex;

  @JsonKey(name: 'preview_url')
  String previewUrl;

  @JsonKey(name: 'preview_width')
  int previewWidth;

  @JsonKey(name: 'preview_height')
  int previewHeight;

  @JsonKey(name: 'actual_preview_width')
  int actualPreviewWidth;

  @JsonKey(name: 'actual_preview_height')
  int actualPreviewHeight;

  @JsonKey(name: 'sample_url')
  String sampleUrl;

  @JsonKey(name: 'sample_width')
  int sampleWidth;

  @JsonKey(name: 'sample_height')
  int sampleHeight;

  @JsonKey(name: 'sample_file_size')
  int sampleFileSize;

  @JsonKey(name: 'jpeg_url')
  String jpegUrl;

  @JsonKey(name: 'jpeg_width')
  int jpegWidth;

  @JsonKey(name: 'jpeg_height')
  int jpegHeight;

  @JsonKey(name: 'jpeg_file_size')
  int jpegFileSize;

  @JsonKey(name: 'rating')
  String rating;

  @JsonKey(name: 'is_rating_locked')
  bool isRatingLocked;

  @JsonKey(name: 'has_children')
  bool hasChildren;

  @JsonKey(name: 'status')
  String status;

  @JsonKey(name: 'is_pending')
  bool isPending;

  @JsonKey(name: 'width')
  int width;

  @JsonKey(name: 'height')
  int height;

  @JsonKey(name: 'is_held')
  bool isHeld;

  @JsonKey(name: 'frames_pending_string')
  String framesPendingString;

  @JsonKey(name: 'frames_pending')
  List<dynamic> framesPending;

  @JsonKey(name: 'frames_string')
  String framesString;

  @JsonKey(name: 'frames')
  List<dynamic> frames;

  @JsonKey(name: 'is_note_locked')
  bool isNoteLocked;

  @JsonKey(name: 'last_noted_at')
  int lastNotedAt;

  @JsonKey(name: 'last_commented_at')
  int lastCommentedAt;

  ImageModel(this.id,this.tags,this.createdAt,this.updatedAt,this.creatorId,this.author,this.change,this.source,this.score,this.md5,this.fileSize,this.fileExt,this.fileUrl,this.isShownInIndex,this.previewUrl,this.previewWidth,this.previewHeight,this.actualPreviewWidth,this.actualPreviewHeight,this.sampleUrl,this.sampleWidth,this.sampleHeight,this.sampleFileSize,this.jpegUrl,this.jpegWidth,this.jpegHeight,this.jpegFileSize,this.rating,this.isRatingLocked,this.hasChildren,this.status,this.isPending,this.width,this.height,this.isHeld,this.framesPendingString,this.framesPending,this.framesString,this.frames,this.isNoteLocked,this.lastNotedAt,this.lastCommentedAt,);

  factory ImageModel.fromJson(Map<String, dynamic> srcJson) => _$ImageModelFromJson(srcJson);

  Map<String, dynamic> toJson() => _$ImageModelToJson(this);

  bool isCollect() {
    if (this.collectStatus == ImageCollectStatus.star) {
      return true;
    } else {
      return false;
    }
  }

  bool isDownload() {
    if (this.downloadStatus == ImageDownloadStatus.success
        && this.downloadPath != "" && this.downloadPath != null) {
      return true;
    } else {
      return false;
    }
  }


}



enum ImageDownloadStatus {
  none,
  pending,
  success,
  error,
}

enum ImageCollectStatus {
  star,
  unStar
}