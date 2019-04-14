import 'package:sqflite/sqflite.dart';
import 'dart:async';

import 'package:yande/appliction.dart';
import 'package:yande/dao/image_dao.dart';
import 'package:yande/dao/tag_dao.dart';
import 'package:yande/model/image_model.dart';
import 'package:yande/model/tag_model.dart';

class MyDateBaseValue {
  static const Tag = "tag";
  static const Image = "image";
}

class ImageTableColumn {
  static const id = "id";
  static const tags = "tags";
  static const author = "author";
  static const fileUrl = "file_url";
  static const source = "source";
  static const fileSize = "file_size";
  static const fileExt = "file_ext";
  static const previewUrl = "preview_url";
  static const previewWidth = "preview_width";
  static const previewHeight = "preview_height";
  static const rating = "rating";
  static const sampleUrl = "sample_url";
  static const jpegUrl = "jpeg_url";
  static const jpegWidth = "jpeg_width";
  static const jpegHeight = "jpeg_height";
  static const height = 'height';
  static const width = 'width';
  static const jpegFileSize = "jpeg_file_size";
  static const collectStatus = "collect_status";
  static const downloadStatus = "download_status";
  static const downloadPath = "download_path";

}

class TagTableColumn {
  static const id = 'id';
  static const name = 'name';
  static const nickName = 'nick_name';
  static const count = 'count';
  static const type = 'type';
  static const ambiguous = 'ambiguous';
  static const collectStatus = 'collect_status';
}

class DaoDataSource implements AppDaoDataSource{
  static get name => "dao";

  @override
  get sourceName => DaoDataSource.name;

  ImageDao _imageDao;
  TagDao _tagDao;

  DaoDataSource() {
    this._imageDao = ImageDao(this);
    this._tagDao = TagDao(this);
  }

  @override
  Future<Database> getDatabase() async {
    String databasesPath =await getDatabasesPath();
    String path = databasesPath + '/yande.db';
    return await openDatabase(path, version: 2, onCreate: onCreate);
  }

  FutureOr<void> onCreate(Database db, int version) async {
    await db.execute(
        'CREATE TABLE ${MyDateBaseValue.Tag} ('
            'id INTEGER,'
            'name TEXT,'
            'nick_name TEXT,'
            'count INTEGER,'
            'type INTERGER,'
            'ambiguous BOOL,'
            'dataSourceName String,'
            'collect_status INTERGER'
            ')'
    );
    await db.execute(
        'CREATE TABLE ${MyDateBaseValue.Image} ('
            'id INTEGER primary KEY,'
            'tags TEXT,'
            'author TEXT,'
            'file_url TEXT,'
            'source TEXT,'
            'file_size INTEGER,'
            'file_ext TEXT,'
            'preview_url TEXT,'
            'preview_width INTEGER,'
            'preview_height INTEGER,'
            'rating TEXT,'
            'width INTEGER,'
            'height INTEGER,'
            'sample_url TEXT,'
            'jpeg_url TEXT,'
            'jpeg_width INTEGER,'
            'jpeg_height INTEGER,'
            'jpeg_file_size INTEGER,'
            'dataSourceName String,'
            'collect_status INTEGER,'
            'download_status String,'
            'download_path INTEGER'
            ')');

  }



  @override
  Future<ImageModel> fetchImageById(int id) {
    return _imageDao.getImageById('$id');
  }

  @override
  Future<List<ImageModel>> fetchImageByPage(int page, int limit) {
    return _imageDao.getAllCollectedImage(page, limit);
  }

  @override
  Future<List<ImageModel>> fetchImageByTag(String tag, int page, int limit) {
    throw "数据库暂时不支持搜索 tag";
  }

  @override
  Future<bool> isImageExistById(int id) {
    return _imageDao.isImageExistById(id);
  }

  @override
  Future<void> updateDownloadImageStatus(ImageModel image) {
    return _imageDao.updateDownloadImageStatus(image);
  }

  @override
  Future<void> collectImage(ImageModel image) {
    return _imageDao.collectImage(image);
  }

  @override
  Future<List<TagModel>> getAllBlockTag() {
    // TODO: implement getAllBlockTag
    return null;
  }

  @override
  Future<List<TagModel>> getAllCollectTag() {
    return _tagDao.getAllCollectTag();
  }

  @override
  Future<List<ImageModel>> getAllCollectedImage() {
    return _imageDao.getAllCollectedImage(0, 200);
  }

  @override
  Future<void> saveTag(TagModel tag) {
    return _tagDao.saveTag(tag);
  }




}